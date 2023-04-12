// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConvertor {
     function getPrice() internal  view returns(uint256) {
        // we need ABI and address (0x694AA1769357215DE4FAC081bf1f309aDC325306)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // price =  ETH price in terms of USD
        // 3000.00000000 (8 decimals)

        return uint256(price * 1e10); // 1e10 = 1**10 = 10000000000
    }

    function getVersion() internal view returns(uint256) {
          AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 3000_000000000000000000 = ETH / USD price
        uint256 ethAmountInUsd = (ethPrice * ethAmount)/1e18;
        return ethAmountInUsd;
    }
}