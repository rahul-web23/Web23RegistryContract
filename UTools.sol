// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.11;
pragma experimental ABIEncoderV2;
contract UTools {
   
  
    constructor(){

    }

    
    function isFirstChar(string memory str,bytes1 delim) internal pure returns (bool) {
        if(bytes(str)[0]==delim)  return true;
        return false;
    }

    function firstChar(string memory str) internal pure returns (bytes1) {
        return bytes(str)[0];
        
    }

    function isValidExpiry(uint256 _expiry) internal view returns(bool){
        
        if(block.timestamp>_expiry){
            return false;
        }
        return true;
    }
    function substring(string memory str, uint startIndex) internal pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(strBytes.length-startIndex);
    for(uint i = startIndex; i < strBytes.length; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
    }

    function substring(string memory str, uint startIndex,uint len) internal pure returns (string memory) {
    bytes memory strBytes = bytes(str);
    bytes memory result = new bytes(strBytes.length-startIndex);
    for(uint i = startIndex; i < strBytes.length && i<len; i++) {
        result[i-startIndex] = strBytes[i];
    }
    return string(result);
    }
   
}