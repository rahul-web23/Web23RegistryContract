// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;
pragma experimental ABIEncoderV2;

import "./TLDRegistry.sol";
abstract contract AlphaInterface {
   
   function registerTLD(TLDRegistry _objectTLD,address _tldOwnerAddress,string memory _tldName,int64 _provideId,int64 _chainId, uint256 _expiry ) virtual external  returns(bool);
   function deactivateTLD(string memory _tldName) virtual external  returns(bool);
   function activateTLD(string memory _tldName) virtual external  returns(bool);
   function updateExpiry(string memory _tldName,uint256 _expiry) virtual external  returns(bool);
   function isTLDAvailable(string memory _tldName) external virtual view returns(bool);
   function getTLDRegistry(string memory _tldName) external virtual view returns(TLDRegistry);
   function isTLDActive(string memory _tldName) external virtual  view returns(bool);
   
}