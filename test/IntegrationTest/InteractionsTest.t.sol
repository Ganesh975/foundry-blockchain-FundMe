// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {depolyfundme} from "../../script/DeployFundme.s.sol";
import {FundFundMe,withdrawFundMe} from "../../script/interactions.s.sol";

contract interactionstest is Test{

    address USER=makeAddr("user");
    FundMe fundme;

    function setUp() external{
        
        depolyfundme dfundme=new depolyfundme();
        fundme=dfundme.run();
        vm.deal(USER,10 ether);
    }


    function testusercanfundinteractions() public {
        FundFundMe fundfundme=new FundFundMe();
        fundfundme.fundfundme(address(fundme));

        withdrawFundMe withdrawfundme=new withdrawFundMe();
        withdrawfundme.withdrawfundme(address(fundme));

        assertEq(address(fundme).balance,0);

    }
}