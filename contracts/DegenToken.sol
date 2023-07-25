// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    mapping(address => bool) private _banned;

    event MintToken(address indexed to, uint256 value);
    event BurnToken(address indexed from, uint256 value);
    event RedeemGameReward(address indexed player, string itemName);

    constructor() ERC20("Degen", "DGN") {}

    function mint(address to, uint256 amount) external onlyOwner  {
        _mint(to, amount);
        emit MintToken(to, amount);
    }

    function burntokens(uint256 amount) external {
        require(balanceOf(msg.sender)>= amount, "You do not have enough Tokens in your account");
        _burn(msg.sender, amount);
        emit BurnToken(msg.sender, amount);
    }

    function RewardsStore() public pure returns(string memory) {
            return "1. Expensive Outfit (value = 500 Degen)\n2. Strong Sword (value = 300 Degen)\n3. Big Shield (value = 100 Degen)";
        }

    function redeem(uint256 choice) external {
        require(choice <= 3, "Invalid selection");

        if (choice == 1) {
            require(balanceOf(msg.sender) >= 500, "Insufficient balance");
            approve(msg.sender, 500);
            transferFrom(msg.sender, owner(), 500);
            emit RedeemGameReward(msg.sender, "Expensive Outfit");
        } else if (choice == 2) {
            require(balanceOf(msg.sender) >= 300, "Insufficient balance");
            approve(msg.sender, 300);
            transferFrom(msg.sender, owner(), 300);
            emit RedeemGameReward(msg.sender, "Strong Sword");
        } else if (choice == 3) {
            require(balanceOf(msg.sender) >= 100, "Insufficient balance");
            approve(msg.sender, 100);
            transferFrom(msg.sender, owner(), 100);
            emit RedeemGameReward(msg.sender, "Big Shield");
        }
    }

    function checkBalance() external view returns(uint){
           return balanceOf(msg.sender);
    }


    function transfer(address reciever, uint256 amount) public override returns (bool) {
        return super.transfer(reciever, amount);
    }

    function transferFrom(address sender, address reciever, uint256 amount) public override returns (bool) {
        approve(msg.sender, amount);
        return super.transferFrom(sender, reciever, amount);
    }


}