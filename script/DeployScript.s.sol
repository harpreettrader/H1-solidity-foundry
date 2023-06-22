// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";


contract DeployScript is Script {
    function setUp() public {}

    function run() public  returns(FundMe){
        HelperConfig helperConfig = new HelperConfig();
        address ethusdPriceFeed = helperConfig.activeNetWorkConfig();
                vm.startBroadcast();
        // new FundMe(address(this));
        FundMe fundMe = new FundMe(ethusdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
  
}
