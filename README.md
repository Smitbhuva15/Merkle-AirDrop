 <h1 align="center"> 📦 AirDrop 📦</h1>

 <br>

 ## 🪂  What is an Airdrop?

 - Airdrop means sending free tokens to many users' wallets — usually for promotion, reward, or community engagement.

 <br>

 ## ✍️  What is a Signature?

 - A signature in crypto is like digitally proving it's you (your wallet) who approved something.

      - It's created using your private key.

      - Anyone can verify your signature using your public address.

<br>

## 🌳  What is a Merkle Tree?

- A Merkle Tree is a way to store and verify a lot of data efficiently — like a tree of hashes.      

<br>

## 🧩  What is a Merkle Root?
- The Merkle Root is the top hash of the Merkle Tree — it represents all the data below it.

    - It’s stored in the smart contract.

    - When someone claims an airdrop, they provide a Merkle Proof (like a path of hashes).

    - The contract uses the proof to verify that user is in the tree without seeing the full list.
    

    
 
### Claim Function

```

    function claim(address account,uint256 amount,bytes32[] calldata merkleProof,uint8 v, bytes32 r, bytes32 s) external{
     if(hasClaimed[account]) {
            revert MerkleAirdrop__AlreadyClaimed();
        }

         if (!_isValidSignature(account, getMessageHash(account, amount), v, r, s)) {
            revert MerkleAirdrop__InvalidSignature();
        }

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

```