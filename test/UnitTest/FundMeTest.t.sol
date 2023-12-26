// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {depolyfundme} from "../../script/DeployFundme.s.sol";

contract fundmetest is Test{

    address USER=makeAddr("user");
    FundMe fundme;
    function setUp() external{
        //fundme=new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        depolyfundme dfundme=new depolyfundme();
        fundme=dfundme.run();
        vm.deal(USER,10 ether);
        
    }
    function testdemo() public{
        assertEq(fundme.MINIMUM_USD(),5e18);
    }

    function testdemoisowner() public{
        assertEq(fundme.i_owner(),msg.sender);
    }
 
    function testpricefeedversion() public{
        assertEq(fundme.getVersion(),4);
    }

    function testfundfails() public {
        vm.expectRevert();
        fundme.fund();
    }

    function testfundupdatesfundedds()  public{
        vm.prank(USER);
        fundme.fund{value:10e18}();
        uint256 amountfunded=fundme.getaddresstoamountfunded(USER);
        console.log(amountfunded);
        assertEq(amountfunded,10e18);
    }

    function testaddfundertoarray() public{
        vm.prank(USER);
        fundme.fund{value:5e18}();
        
        address funder=fundme.getfunder(0);

        assertEq(funder,USER);

    }
    modifier funded() {
        vm.prank(USER);
        fundme.fund{value:5e18}();
        _;

    }

    function onlyownercanwithdraw() public funded{
        

        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw(); 
    }


    function testwithdrawwithusingsinglefunder() public funded{
        uint256 startingoenerbalance=fundme.getowner().balance;
        uint256 startingfundmebalance=address(fundme).balance;

        vm.prank(fundme.getowner());
        fundme.withdraw();

        uint256 endingoenerbalance=fundme.getowner().balance;
        uint256 endingfundmebalance=address(fundme).balance;

        assertEq(endingfundmebalance,0);
        assertEq(endingoenerbalance,startingoenerbalance+startingfundmebalance);



    }


    function testwithdrawofmultiplefunders() public funded{
        uint160 nooffunders=10;
        uint160 startingfunder=1;
        for(uint160 i=startingfunder;i<nooffunders;i++){
            hoax(address(i),6 ether);
            fundme.fund{value:5 ether}();
        }
        uint256 startingoenerbalance=fundme.getowner().balance;
        uint256 startingfundmebalance=address(fundme).balance;


        vm.startPrank(fundme.getowner());
        fundme.withdraw();

        uint256 endingoenerbalance=fundme.getowner().balance;
        uint256 endingfundmebalance=address(fundme).balance;

        assertEq(endingfundmebalance,0);
        assertEq(endingoenerbalance,startingoenerbalance+startingfundmebalance);
        vm.stopPrank();




    }



    function testwithdrawofmultiplefundercheapers() public funded{
        uint160 nooffunders=10;
        uint160 startingfunder=1;
        for(uint160 i=startingfunder;i<nooffunders;i++){
            hoax(address(i),6 ether);
            fundme.fund{value:5 ether}();
        }
        uint256 startingoenerbalance=fundme.getowner().balance;
        uint256 startingfundmebalance=address(fundme).balance;


        vm.startPrank(fundme.getowner());
        fundme.cheaperwithdraw();

        uint256 endingoenerbalance=fundme.getowner().balance;
        uint256 endingfundmebalance=address(fundme).balance;

        assertEq(endingfundmebalance,0);
        assertEq(endingoenerbalance,startingoenerbalance+startingfundmebalance);
        vm.stopPrank();




    }
}