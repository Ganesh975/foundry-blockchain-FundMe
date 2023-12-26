// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/Mockv3aggregator.sol";


contract HelperConfig is Script{
    Networkconfig public activenetworkconfig;
    uint8 public constant decimals=8;
    int256 public constant initial_price=2000e8;

    

struct Networkconfig{
    address pricefeed;
}

    

    constructor(){
        if(block.chainid==11155111){
            activenetworkconfig=getsepholiaconfig();
        }else if(block.chainid==1){
            activenetworkconfig=getmainnetconfig();
        }
        else{
            activenetworkconfig=envilnetworkconfig();
        }

    }


    function getsepholiaconfig() public pure returns (Networkconfig memory){
        Networkconfig memory sepholiaconfig=Networkconfig((0x694AA1769357215DE4FAC081bf1f309aDC325306));
        return sepholiaconfig;

    }

    function getmainnetconfig() public pure returns (Networkconfig memory){
        Networkconfig memory mainconfig=Networkconfig((0x694AA1769357215DE4FAC081bf1f309aDC325306));
        return mainconfig;

    }
    function envilnetworkconfig() public returns (Networkconfig memory){
        if (activenetworkconfig.pricefeed!=address(0)){
            return activenetworkconfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockpricefeed=new MockV3Aggregator(decimals,initial_price);
        vm.stopBroadcast();

        Networkconfig memory anivlconfig=Networkconfig((address(mockpricefeed)));
        return anivlconfig;
    }
}