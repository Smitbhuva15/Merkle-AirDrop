// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract MerkleAirdrop {

    address [] public claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    constructor(bytes32 merkleRoot, IERC20 airDropToken) {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }








}