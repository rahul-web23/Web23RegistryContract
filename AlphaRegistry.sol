// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;
pragma experimental ABIEncoderV2;
import "./AtoZRegistry.sol";
import "./AlphaInterface.sol";
import "./UTools.sol";
import "./TLDRegistry.sol";
contract AlphaRegistry is UTools {
   
   /* Contract Variables and events */
    address administrator;
    int64 providerIndex=1;
    mapping(bytes1=>AlphaInterface) private alphabetsRegister;
    mapping(address=>int64) private providerAddressMapping;
    mapping(address=>bool) private isownerMapping;

    constructor() {
           administrator= msg.sender;
           isownerMapping[msg.sender]=true;
           providerAddressMapping[msg.sender]=providerIndex;
           addAlphaContract(0x61,new AtoZRegistry(0x61)); 
           addAlphaContract(0x62,new AtoZRegistry(0x62)); 
           addAlphaContract(0x63,new AtoZRegistry(0x63)); 
           addAlphaContract(0x64,new AtoZRegistry(0x64)); 
           addAlphaContract(0x65,new AtoZRegistry(0x65)); 
           addAlphaContract(0x66,new AtoZRegistry(0x66)); 
           addAlphaContract(0x67,new AtoZRegistry(0x67)); 
           addAlphaContract(0x68,new AtoZRegistry(0x68)); 
           addAlphaContract(0x69,new AtoZRegistry(0x69)); 
           addAlphaContract(0x6A,new AtoZRegistry(0x6A)); 
           addAlphaContract(0x6B,new AtoZRegistry(0x6B)); 
           addAlphaContract(0x6C,new AtoZRegistry(0x6C)); 
           addAlphaContract(0x6D,new AtoZRegistry(0x6D)); 
           addAlphaContract(0x6E,new AtoZRegistry(0x6E)); 
           addAlphaContract(0x6F,new AtoZRegistry(0x6F)); 
           addAlphaContract(0x70,new AtoZRegistry(0x70)); 
           addAlphaContract(0x71,new AtoZRegistry(0x71)); 
           addAlphaContract(0x72,new AtoZRegistry(0x72)); 
           addAlphaContract(0x73,new AtoZRegistry(0x73)); 
           addAlphaContract(0x74,new AtoZRegistry(0x74)); 
           addAlphaContract(0x75,new AtoZRegistry(0x75)); 
           addAlphaContract(0x76,new AtoZRegistry(0x76)); 
           addAlphaContract(0x77,new AtoZRegistry(0x77)); 
           addAlphaContract(0x78,new AtoZRegistry(0x78)); 
           addAlphaContract(0x79,new AtoZRegistry(0x79)); 
           addAlphaContract(0x7A,new AtoZRegistry(0x7A)); 
    }
     /* modifier that allows only Providers/Owners to execute functions */
     modifier onlyOwner {
        require(isownerMapping[msg.sender],"Denied Access");
        _;
    }

     /* modifier that allows only Administrator of contract to execute functions */
    modifier onlyAdministrator {
        require(msg.sender==administrator,"Denied Access");
        _;
    }

    function addAlphaContract(bytes1 _firstChar,AlphaInterface _object) internal {
        alphabetsRegister[_firstChar]=_object; 
    }
    function _alphaObject(string memory _tldName) internal view returns(AlphaInterface){
        bytes1 firstChar = super.firstChar(_tldName);
        require(abi.encodePacked(alphabetsRegister[firstChar]).length>0,"TLD not exist");
        return alphabetsRegister[firstChar];
    }
    function _tldObject(string memory _tldName) internal view returns(TLDRegistry){
         AlphaInterface _object=_alphaObject(_tldName);
        TLDRegistry _objectTLD=_object.getTLDRegistry(_tldName);
        return _objectTLD;
    }
    function isTLDAvailable(string memory _tldName) external view returns(bool){
        AlphaInterface _object=_alphaObject(_tldName); 
        return _object.isTLDAvailable(_tldName);
    }

    function registerTLD(address _tldOwnerAddress,string memory _tldName,int64 _chainId, uint256 _expiry )  external payable onlyOwner  returns(bool){
    require(isValidExpiry(_expiry),"Invalid Expiry Time");
       bytes1 firstChar = super.firstChar(_tldName);
        AlphaInterface _object=alphabetsRegister[firstChar];
        TLDRegistry _objectTLD=new TLDRegistry(_tldName);
        address payable payTo=payable(administrator);
         (bool success,) = payTo.call{value: 10000000}("");
         if(success){
              return _object.registerTLD(_objectTLD,_tldOwnerAddress,_tldName,providerAddressMapping[msg.sender],_chainId,_expiry );
         }
         else{
             return success;
         }
       
        
    } 

    function registerDomain(address _domainOwnerAddress,string memory _tldName,string memory _domainName,int64 _chainId, uint256 _expiry ) external payable onlyOwner returns(bool){
        require(isValidExpiry(_expiry),"Invalid Expiry Time");
        bytes1 firstChar = super.firstChar(_tldName);
        AlphaInterface _object=alphabetsRegister[firstChar];
        require(_object.isTLDActive(_tldName),"TLD is not active");
        TLDRegistry _objectTLD=_object.getTLDRegistry(_tldName);
        address payable payTo=payable(administrator);
         (bool success,) = payTo.call{value: 1000000}("");
         if(success){
        return _objectTLD.registerDomain(_domainOwnerAddress,_tldName,_domainName,providerAddressMapping[msg.sender],_chainId,_expiry);
         }else{
             return success;
         }
    }

    function activateDomain(string memory _tldName,string memory _domainName) external onlyOwner returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.activateDomain(_domainName);
    }

    function deactivateDomain(string memory _tldName,string memory _domainName) external onlyOwner returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.deactivateDomain(_domainName);
    }

    function isDomainAvailable(string memory _tldName,string memory _domainName) external view returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.isDomainAvailable(_domainName);
    }

    function updateDomainExpiry(string memory _tldName,string memory _domainName,uint256 _expiry) external onlyOwner returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.updateExpiry(_domainName,_expiry);
}


    function updateDomainReserveList(string memory _tldName,string memory _reserveSubDomain, bool _status) external onlyAdministrator returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.updateReserveList(_reserveSubDomain,_status);
    }

    function mapDomainWallet(string memory _tldName,string memory _reserveSubDomain,string memory _address) external onlyOwner returns(bool){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.mapWallet(_reserveSubDomain,_address);
    }


    function getMappedWallet(string memory _tldName,string memory _reserveSubDomain) external  view returns(string memory){
       TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.getMappedWallet(_reserveSubDomain);

    }

    function deactivateTLD(string memory _tldName) external  returns(bool){
       AlphaInterface _object=_alphaObject(_tldName);  
        return _object.deactivateTLD(_tldName);
    }
    function activateTLD(string memory _tldName) external  returns(bool){
        AlphaInterface _object=_alphaObject(_tldName);  
        return _object.activateTLD(_tldName);
    }
    function updateTLDExpiry(string memory _tldName,uint256 _expiry) external  returns(bool){
        AlphaInterface _object=_alphaObject(_tldName);  
        return _object.updateExpiry(_tldName,_expiry);
    }

    function addProvider(address _providerAddress) external onlyAdministrator returns(bool){
        isownerMapping[_providerAddress]=true;
        providerIndex=providerIndex+1;
        providerAddressMapping[_providerAddress]=providerIndex;
        
        return true;
    }

    function getProvider(string memory _tldName,string memory _domainName) external view returns(int64){
        TLDRegistry _objectTLD=_tldObject(_tldName);
        return _objectTLD.getProvider(_domainName);
    }


       
}