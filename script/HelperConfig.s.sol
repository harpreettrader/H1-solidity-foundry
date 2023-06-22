//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;
import{Script}  from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MocksV3Aggregator.sol";

contract HelperConfig is Script{
    NetWorkConfig public activeNetWorkConfig;
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_VALE = 2000E8;



   

    constructor () {
        if(block.chainid==11155111){
            activeNetWorkConfig = getSepoliaConfig();
        }else{
           activeNetWorkConfig = anvilConfig();
        }
    }

    struct NetWorkConfig {
        address priceFeed;
    }

    function getSepoliaConfig()public pure returns(NetWorkConfig memory){
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }
    function anvilConfig() public  returns(NetWorkConfig memory ){

    if(activeNetWorkConfig.priceFeed != address(0)){
        return activeNetWorkConfig;
    }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL,INITIAL_VALE);
        vm.stopBroadcast();
        NetWorkConfig memory AnvilConfig = NetWorkConfig({priceFeed:address(mockPriceFeed)});
        return AnvilConfig;
    }
}