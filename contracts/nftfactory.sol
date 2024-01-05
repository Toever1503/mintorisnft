// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.19;

import "./ownable.sol";
import "./safemath.sol";

abstract contract NFTFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    struct OrisNFT {
        string name;
    }

    OrisNFT[] private orisNFTs;

    mapping(uint => address) public orisNftToOwner;
    mapping(address => uint) ownerOrisNftCnt;

    event NewOrisNft(uint id, string name);

    modifier onlyOrisNftOfCreator(uint _tokenId) {
        require(orisNftToOwner[_tokenId] == owner(), "This token is not belong to creator!");
        _;
    }

    function createOrisNft(string memory _name) public onlyOwner{
        OrisNFT memory newOrisNft = OrisNFT(_name);
        orisNFTs.push(newOrisNft);

        uint id = orisNFTs.length - 1;
        orisNftToOwner[id] = msg.sender;
        ownerOrisNftCnt[msg.sender] = ownerOrisNftCnt[msg.sender].add(1);
        emit NewOrisNft(id, _name);
    }

    function listOrisNftOf(
        address _address
    ) public view returns (OrisNFT[] memory) {
        OrisNFT[] memory nfts = new OrisNFT[](ownerOrisNftCnt[_address]);
        uint j = 0;
        for (uint i = 0; i < ownerOrisNftCnt[_address]; i++) {
            if (orisNftToOwner[i] == msg.sender) nfts[j++] = orisNFTs[i];
        }
        return nfts;
    }

    function detailNft(uint _tokenId) public view returns(OrisNFT memory){
        OrisNFT memory nft = orisNFTs[_tokenId];
        return nft;
    }
}
