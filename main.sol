// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.5;

contract Raffle {
    // Persons who purchase a participation
    address payable[] public participants;
    // Person who deploys the contract
    address public admin;
    // Raffle ID
    uint raffleId;
    // History of the ruffles
    mapping(uint => address payable) public raffleHistory;

    modifier onlyAdmin(address _address) { require(_address == admin, "This action is restricted by the admin"); _; }

    constructor() {
        admin = msg.sender;
        raffleId = 1;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns(address payable[] memory) {
        return participants;
    }

    function getRaffleHistoryByRaffle(uint _raffleId) public view returns(address payable) {
        return raffleHistory[_raffleId];
    }

    function bid() public payable {
        // If a remove ether keywork, the default is gwei
        require(msg.value > .01 ether, "The bid must be more than 0.01 ether");

        // Cast the sender address to a payable address
        participants.push(payable(msg.sender));
    }

    function endRaffle() onlyAdmin(msg.sender) public {
        address payable beneficiary = participants[randMod(participants.length)];
        // Send the balance of this contract to the winner
        beneficiary.transfer(address(this).balance);
        participants = new address payable[](0);
        raffleHistory[raffleId] = beneficiary;
        raffleId++;
    }
    
    function randMod(uint _modulus) public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % _modulus;
    }
}