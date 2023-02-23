
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Token.sol";

contract TokenShop{
    address private owner;
    address private token;

    constructor(address tokenaddress) public {
        token = tokenaddress;
        owner = msg.sender;
    }


    function buy() public payable {
        
        require(msg.value == 1 ether, "invalid value -> 1eth = 100 token");
        payable(owner).transfer(msg.value);
        require(
            Token(token).allowance(owner, address(this)) >= 100, 
            "Utilisateur non authorise"
        );
        require(
            Token(token).transferFrom(owner, msg.sender, 100), 
            "Erreur lors du transfert"
        );
    }
}
