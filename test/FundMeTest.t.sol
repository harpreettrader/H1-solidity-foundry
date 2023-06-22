//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import{Test , console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployScript} from "../script/DeployScript.s.sol";

contract FundMeTest is Test{
    
    FundMe fundMe ;
    uint256 constant STARTING_BALANCE = 10 ether;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; 
    uint256 constant GAS_PRICE = 1;
    function setUp() external {
        DeployScript deployScript = new DeployScript();
        fundMe = deployScript.run();
        vm.deal(USER , STARTING_BALANCE);
    //   fundMe  = new FundMe(address(this));
       
    }
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
        function testdemo() public {
            assertEq(fundMe.MINIMUM_USD(),5e18);
           
        }
        function testgetVersion() public {
            uint256 version = fundMe.getVersion();
            assertEq(version,4);
        } 

        function testFailWithoutEnoughEth()  public {
            vm.expectRevert();
            // fundMe.fund();
        }
        function testWithdrowFromSingalfunders() public {
            uint256 StartingOwnerBalance = fundMe.getOwner().balance;
            uint256 StartingFundMeBalance = address(fundMe).balance;
            

            uint256 gasStart = gasleft();
            vm.txGasPrice(GAS_PRICE);
            vm.prank(fundMe.getOwner());
            fundMe.withdraw();
            uint256 gasEnd = gasleft();
            uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
            console.log(gasUsed);


            uint256 endingOwnnerBalance = fundMe.getOwner().balance;
            uint256 endingFundMeBalance = address(fundMe).balance;
            assertEq(endingFundMeBalance , 0);
            assertEq(StartingFundMeBalance + StartingOwnerBalance , endingOwnnerBalance);
        }
        
        function testWithdowFromMultipleFunders()  public funded {
           

            uint160 NumberofFunders = 10;
            uint160 StartingFunderIndex = 2;
            for(uint160 i =StartingFunderIndex; i < NumberofFunders; i++){
            hoax(address(i) , SEND_VALUE);
            fundMe.fund{value:SEND_VALUE}();
            }
            uint256 StartingOwnerBalance = fundMe.getOwner().balance;
            uint256 StartingFundMeBalance = address(fundMe).balance;

            vm.prank(fundMe.getOwner());
            fundMe.withdraw();

            assert(address(fundMe).balance == 0);
            assert(StartingFundMeBalance + StartingOwnerBalance  == fundMe.getOwner().balance);

        } 
        
}
