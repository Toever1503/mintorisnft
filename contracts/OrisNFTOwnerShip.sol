// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.19;

import "./erc721.sol";
import "./safemath.sol";
import "./nftfactory.sol";

contract OrisNFTOwnerShip is NFTFactory, ERC721 {
    using SafeMath for uint256;

    mapping(uint => address) orisNftApprovals;

    modifier onlyOwnerOf(uint _tokenId) {
        require(owner() == orisNftToOwner[_tokenId]);
        _;
    }

    modifier notOfSender(uint _tokenId) {
        require(
            msg.sender != orisNftToOwner[_tokenId],
            "The sender must not be owner of this token"
        );
        _;
    }

    function balanceOf(
        address _owner
    ) external view override returns (uint256) {
        return ownerOrisNftCnt[_owner];
    }

    function ownerOf(
        uint256 _tokenId
    ) external view override returns (address) {
        return orisNftToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerOrisNftCnt[_to] = ownerOrisNftCnt[_to].add(1);
        ownerOrisNftCnt[msg.sender] = ownerOrisNftCnt[msg.sender].sub(1);
        orisNftToOwner[_tokenId] = _to;
        delete orisNftApprovals[_tokenId];
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable override {
        require(
            orisNftToOwner[_tokenId] == msg.sender ||
                orisNftApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(
        address _approved,
        uint256 _tokenId
    ) external payable override onlyOwnerOf(_tokenId) {
        orisNftApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    struct MIntTask {
        bool hasInitialled;
        bool hasFollowed;
        bool hasSharedFbPost;
    }

    mapping(address => mapping(uint => MIntTask)) mintUsers;

    function mintNftStatus(
        uint _tokenId
    ) public view returns (MIntTask memory) {
        MIntTask memory task = mintUsers[msg.sender][_tokenId];
        require(task.hasInitialled);
        return task;
    }

    function beginMint(uint _tokenId) public notOfSender(_tokenId) {
        MIntTask memory task = MIntTask(false, false, false);
        require(!task.hasInitialled);
        task.hasInitialled = true;
        mintUsers[msg.sender][_tokenId] = task;
    }

    function hasFollowedFb(uint _tokenId) public notOfSender(_tokenId) {
        MIntTask storage task = mintUsers[msg.sender][_tokenId];
        require(task.hasInitialled);
        task.hasFollowed = true;
    }

    function hasSharedFbPost(uint _tokenId) public notOfSender(_tokenId) {
        MIntTask storage task = mintUsers[msg.sender][_tokenId];
        require(task.hasInitialled);
        task.hasSharedFbPost = true;
    }

    function claimOrisNft(uint _tokenId) public notOfSender(_tokenId) {
        require(msg.sender != orisNftToOwner[_tokenId]);
        MIntTask storage task = mintUsers[msg.sender][_tokenId];
        require(task.hasInitialled && task.hasFollowed && task.hasSharedFbPost, "You must follow fb and share a post!");
        _transfer(owner(), msg.sender, _tokenId);
    }
}
