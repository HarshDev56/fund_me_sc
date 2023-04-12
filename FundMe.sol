/*
1. Get Funds from users.
2. withdraw funds.
3. set a minimum funding value in USD.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "contracts/PriceConvertor.sol";

contract FundMe {
    using PriceConvertor for uint256;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

   address public immutable i_owner;
   constructor() {
       i_owner = msg.sender;
   }

    address[] public funders;
    mapping(address=>uint256) public addressToAmountFunded;

    function fund() public payable {
        // want to able to set a minimum fund amount in USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 == 1*10**18 == 1000000000000000000
        // 18 decimal
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {

      
        for (uint256 funderIndex=0; funderIndex<funders.length; funderIndex++) 
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the funders
        funders = new address[](0);
       
        // // withdraw fund has three ways 
        // // 1. transfer
        // // msg.sender = address
        // // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);
        // // 2. send
        // bool transferSucess =  payable(msg.sender).send(address(this).balance);
        // require(transferSucess,"Send Failed");

        // 3. call
        (bool callSucess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSucess,"Send Failed");
    }

    modifier onlyOwner {
         require(msg.sender==i_owner,"Sender is not owner!");
         _;
    }
    receive() external payable {
      fund();
    }

    fallback() external payable {
      fund();
    }
}
