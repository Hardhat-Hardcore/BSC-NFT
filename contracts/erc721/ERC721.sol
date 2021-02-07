// SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC165.sol";
import "../utils/Address.sol";

contract ERC721 is IERC721 {
    using Address for address;

    mapping(address => uint256) public balances;
    mapping(uint256 => address) public nftOwners;
    mapping(uint256 => address) public approvedOperator;
    mapping(address => mapping(address => bool)) public approvedForAll;

    function supportsInterface(bytes4 _interfaceId)
        external
        view
        override
        returns (bool)
    {
        if (
            _interfaceId == IERC721.interfaceId ||
            _interfaceId == IERC721Metadata.interfaceId ||
            _interfaceId == IERC165.interfaceId
        ) {
            return true
        }
        return false
    }

    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256)
    {
        require(_owner != address(0), "Zero address is not allowed");
        return balances[_owner];    
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        override
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
        override
    {
        require(nftOwners[_tokenId] == _from, "Not nft owner");
        require(
            msg.sender == _from ||
            msg.sender == approvedOperator[_tokenId] ||
            msg.sender == approvedForAll[_tokenId],
            "Not authorized"
        )
        
        _transfer(_from, _to, _tokenId); 
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    )
        external
        override
    {
        require(nftOwners[_tokenId] == _from, "Not nft owner");
        require(
            msg.sender == _from ||
            msg.sender == approvedOperator[_tokenId] ||
            msg.sender == approvedForAll[_tokenId],
            "Not authorized"
        )
        
        _transfer(_from, _to, _tokenId); 
        
        require(_checkOnERC721Received(_from, _to, _tokenId, _data), "Transfer to non ERC721Receiver implementer");
    }

    function approve(
        address _to,
        uint256 _tokenId
    )
        external
        override
    {
        address owner = nftOwners[_tokenId];
        require(msg.sender == owner || approvedForAll[owner][msg.sender] , "Not authorized"); 
        approvedOperator[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    function getApproved(uint256 _tokenId)
        external
        view
        override
        returns (address);
    {
        return approvedOperator[_tokenId];
    }

    function setApprovalForAll(
        address _operator,
        bool _approved
    )
        external
        override
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
        returns approvedForAll[_owner][_operator];
    }

    function _checkOnERC721Received(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    )
        private returns (bool)
    {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("transfer to non ERC721Receiver implementer");
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
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
