// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {IWorldID} from "./IWorldID.sol";

contract Polling {

    //This is a struct for a current poll
    struct Poll {
        string s_name;  
        uint s_agree;
        uint s_disagree;
        uint s_prize_pool;

        //address[] s_voters; just transfer after they vote
    }

    mapping (string => mapping(address => bool)) nullifierHashes;

    // A dynamically-sized array of `Poll` structs.
    Poll[] public s_polls;

    mapping(string => Poll) pollNameToPoll;
    mapping(string => uint) pollNameToBalance;
    //add pollname to exists


    string app_id = "app_staging_098f87ae096baeb76fc81cf587159e87";

    IWorldID internal immutable worldId = IWorldID(0x719683F13Eeea7D84fCBa5d7d17Bf82e03E3d260);

    constructor() payable{

    }

    function createPoll(string memory _name, uint _prize) public payable{
        //In mappings values are initialized to 0/false. Require that a poll with this name has not been created before
        require(pollNameToBalance[_name] == 0);
        //require that enoughj funds to fund the prize was provided
        require(msg.value >= _prize);
        require(msg.value > 0);


        //transfer the money to this contract
        payable(address(this)).transfer(msg.value);

        Poll memory newPoll = Poll(_name, 0, 0, _prize);
        pollNameToPoll[_name] = newPoll;
        pollNameToBalance[_name] = _prize;
    }

    function increasePrize(string memory _name, uint _prize) public payable{
        //In mappings values are initialized to 0/false. Require that a poll with this name has not been created before
        require(pollNameToBalance[_name] > 0);
        //require that enoughj funds to fund the prize was provided
        require(msg.value >= _prize);
    }

    function vote(
        string calldata _name, 
        string calldata _vote, address signal,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof) external {
            Poll memory current_poll = pollNameToPoll[_name];
            // First, we make sure this person hasn't done this before
            if (nullifierHashes[_name][msg.sender]) revert();

            // We now verify the provided proof is valid and the user is verified by World ID
            worldId.verifyProof(
            root,
            1, // Or `0` if you want to check for phone verification only
            abi.encodePacked(signal).hashToField(),
            nullifierHash,
            abi.encodePacked(app_id).hashToField(),
            proof
            );

            // We now record the user has done this, so they can't do it again (proof of uniqueness)
            current_poll.nullifierHashes[nullifierHash] = true;

            // Finally, execute your logic here, for example issue a token, NFT, etc...

    }



}