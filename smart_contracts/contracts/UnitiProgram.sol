// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "smart_contracts/node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract UnitiProgram is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string private programCreator;

    string private uri;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _programCreator
    ) ERC721(_name, _symbol) {
        programCreator = _programCreator;
        uri = _tokenURI;
    }

    function safeMint(address to) external {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function setURI(string memory _uri) external {
        uri = _uri;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
