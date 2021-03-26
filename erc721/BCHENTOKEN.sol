pragma solidity 0.8.1;

import "./ERC721URIStorage.sol";
import "./utils/Counter.sol";

contract BCHENTOKEN is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("NFT-Example", "NEX") {}

    function mintNft(address receiver, string memory tokenURI) external returns (uint256) {
        _tokenIds.increment();

        uint256 newNftTokenId = _tokenIds.current();
        _mint(receiver, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenURI);
        return newNftTokenId;
    }
}
