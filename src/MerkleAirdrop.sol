// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {IERC20,SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import { SignatureChecker } from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { MessageHashUtils } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import { EIP712 } from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";


contract MerkleAirdrop is EIP712 {

    address [] public claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airDropToken;

    bytes32 private constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account,uint256 amount)");

    using SafeERC20 for IERC20;

    struct AirdropClaim {
        address account;
        uint256 amount;
    }


    //////////////////////      mapping      //////////////////////

    mapping(address => bool) public hasClaimed;

    //////////////////////      errors         //////////////////////

    error MerkleAirdrop__InvalidProof();
    error MerkleAirdrop__AlreadyClaimed();
    error MerkleAirdrop__InvalidSignature();    

    /////////////////////      events         //////////////////////

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airDropToken) EIP712("MerkleAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airDropToken = airDropToken;
    }

    function claim(address account,uint256 amount,bytes32[] calldata merkleProof,uint8 v, bytes32 r, bytes32 s) external{
     if(hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

         if (!_isValidSignature(account, getMessageHash(account, amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
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


     function getMessageHash(address account, uint256 amount) public view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({ account: account, amount: amount })))
        );
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }
    function getAirDropToken() external view returns (IERC20) {
        return i_airDropToken;
    }



 function _isValidSignature(
        address signer,
        bytes32 digest,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        internal
        pure
        returns (bool)
    {
        (
            address actualSigner,
            
            ,
            
        ) = ECDSA.tryRecover(digest, _v, _r, _s);
        return (actualSigner == signer);
    }




}