// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0;


contract Lottery{
    address public manager;
    address[] public players;
    uint public balance;
    constructor(
    ){
        manager = msg.sender;
    }


    modifier onlyManagerAccess(){
        require(msg.sender == manager,"Only manager can access this");
        _;
    }

    modifier onlyUserAccess(){
        require(msg.sender != manager, "Manager can't participate!!");
        _;
    }

    function enterToGame() public payable onlyUserAccess {
        
        players.push(msg.sender);
        balance += msg.value;
    }

    function randomlyChooseWinner()private view onlyManagerAccess returns (uint winner) {
        uint randomNumber =  uint(keccak256(abi.encodePacked(blockhash(block.number-1),block.timestamp,players)));
        return randomNumber % players.length;
        
        
    }
    function sendFundToWinner()public payable onlyManagerAccess{
        
        uint winningPlayerIndex = randomlyChooseWinner();
        address payable finalWinner = payable (players[winningPlayerIndex]);
        finalWinner.transfer(balance);
        balance = 0;
        players = new address[](0);
        


    }
}