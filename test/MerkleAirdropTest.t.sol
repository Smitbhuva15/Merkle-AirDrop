// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {Test,console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {BagelToken} from "../src/BagelToken.sol";
import {DeployMerkle} from "../script/DeployMerkle.s.sol";

contract MerkleAirdropScript is Test {
    MerkleAirdrop private airdrop;
    BagelToken private token;
    address USER;
    address GASPAYER;
    uint256 USERPRIVATEKEY;

    bytes32 PROOF1=0x9e10faf86d92c4c65f81ac54ef2a27cc0fdf6bfea6ba4b1df5955e47f187115b;
    bytes32   PROOF2 = 0x9644b828caa0331624587198b7d8ecdd6fc8a265015baf94cd5375186fad3c8f;
    bytes32[] PROOF=[PROOF1,PROOF2];
    bytes32 ROOT=0x558d1c6cf0afcd6495a2dc0bffce697c4b23932a59392a4462061767385a72f6;

    uint256 AMOUNT=2500 * 1e18; // Example amount
    uint256 AMOUNT_CONTRACT=AMOUNT * 4; // Total amount for all users in the airdrop


    function setup() internal{ 
        DeployMerkle deployMerkle = new DeployMerkle();
        (token, airdrop) = deployMerkle.run(); // Deploy the airdrop contract and token

        token.mint(address(airdrop), AMOUNT_CONTRACT); // Mint tokens to the airdrop contract
        (USER,USERPRIVATEKEY) = makeAddrAndKey("user"); // Create a user address and private key
        GASPAYER = makeAddr("gasPayer"); // Create a gas payer address
    }

    function testclaim() public {
        uint256 startingBalance = token.balanceOf(USER);
  
        vm.startPrank(USER);
       bytes32 messageHash = airdrop.getMessageHash(USER, AMOUNT);
       (uint8 v, bytes32 r, bytes32 s) = vm.sign(USERPRIVATEKEY, messageHash);
        vm.stopPrank();



        vm.startPrank(GASPAYER); // Start a prank as the gas payer
        airdrop.claim(USER, AMOUNT, PROOF, v, r, s); // User claims the airdrop
        vm.stopPrank();

        uint256 endingBalance = token.balanceOf(USER);
        vm.stopPrank();

    }

}