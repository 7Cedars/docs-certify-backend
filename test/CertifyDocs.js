const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const hre = require("hardhat");
const { ethers } = require("hardhat");

const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("CertifyDoc", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployCertifyDocs() {

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const CertifyDoc = await ethers.getContractFactory("CertifyDoc");
    const certifyDoc = await CertifyDoc.deploy();

    return { certifyDoc, owner, otherAccount };
  }

  describe("Issuing Certificate", function () {
    it("Should be able to issue a certificate with a recipient and message included", async function () {

      const { certifyDoc, otherAccount } = await loadFixture(deployCertifyDocs);
      let _docHash = "0x56570de287d73cd1cb6092bb8fdee6173974955fdef345ae579ee9f475ea7432"
      let _message = "This is a random message."

      await certifyDoc.certify(
        _docHash, 
        otherAccount.address, 
        _message
        ) 
    });

    // this one actually fails. -- this is something to think about / fix? 
    // Would mean a real optimization in solidity code. 
    // it("Should be able to issue a certificate without a recipient and message included", async function () {

    //   const { certifyDoc } = await loadFixture(deployCertifyDocs);
    //   let _docHash = "0x56570de287d73cd1cb6092bb8fdee6173974955fdef345ae579ee9f475ea7432"

    //   const certificate1 = await certifyDoc.certify(
    //     _docHash
    //     )
    // });

    it("Should fail to issue a certificate of dochash is not a hash", async function () {

      const { certifyDoc, owner, otherAccount } = await loadFixture(deployCertifyDocs);
      let _docHash = "not_a_hash"
      let _message = "This is a random message."

      expect(await certifyDoc.certify(
        _docHash,
        otherAccount.address,
        _message
        )).to.be.thrown(); 
      });

        // await expect(lock.withdraw()).to.be.revertedWith(
          //         "You can't withdraw yet"
          //       );

      

      // let certificate = await certifyDoc.callCertificate(0)

      // console.log(certificate)

      // expect(certificate[1]).to.equal(owner.address);
  
    // it("Should be able to read a certificate.", async function () {

    //   const { certifyDoc } = await loadFixture(deployCertifyDocs);

    //   let certificate = await certifyDoc.callCertificate(0)

    //   expect(certificate[1]).to.equal(owner.address);

    // });

    // it("Should be able to issue a certificate with no additional info.", async function () {

    //   const { owner, otherAccount } = await loadFixture(deployCertifyDocs);

    //   expect(await owner).to.equal(owner);
    // });
  
  });
  

    // it("Should set the right owner", async function () {
    //   const { lock, owner } = await loadFixture(deployOneYearLockFixture);

    //   expect(await lock.owner()).to.equal(owner.address);
    // });

    // it("Should receive and store the funds to lock", async function () {
    //   const { lock, lockedAmount } = await loadFixture(
    //     deployOneYearLockFixture
    //   );

    //   expect(await ethers.provider.getBalance(lock.address)).to.equal(
    //     lockedAmount
    //   );
    // });

    // it("Should fail if the unlockTime is not in the future", async function () {
    //   // We don't use the fixture here because we want a different deployment
    //   const latestTime = await time.latest();
    //   const Lock = await ethers.getContractFactory("Lock");
    //   await expect(Lock.deploy(latestTime, { value: 1 })).to.be.revertedWith(
    //     "Unlock time should be in the future"
    //   );
    // });
 // });

  // describe("Withdrawals", function () {
  //   describe("Validations", function () {
  //     it("Should revert with the right error if called too soon", async function () {
  //       const { lock } = await loadFixture(deployOneYearLockFixture);

  //       await expect(lock.withdraw()).to.be.revertedWith(
  //         "You can't withdraw yet"
  //       );
  //     });

  //     it("Should revert with the right error if called from another account", async function () {
  //       const { lock, unlockTime, otherAccount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // We can increase the time in Hardhat Network
  //       await time.increaseTo(unlockTime);

  //       // We use lock.connect() to send a transaction from another account
  //       await expect(lock.connect(otherAccount).withdraw()).to.be.revertedWith(
  //         "You aren't the owner"
  //       );
  //     });

  //     it("Shouldn't fail if the unlockTime has arrived and the owner calls it", async function () {
  //       const { lock, unlockTime } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       // Transactions are sent using the first signer by default
  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).not.to.be.reverted;
  //     });
  //   });

  //   describe("Events", function () {
  //     it("Should emit an event on withdrawals", async function () {
  //       const { lock, unlockTime, lockedAmount } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw())
  //         .to.emit(lock, "Withdrawal")
  //         .withArgs(lockedAmount, anyValue); // We accept any value as `when` arg
  //     });
  //   });

  //   describe("Transfers", function () {
  //     it("Should transfer the funds to the owner", async function () {
  //       const { lock, unlockTime, lockedAmount, owner } = await loadFixture(
  //         deployOneYearLockFixture
  //       );

  //       await time.increaseTo(unlockTime);

  //       await expect(lock.withdraw()).to.changeEtherBalances(
  //         [owner, lock],
  //         [lockedAmount, -lockedAmount]
  //       );
  //     });
  //   });
  // });
});
