// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract MerkleAirdrop {

    address [] public claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    using SafeERC20 for IERC20;


    //////////////////////      errors         //////////////////////

    error MerkleAirdrop__InvalidProof();

    /////////////////////      events         //////////////////////

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airDropToken) {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }

    function claim(address account,uint256 amount,bytes32[] calldata merkleProof) external{
        // calculate the leaf node hash with the account and amount
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if(!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
 
        // transfer the tokens to the account
        emit Claimed(account, amount);
        i_airDropToken.safeTransfer(account, amount);
    }








}