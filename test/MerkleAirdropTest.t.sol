// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {Test,console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BagelToken} from "../src/BagelToken.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop private airdrop;
    BagelToken private token;
    address USER2;
    address USER=makeAddr("user");
    uint256 USERPRIVATEKEY;

    bytes32 PROOF1=0x9e10faf86d92c4c65f81ac54ef2a27cc0fdf6bfea6ba4b1df5955e47f187115b;
    bytes32   PROOF2 = 0x9644b828caa0331624587198b7d8ecdd6fc8a265015baf94cd5375186fad3c8f;
    bytes32[] PROOF=[PROOF1,PROOF2];
    bytes32 ROOT=0x3ca09a0a65f4de8a762913b0ec8680afc6244a15fccf75ba4a3d1a0693be2595;

    uint256 AMOUNT=2500 * 1e18; // Example amount
    uint256 AMOUNT_CONTRACT=AMOUNT * 4; // Total amount for all users in the airdrop


    function setup() internal{ 
        token=new BagelToken();
        airdrop=new MerkleAirdrop(
            ROOT,
            IERC20(token)
        );
        token.mint(address(airdrop), AMOUNT_CONTRACT); // Mint tokens to the airdrop contract
    }

    function testclaim() public {

        vm.startPrank(USER);
        airdrop.claim(USER, AMOUNT, PROOF);
        vm.stopPrank();

    }

}