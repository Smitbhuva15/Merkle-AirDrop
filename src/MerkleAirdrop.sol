// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract MerkleAirdrop {

    address [] public claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    using SafeERC20 for IERC20;

    //////////////////////      mapping      //////////////////////

    mapping(address => bool) public hasClaimed;

    //////////////////////      errors         //////////////////////

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();

    /////////////////////      events         //////////////////////

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airDropToken) {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }

    function claim(address account,uint256 amount,bytes32[] calldata merkleProof) external{
     if(hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

        // calculate the leaf node hash with the account and amount

        // two times keccak256 is used to ensure that the leaf node is unique
        // and to prevent any potential collisions
        // first keccak256 hashes the account and amount
        // second keccak256 hashes the result of the first keccak256
        // this is a common pattern in Merkle trees to ensure uniqueness
        // and to prevent any potential collisions
        // the leaf node is a hash of the account address and the amount
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if(!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }
        // mark the account as claimed
        hasClaimed[account] = true;
 
        // transfer the tokens to the account
        emit Claimed(account, amount);
        i_airDropToken.safeTransfer(account, amount);
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }
    function getAirDropToken() external view returns (IERC20) {
        return i_airDropToken;
    }








}