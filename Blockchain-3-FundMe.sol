// SPDX-License-Identifier: MIT
// Yunus GUMUSSOY - The First Step of Being a Blockchain Developer

pragma solidity ^0.6.10;

// importing chainlink interface compile down to an ABI
// ABI Application Binary Interface tells solidity and other programming languages
// how it can interact with another contract
// anytime we want to interact with an already deployed smart contract we will need an ABI
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

/*
interface AggregatorV3Interface {
        function decimals() external view returns (uint8);
        function description() external view returns (string memory);
        function version() external view returns (uint256);
    
    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
        function getRoundData(uint80 _roundId)
            external
            view
            returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
            );

        function latestRoundData()
            external
            view
            returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}
*/

contract FundMe {
    using SafeMathChainlink for uint256;
    
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    // payable is used to make it available for payments
    function fund() public payable {
        //$50
        uint256 minimumUSD = 50 * 10 ** 18;

        // ETH -> USD conversion rate
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value; // msg.sender is the sender of money, msg.value is the amount of money sent
        funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        // we get this adress from the related testnet website
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // we write uint256(answer) because in the imported file, answer is int256, so we need to convert it
         return uint256(answer * 10000000000);
    }
    
    // 1000000000
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }
    
    modifier onlyOwner {
        // == means true or false
        require(msg.sender == owner);
        _;
    }
    // we may want that only owner can withdraw money from the address
    function withdraw() payable onlyOwner public {
        // "this" means the contract we are currently in, and adress(this) refers the address of the contract
        msg.sender.transfer(address(this).balance);
        
        // we create a loop here, funders is an array
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}
