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

import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {IERC6551Registry} from "./interfaces/IERC6551Registry.sol";

/**
 * @title UnitiProgram
 * @author Megabyte
 * This contract is the basic implementation of the ERC721 token contract with the set TokenURI function and auto-incrementing tokenIds.
 */

contract UnitiProgram is ERC721, ERC721Enumerable, ERC721URIStorage {
    ////////////////////
    // Error Messages //
    ////////////////////
    error UnitiProgram__ZeroAddress();
    error UnitiProgram__NotDeployer();

    ////////////////////
    // Libraries //
    ////////////////////
    using Counters for Counters.Counter;

    ////////////////////
    // State Variables //
    ////////////////////
    Counters.Counter private _tokenIdCounter;

    string private s_uri;

    address private immutable s_deployer;
    address private s_programCreator;
    address private s_erc6551Registry;
    address private s_erc6551Account;

    mapping(uint256 tokenId => address tkaAddress) tkbAddresses;

    ////////////////////
    // Events //
    ////////////////////
    event UnitiProgram__Minted(address indexed _to, uint256 indexed _tokenId);
    event UnitiProgram__TokenURIUpdated(string indexed _tokenURI);
    event UnitiProgram__TKACreated(address indexed _to, uint256 indexed _tokenId, address indexed _tkaAddress);

    ////////////////////
    // Functions //
    ////////////////////
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        address _programCreator,
        address _erc6551Registry,
        address _erc6551Account
    ) ERC721(_name, _symbol) {
        if (_programCreator == address(0) || _erc6551Account == address(0) || _erc6551Registry == address(0)) {
            revert UnitiProgram__ZeroAddress();
        }

        s_deployer = msg.sender;
        s_programCreator = _programCreator;
        s_uri = _tokenURI;
    }

    ////////////////////
    // External Functions //
    ////////////////////

    /**
     * @dev This function mints a single token to the address specified.
     * @param to: The address to mint the token to.
     * @return A boolean indicating if the mint was successful.
     */
    function safeMint(address to) external returns (bool) {
        if (to == address(0)) {
            revert UnitiProgram__ZeroAddress();
        }
        if (msg.sender != s_deployer) revert UnitiProgram__NotDeployer();

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        _safeMint(to, tokenId);

        _setTokenURI(tokenId, s_uri);

        address tkaAddress = _createTKA(tokenId);
        tkbAddresses[tokenId] = tkaAddress;
        emit UnitiProgram__TKACreated(to, tokenId, tkaAddress);

        return true;
    }

    /**
     * @dev This function is to set the new token uri.
     * @param _uri: The new token uri.
     */
    function setURI(string memory _uri) external {
        s_uri = _uri;
        emit UnitiProgram__TokenURIUpdated(_uri);
    }

    function getTKBAddress(uint256 tokenId) external view returns (address) {
        return tkbAddresses[tokenId];
    }

    ////////////////////
    // Internal Functions //
    ////////////////////
    function _createTKA(uint256 _tokenId) internal returns (address tkaAddress) {
        tkaAddress = IERC6551Registry(s_erc6551Registry).createAccount(
            s_erc6551Account, block.chainid, address(this), _tokenId, 0, bytes("0x8129fc1c")
        );
    }

    ////////////////////
    // External and View Functions //
    ////////////////////

    /**
     * @dev This function returns the Program Creator address.
     * @return The Program Creator address.
     */
    function getProgramCreator() external view returns (address) {
        return s_programCreator;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return s_uri;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
