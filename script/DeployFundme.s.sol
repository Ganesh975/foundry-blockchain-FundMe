// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";

import {FundMe} from "../src/fundme.sol";
import{HelperConfig} from "./HelperConfig.s.sol";
contract depolyfundme is Script{
    function run() external returns(FundMe){
        HelperConfig helperconfig=new HelperConfig();
        address ethusdpricefeed=helperconfig.activenetworkconfig();

        vm.startBroadcast();
        FundMe fundme=new FundMe(ethusdpricefeed);
        vm.stopBroadcast();
        return fundme;

    }

}