// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
NB TODO: General description of contract! 
*/

contract CertifyDoc {
    
    // creates certificate struct. Consists of hash of document, issuer address, recipient address, a description and date of issuance. 
    struct certificate {
        string docHash;
        address issuer;
        address recipient;
        string description;
        uint datetime;
    }
    certificate[] public certificates; // array of certificates, expands as certificates are issued. 
    
    // to be able to retrieve certificates per document, issuer or recipient later on, we create three mappings: 
    // a map of certificate indexes per document. (key = docHash, value is index of certificates)   
    mapping(string => uint[]) public docHashMap; 

    // a map of certificate indexes per issuer. (key = msg.sender, value is index of certificates) 
    mapping(address => uint[]) public issuerMap;   

    // a map of certificate indexes per document. (key = address, value is index of certificates)
    mapping(address => uint[]) public recipientMap;

    // a map of index to address. (key = string of docHash, value address)
    mapping(string => address) public docHashOwnerMap;

    // creating certificates. Note that location of certificate in certificates array is also mapped in relation to docHash, issuer, and recipient.  
    function certify(string memory _docHash, address _recipient, string memory _description) public {
        certificate storage newCertificate = certificates.push(); 
        newCertificate.docHash = _docHash; 
        newCertificate.issuer = msg.sender; 
        newCertificate.recipient = _recipient; 
        newCertificate.description = _description; 
        newCertificate.datetime = block.timestamp;

        docHashMap[_docHash].push(certificates.length);
        issuerMap[msg.sender].push(certificates.length);
        recipientMap[_recipient].push(certificates.length);

        // If this is the first time this docHash is being certified, the issuer is set as its owner. 
        // The owner of the docHash can revoke any subsequent certificate linked to this docHash. 
        // docHashOwner is transferrable (see function changeDocHashOwner below). 
        if (docHashOwnerMap[_docHash] == 0x0000000000000000000000000000000000000000) {
            docHashOwnerMap[_docHash] = msg.sender;
        }
    }

    // Transfer ownership of docHash to another contract. 
    function changeDocHashOwner(string memory _docHash, address newDocHashOwner) public {
        require(msg.sender == docHashOwnerMap[_docHash], "You are not the owner of this docHash.");
        docHashOwnerMap[_docHash] = newDocHashOwner;
    }
    
    // retrieves index of certificates per docHash, and a bool if the  msg.sender is owner of this docHash. 
    function checkDocHash(string memory _docHash) public view returns ( uint[] memory, bool ) {  
        return (
            docHashMap[_docHash],
            msg.sender == docHashOwnerMap[_docHash]
        );
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
      string memory, address, address, string memory, uint
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