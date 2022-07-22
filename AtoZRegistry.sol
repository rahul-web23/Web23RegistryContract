// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;
pragma experimental ABIEncoderV2;
import "./AlphaInterface.sol";
import "./TLDRegistry.sol";
import "./UTools.sol";
contract AtoZRegistry is AlphaInterface,UTools {
    bytes1 FIRSTChar;
    address owner;
    mapping(string=>bool) private tldToStatus;
    struct TldInfo{
        address tldOwnerAddress;
        string tldName;
        int64 provideId;
        uint256 timestamp;
        int8 status;
        uint256 expiry;
        int64 chainId;
    }
    mapping(string=>TldInfo) private tldToDetails;
    mapping(string=>TLDRegistry) private tldRegistryMapping;
    
    constructor(bytes1 _char)  {
            owner= msg.sender;
		    FIRSTChar=_char;
        }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }





function isProperBTLD(string memory _tld,bytes1 _firstChar) internal pure returns(bool){

    return isFirstChar(_tld,_firstChar);
    
}

function registerTLD(TLDRegistry _objectTLD,address _tldOwnerAddress,string memory _tldName,int64 _provideId,int64 _chainId, uint256 _expiry )  override external onlyOwner  returns(bool){
    require(isProperBTLD(_tldName,FIRSTChar),"Wrong BTLD");
    require(!tldToStatus[_tldName],"TLD Already Booked");
    TldInfo memory tldInfo;
    tldInfo.tldOwnerAddress=_tldOwnerAddress;
    tldInfo.tldName=_tldName;
    tldInfo.provideId=_provideId;
    tldInfo.status=1;
    tldInfo.timestamp=block.timestamp;
    tldInfo.expiry=_expiry;
    tldInfo.chainId=_chainId;
    tldToStatus[_tldName]=true;
    tldToDetails[_tldName]=tldInfo;
    tldRegistryMapping[_tldName]=_objectTLD;
    return true;
}

function deactivateTLD(string memory _tldName) external override onlyOwner returns(bool){
    require(tldToStatus[_tldName],"TLD doesn't exist");
    tldToDetails[_tldName].status=0;
    return true;
}

function activateTLD(string memory _tldName) external override onlyOwner returns(bool){
    require(tldToStatus[_tldName],"TLD doesn't exist");
    tldToDetails[_tldName].status=1;
    return true;
}


function updateExpiry(string memory _tldName,uint256 _expiry) external override onlyOwner returns(bool){
    require(tldToStatus[_tldName],"TLD doesn't exist");
    require(tldToDetails[_tldName].expiry<_expiry,"Invalid Expiry Date");
    tldToDetails[_tldName].expiry=_expiry;
    return true;
}

function isTLDAvailable(string memory _tldName) external override view returns(bool){
    return !tldToStatus[_tldName];
}

function getTLDRegistry(string memory _tldName) external override view returns(TLDRegistry){
    return tldRegistryMapping[_tldName];
}

function isTLDActive(string memory _tldName) external override view returns(bool){
    require(tldToStatus[_tldName],"TLD doesn't exist");
    return tldToDetails[_tldName].status==1?true:false;
}
    
}