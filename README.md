This is the **backend** of a simple dapp project: certify.doc. The github repository for the frontend can be found [here](https://github.com/7Cedars/docs-certify-frontend.git).

The dapp provides a single utility. It issues records on the blockchain that relate two ethereum addresses (an issuer and recipient address) to the hash of a digital offline document. 
They are somewhat similar to non-fungible tokens (NFTs).

But in contrast to NFTs 
- These records cannot be traded or exchanged. They can only revoked. 
- These records can be easily accessed by uploading the original document. 

Because these records immutable, non-tradable and revokable, they can be used by one party (the issuer) to vouch for the authenticity of the document and, at the same time, the credibility of a second party (the recipient). 

Because these records are related to an offline document that can be send via email, social media or any other traditional method, it is extremely accesible to those that are not familiar with blockchain technology. 

## Getting Started
To view and use the deployed dapp, please visit its deployed instance on vercel: [https://docs-certify-frontend-9iop.vercel.app/](https://docs-certify-frontend-9iop.vercel.app/). Please note that the dapp only runs on the Goerli Ethereum test network.

To view and run the contract locally, see the file at: hardhat/contracts/CertifyDoc.sol. The Remix IDE is arguabbly the easiest way to locally run and test the contract. 

The address of the deployed contract on the goerli ethereum test network is 0xB4AfD5AA80a7D8e01BF3e7F3C8E3917a1De3790f. 

The repository also includes a simple testing suite. See hardhat/test/CertifyDocsTest.js.

## Notes on Development
The contract is extremely simple by intent. It does not depend on outside solidity libraries (for instance from OpenZeppelin), does not interact with other contracts and is not upgradable.  

The main reason for this is that I used this app as an educational project while learning solidity and javascript (react/next). I aimed to write a very basic contract that I could subsequently extend and develop. 

## To Dos 
### Current Contract (v0.1) 
- Optimize gas usage. 
- Set fixed length of messages (making gas estimation easier). 

### Future Contract (v0.2) 
- Implement optional link of file hashes to uploaded files to IPFS. 
- Making use of hashing alg flexible, recording what hashing protocol has been used. 
- Implement upgradable contract. Making the data slots of certificates flexible, and enabling flexible upgrading of types of certificates - while still enabling backwards compatability. 
- Enabling use of the Graph on contract (meaning that emitting of events needs to be further developed). 
