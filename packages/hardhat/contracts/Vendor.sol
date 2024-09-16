// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) payable {
        yourToken = YourToken(tokenAddress);
    }
    
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);
    
    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }
    
    function withdraw() onlyOwner public returns (bool) {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: balance}("");
        return success;
    }
    
    function sellTokens(uint256 _amount) public payable {
        uint256 tokenAmount = _amount / tokensPerEth;
        uint256 contractTokenBalance = yourToken.balanceOf(address(this));
        require(contractTokenBalance >= tokenAmount, "Insufficient token balance in the contract");

        // Transfer tokens from the user to the contract
        bool success = yourToken.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token transfer from seller failed");

        // Transfer Ether to the seller
        (bool ethSuccess, ) = payable(msg.sender).call{value: tokenAmount}("");
        require(ethSuccess, "Ether transfer to seller failed");

        emit SellTokens(msg.sender, _amount, tokenAmount);
    }

    function getBalance() public view returns(uint){
      return address(this).balance;
    }
    
    receive() external payable{

    }
}
