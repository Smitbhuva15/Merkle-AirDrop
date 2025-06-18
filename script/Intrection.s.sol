// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";


contract Intrection is Script {


        address CLAIMING_ADDRESS = 0x1Db3439a222C519ab44bb1144fC28167b4Fa6EE6; // Example address
        uint256 CLAIMING_AMOUNT = 25 * 1e18;

        bytes32 PROOF_ONE=0x31cfa3ba998e027914d6a7add3f1ce0d24f700396ca483340a433ebaa66af6a4;
        bytes32 PROOF_TWO=0x7584073af8a8446696647263a8e7f4c84ba7d205906c23b63b9550047efa0c6b;
        bytes32[] PROOF = [PROOF_ONE, PROOF_TWO];

    function claimAirdrop(address airdropAddress) public{
        vm.startBroadcast();
        MerkleAirdrop(airdropAddress).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, PROOF,v, r, s);
        vm.stopBroadcast();
    }

    function run() external {
       address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }
}
