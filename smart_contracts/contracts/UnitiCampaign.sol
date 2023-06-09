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

import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/**
 * @title: UnitiCampaign
 * @author: Megabyte
 * This contract is the basic implementation of the ERC1155 token contract for Uniti Campaigns with the function to set the URI.
 * @dev: ERC1155 token contract for Uniti Campaigns
 */

contract UnitiCampaign is ERC1155 {
    ////////////////////
    // Errors //
    ////////////////////
    error UnitiCampaign__ZeroAddress();
    error UnitiCampaign__ZeroAmount();
    error UnitiCampaign__InvalidTokenId();
    error UnitiCampaign__TokenIdsLengthAndAmountsLengthShouldBeSame();

    ////////////////////
    // State Variables //
    ////////////////////
    address private programAddress;

    ////////////////////
    // Events //
    ////////////////////
    event UnitiCampaign__SingleMinted(address indexed _to, uint256 indexed _tokenId);
    event UnitiCampaign__TokenURIUpdated(
        string indexed _tokenURI
    );
    event UnitiCampaign__BatchMinted(address indexed _to, uint256[] indexed _tokenIds, uint256[] indexed _amounts);

    ////////////////////
    // Functions //
    ////////////////////
    constructor(
        string memory _tokenURI,
        address _programAddress
    ) ERC1155(_tokenURI) {
        if (_programAddress == address(0)) revert UnitiCampaign__ZeroAddress();
        programAddress = _programAddress;
    }

    ////////////////////
    // External Functions //
    ////////////////////

    /**
     * @dev: Sets the URI for the token contract
     * @param newuri: the new URI to set
     */
    function setURI(string memory newuri) external {
        _setURI(newuri);
        emit UnitiCampaign__TokenURIUpdated(newuri);
    }

    /**
     * @dev: Mints a new token
     * @param account: the address to mint the token to
     * @param data: any data to pass to the token
     */
    function mint(
        address account,
        bytes memory data
    ) external {
        if (account == address(0)) revert UnitiCampaign__ZeroAddress();
        _mint(account, 1, 1, data);
        emit UnitiCampaign__SingleMinted(account, id);
    }

    /**
     * @dev: Mints a batch of new tokens
     * @param to: the address to mint the tokens to
     * @param ids: the ids of the tokens to mint
     * @param amounts: the amounts of tokens to mint
     * @param data: any data to pass to the tokens
     * @notice: the length of the ids and amounts arrays must be the same
     */
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external {
        if (to == address(0)) revert UnitiCampaign__ZeroAddress();
        if(ids.length != amounts.length) revert UnitiCampaign__TokenIdsLengthAndAmountsLengthShouldBeSame();
        _mintBatch(to, ids, amounts, data);
        emit UnitiCampaign__BatchMinted(to, ids, amounts);
    }

    ////////////////////
    // External and View Functions //
    ////////////////////
    function getProgramAddresss() external view returns (address) {
        return programAddress;
    }
}
