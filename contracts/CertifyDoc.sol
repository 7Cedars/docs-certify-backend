// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
NB TODO: General description of contract! 
NB: https://docs.ethers.io/v5/api/utils/strings/#Bytes32String 
NB AND: https://docs.ethers.io/v5/api/utils/hashing/!! -- they have hashing algorithms. Of course! 
-- ethers has a js function to convert hash string to bytes32. THS is what I should use!  
*/

contract CertifyDoc {
    
    // creates certificate struct. Consists of hash of document, issuer address, recipient address, a description and date of issuance. 
    struct certificate {
        bytes32 docHash;
        address issuer;
        address recipient;
        uint datetime;
        string description;
    }
    certificate[] public certificates; // array of certificates, expands as certificates are issued. 
    
    // event for logging creation of a certificate
    event CertificateIssued(bytes32 indexed docHash, uint indexed index);
    
    // to be able to retrieve certificates per document, issuer or recipient later on, we create three mappings: 
    // a map of certificate indexes per document. (key = docHash, value is index of certificates)   
    mapping(bytes32 => uint[]) public docHashMap; 

    // a map of certificate indexes per issuer. (key = msg.sender, value is index of certificates) 
    mapping(address => uint[]) public issuerMap;   

    // a map of certificate indexes per document. (key = address, value is index of certificates)
    mapping(address => uint[]) public recipientMap;

    // a map of index to address. (key = string of docHash, value address)
    mapping(bytes32 => address) public docHashOwnerMap;

    // creating certificates. Note that location of certificate in certificates array is also mapped in relation to docHash, issuer, and recipient.  
    function certify(bytes32 _docHash, address _recipient, string memory _description) public {        

            certificate storage newCertificate = certificates.push(); 
            newCertificate.docHash = _docHash; 
            newCertificate.issuer = msg.sender; 
            newCertificate.recipient = _recipient;  // can I make this optional? 
            newCertificate.description = _description; // can I make this optional? 
            newCertificate.datetime = block.timestamp;

            docHashMap[_docHash].push(certificates.length -1);
            issuerMap[msg.sender].push(certificates.length -1);
            recipientMap[_recipient].push(certificates.length -1);

            // If this is the first time this docHash is being certified, the issuer is set as its owner. 
            // The owner of the docHash can revoke any subsequent certificate linked to this docHash. 
            // docHashOwner is transferrable (see function changeDocHashOwner below). 
            if (docHashOwnerMap[_docHash] == 0x0000000000000000000000000000000000000000) {
                docHashOwnerMap[_docHash] = msg.sender;
            }
            
            // An event is emited when a new certificate is issued. 
            emit CertificateIssued(_docHash, certificates.length -1); 
    }

    // // Transfer ownership of docHash to another contract. -- This is for extended version. 
    // function changeDocHashOwner(string memory _docHash, address newDocHashOwner) public {
    //     require(msg.sender == docHashOwnerMap[_docHash], "You are not the owner of this docHash.");
    //     docHashOwnerMap[_docHash] = newDocHashOwner;
    // }
    
    // retrieves index of certificates per docHash. 
    function checkDocHash(bytes32 _docHash) public view returns ( uint[] memory ) {  
        return (docHashMap[_docHash]);
    } 

    // returns true if the  msg.sender is owner of the docHash.
    function checkOwner(bytes32 _docHash) public view returns ( bool ) {
        return (msg.sender == docHashOwnerMap[_docHash]); 
    }

    // retrieves index of certificates per issuer of msg.sender.
    function checkIssuer(address _requestedAddress) public view returns ( uint[] memory ) {  
        return issuerMap[_requestedAddress];
    }

    // retrieves index of certificates per recipient of msg.sender.
    function checkRecipient(address _requestedAddress) public view returns ( uint[] memory ) {
        return recipientMap[_requestedAddress];
    }

    // Retrieves a single certificate based on index.
    // Idea is that frontend first calls checkDocHash or checkSender, and subsequently does a loop to this function. 
    // This places computational demand on side of frontend, not the blockchain backend. 
    // Note that it IS possible to call certificates at random. Certificates are public! 
    function callCertificate(uint index) public view returns (
      bytes32, address, address, string memory, uint
      ) {
        return (
          certificates[index].docHash,
          certificates[index].issuer,
          certificates[index].recipient,
          certificates[index].description,
          certificates[index].datetime
        );
    }

    // Issuer, recipient and docHashOwner have  ability to delete / revoke a document certification.
    function revokeCertificate(uint index) public {
        require(msg.sender == certificates[index].issuer || 
            msg.sender == certificates[index].recipient ||
            msg.sender == docHashOwnerMap[certificates[index].docHash], 
            "You are not allowed to revoke this certificate.");
        
        delete certificates[index];
    }
}