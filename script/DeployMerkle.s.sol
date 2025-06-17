// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {BagelToken} from "../src/BagelToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";


contract DeployMerkle {
    BagelToken public token;
    MerkleAirdrop public airdrop;

    bytes32 public constant ROOT = 0x3ca09a0a65f4de8a762913b0ec8680afc6244a15fccf75ba4a3d1a0693be2595;
    uint256 public constant AMOUNT_CONTRACT = 25 * 1e18 * 4; // Total amount for all users in the airdrop

    function run() external returns (BagelToken, MerkleAirdrop) {
        // Deploy the BagelToken contract
        token = new BagelToken();

        // Deploy the MerkleAirdrop contract with the root and token address
        airdrop = new MerkleAirdrop(
            ROOT,
            IERC20(address(token))
        );

        // Mint tokens to the airdrop contract beacuse it will distribute them
        // to the users based on the Merkle proof
        token.mint(address(airdrop), AMOUNT_CONTRACT);
        return (token, airdrop);
    }

}