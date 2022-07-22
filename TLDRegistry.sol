// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;
pragma experimental ABIEncoderV2;


contract TLDRegistry{

    string TLD;
    mapping(string=>bool) reserveListStatus;
    address owner;
    mapping(string=>bool) private domainToStatus;
    struct DomainInfo{
        address domainOwnerAddress;
        string domainName;
        int64 provideId;
        uint256 timestamp;
        int8 status;
        uint256 expiry;
        int64 chainId;
    }
    mapping(string=>DomainInfo) private domainToDetails;
    mapping(string=>string) private walletMapping;

constructor(string memory _tld) {
        owner= msg.sender;
        TLD=_tld;
        reserveListStatus["sol"]=true;
        reserveListStatus["eth"]=true;
        reserveListStatus["hbar"]=true;
        reserveListStatus["avax"]=true;
        reserveListStatus["btc"]=true;
        reserveListStatus["ada"]=true;
        reserveListStatus["tezos"]=true;
        reserveListStatus["algo"]=true;
        reserveListStatus["iot"]=true;

    }

modifier onlyOwner {
require(msg.sender == owner);
_;
}


function registerDomain(address _domainOwnerAddress,string memory _tldName,string memory _domainName,int64 _provideId,int64 _chainId, uint256 _expiry ) external onlyOwner returns(bool){
    require(keccak256(bytes(_tldName)) == keccak256(bytes(TLD)),"Invalid TLD");
    require(!domainToStatus[_domainName],"Domain Already Booked");
    require(!reserveListStatus[_domainName],"Reserved List");
    DomainInfo memory domainInfo;
    domainInfo.domainOwnerAddress=_domainOwnerAddress;
    domainInfo.domainName=_domainName;
    domainInfo.provideId=_provideId;
    domainInfo.status=1;
    domainInfo.timestamp=block.timestamp;
    domainInfo.expiry=_expiry;
    domainInfo.chainId=_chainId;
    domainToStatus[_domainName]=true;
    domainToDetails[_domainName]=domainInfo;
    return true;
}

function deactivateDomain(string memory _domainName) external onlyOwner returns(bool){
    require(domainToStatus[_domainName],"Domain doesn't exist");
    domainToDetails[_domainName].status=0;
    return true;
}

function activateDomain(string memory _domainName) external onlyOwner returns(bool){
    require(domainToStatus[_domainName],"Domain doesn't exist");
    domainToDetails[_domainName].status=1;
    return true;
}


function updateExpiry(string memory _domainName,uint256 _expiry) external onlyOwner returns(bool){
    require(domainToStatus[_domainName],"Domain doesn't exist");
    require(domainToDetails[_domainName].expiry<_expiry,"Invalid Expiry Date");
    domainToDetails[_domainName].expiry=_expiry;
    return true;
}


function updateReserveList(string memory _reserve, bool _status) external onlyOwner returns(bool){
    reserveListStatus[_reserve]=_status;
    return true;
}

function mapWallet(string memory _reserve,string memory _address) external onlyOwner returns(bool){
    require(reserveListStatus[_reserve],"Reserve list not Found");
    walletMapping[_reserve]=_address;
    return true;

}


function getMappedWallet(string memory _reserve) external  view returns(string memory){
    require(reserveListStatus[_reserve],"Reserve list not Found");
    return walletMapping[_reserve];

}

function getProvider(string memory _domainName) external view returns(int64){
    require(domainToStatus[_domainName],"Domain doesn't exist");
    return domainToDetails[_domainName].provideId;
}

function isDomainAvailable(string memory _domainName) external view returns(bool){
    
    return !domainToStatus[_domainName];
}

    
}