// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "Address.sol";

contract ERC721 {
    using Address for address;
    
    uint256 public id;

    mapping(address => uint256) public balances;
    mapping(uint256 => address) public nftOwners;
    mapping(uint256 => address) public approvedOperator;
    mapping(address => mapping(address => bool)) public approvedForAll;
    mapping(uint256 => string) uri;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return (interfaceID == bytes4(0x01ffc9a7) || interfaceID == bytes4(0x80ac58cd) || interfaceID == bytes4(0x5b5e139f));
    }
    
    function mint(string calldata _uri) external {
        id++;
        nftOwners[id] = msg.sender;
        balances[msg.sender]++;
        uri[id] = _uri;
        
        emit Transfer(address(0), msg.sender, id);
    }
    
    function name() external view returns (string memory _name) {
        return "TOKEN";    
    }
    
    function symbol() external view returns (string memory _symbol) {
        return "NFT";
    }
    
    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        return uri[_tokenId];
    }
    
    function balanceOf(address _owner)
        external
        view
        returns (uint256)
    {
        require(_owner != address(0), "Zero address is not allowed");
        return balances[_owner];    
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        returns (address)
    {
        return nftOwners[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        external
    {
        require(nftOwners[_tokenId] == _from, "Not nft owner");
        require(
            msg.sender == _from ||
            msg.sender == approvedOperator[_tokenId] ||
            approvedForAll[_from][msg.sender],
            "Not authorized"
        );
        
        _transfer(_from, _to, _tokenId); 
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    )
        external
    {
        require(nftOwners[_tokenId] == _from, "Not nft owner");
        require(
            msg.sender == _from ||
            msg.sender == approvedOperator[_tokenId] ||
            approvedForAll[_from][msg.sender],
            "Not authorized"
        );
        
        _transfer(_from, _to, _tokenId); 
        
        require(_checkOnERC721Received(_from, _to, _tokenId, _data), "Transfer to non ERC721Receiver implementer");
    }

    function approve(
        address _to,
        uint256 _tokenId
    )
        external
    {
        address owner = nftOwners[_tokenId];
        require(msg.sender == owner || approvedForAll[owner][msg.sender] , "Not authorized"); 
        approvedOperator[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId)
        external
        view
        returns (address)
    {
        return approvedOperator[_tokenId];
    }

    function setApprovalForAll(
        address _operator,
        bool _approved
    )
        external
    {
        approvedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    )
        external
        view
        returns (bool)
    {
        return approvedForAll[_owner][_operator];
    }

    function _checkOnERC721Received(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    )
        private returns (bool)
    {
        // TODO: Check onReceived
        return true;
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    )
        internal
    {
        balances[_from]--;
        balances[_to]++;
        nftOwners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }
}

