// SPDX-License-Identifier: MIT

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

pragma solidity 0.8.19;

import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "smart_contracts/node_modules/@openzeppelin/contracts/utils/Counters.sol";


/**
 * @title: UnitiProgram
 * @author: Megabyte
 * This contract is the basic implementation of the ERC721 token contract with the set TokenURI function and auto-incrementing tokenIds.
 */
contract UnitiProgram is ERC721Enumerable, ERC721URIStorage {
    ////////////////////
    // Error Messages //
    ////////////////////
    error UnitiProgram__ZeroAddress();


    ////////////////////
    // Libraries //
    ////////////////////
    using Counters for Counters.Counter;

    ////////////////////
    // State Variables //
    ////////////////////
    Counters.Counter private _tokenIdCounter;

    string private s_programCreator;

    string private s_uri;

    ////////////////////
    // Events //
    ////////////////////
    event UnitiProgram__Minted(address indexed _to, uint256 indexed _tokenId);
    event UnitiProgram__TokenURIUpdated(
        string indexed _tokenURI
    );

    ////////////////////
    // Functions //
    ////////////////////
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _programCreator
    ) ERC721(_name, _symbol) {
        s_programCreator = _programCreator;
        s_uri = _tokenURI;
    }


     ////////////////////
    // External Functions //
    ////////////////////

    /**
     * @dev: This function mints a single token to the address specified.
     * @param to: The address to mint the token to.
     * @return: A boolean indicating if the mint was successful.
     */
    function safeMint(address to) external returns (bool){
        if (to == address(0)) {
            revert UnitiProgram__ZeroAddress();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        emit UnitiProgram__Minted(to, tokenId);
        _setTokenURI(tokenId, s_uri);

        return true;
    }

    /**
     * @dev: This function is to set the new token uri.
     * @param _uri: The new token uri.
     */
    function setURI(string memory _uri) external {
        s_uri = _uri;
        emit UnitiProgram__TokenURIUpdated(_uri);
    }

    ////////////////////
    // External and View Functions //
    ////////////////////

    /**
     * @dev: This function returns the Program Creator address.
     * @return: The Program Creator address.
     */
    function getProgramCreator() external view returns (address) {
        return s_programCreator;
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
