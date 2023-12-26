// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";

import {FundMe} from "../src/fundme.sol";

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script{
    uint256 constant SEND_VALUE=0.01 ether;
    function fundfundme(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value : 1 ether }();
        vm.stopBroadcast();


        console.log("DUNDED DUNDME With %s ",SEND_VALUE);
        
    }

    function run() external {
        vm.startBroadcast();
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
       FundFundMe(mostRecentlyDeployed); 
       vm.stopBroadcast();

    }
}

contract withdrawFundMe is Script{
    function withdrawfundme(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).cheaperwithdraw();
        vm.stopBroadcast();

        
    }

    function run() external {
        vm.startBroadcast();
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
       withdrawFundMe(mostRecentlyDeployed); 
       vm.stopBroadcast();

    }

}