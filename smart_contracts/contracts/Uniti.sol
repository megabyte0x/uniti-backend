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

import {UnitiCampaign} from "./UnitiCampaign.sol";
import {UnitiProgram} from "./UnitiProgram.sol";

/**
 * @title Uniti
 * @author Megabyte
 * This contract is the core of the Uniti Protocol. It is the main contract that creates the program and campaign contracts. It also stores the various mappings between the contracts.
 */
contract Uniti {
    ////////////////////
    // Error Messages //
    ////////////////////
    error Uniti__ZeroAddress();
    error Uniti__NotProgramCreator();

    ////////////////////
    // State Variables //
    ////////////////////

    address private s_erc6551Registry;
    address private s_erc6551Account;
    address[] private s_programs;

    mapping(address programContractAddress => address programCreatorAddress) programCreator;
    mapping(address campaignContractAddress => address programContractAddres) campaignCreator;

    ////////////////////
    // Events //
    ////////////////////
    event Uniti__ProgramCreated(address indexed _programCreator, address indexed _programContractAddress);
    event Uniti__CampaginCreated(address indexed _programAddress, address indexed _campaignContractAddress);

    ////////////////////
    // Functions //
    ////////////////////
    constructor() {}

    ////////////////////
    // External Functions //
    ////////////////////

    /**
     *
     */
    // function setTrustedForwarder(address _trustedForwarder) external {
    //     if (_trustedForwarder == address(0)) revert Uniti__ZeroAddress();
    //     _setTrustedForwarder(_trustedForwarder);
    // }

    /**
     * The function is to create a programv (Polygon Advocate) and store it in the mapping.
     * @param _name Name of the Program NFT
     * @param _symbol Symbol of the Program NFT
     * @param _tokenURI TokenURI of the Program NFT
     */
    function createProgram(string memory _name, string memory _symbol, string memory _tokenURI)
        external
        returns (address programContractAddress)
    {
        UnitiProgram program = new UnitiProgram(
            _name,
            _symbol,
            _tokenURI,
            msg.sender,
            s_erc6551Registry,
            s_erc6551Account
        );
        programCreator[address(program)] = msg.sender;
        emit Uniti__ProgramCreated(msg.sender, address(program));

        return address(program);
    }

    /**
     * This function is to create the campaign (THE QUEST) contract and store it in the mapping.
     * @notice The program creator is the only one who can create the campaign.
     * @param _tokenURI TokenURI of the Campaign NFT
     * @param _programAddress Address of the Program NFT Contract
     */
    function createCampaign(string memory _tokenURI, address _programAddress)
        external
        returns (address campaignContractAddress)
    {
        if (programCreator[_programAddress] != msg.sender) revert Uniti__NotProgramCreator();
        UnitiCampaign campaign = new UnitiCampaign(_tokenURI, _programAddress);

        campaignCreator[_programAddress] = address(campaign);
        emit Uniti__CampaginCreated(_programAddress, address(campaign));

        return address(campaign);
    }

    ////////////////////
    // Private Functions //
    ////////////////////

    /**
     * The function is to set the registry contract address.
     * @param _registryContractAddress New registry contract address
     */
    function setRegistryContractAddress(address _registryContractAddress) private {
        s_erc6551Registry = _registryContractAddress;
    }

    function setRegistryAccountAddress(address _registryAccountAddress) private {
        s_erc6551Account = _registryAccountAddress;
    }

    ////////////////////
    // External and View Functions //
    ////////////////////

    /**
     * This functiuon returns the address of the program creator.
     * @param _programAddress Address of the Program NFT Contract
     */
    function getProgramCreator(address _programAddress) external view returns (address programCreatorAddress) {
        return programCreator[_programAddress];
    }

    /**
     * This function is to get the address of the program contract through which the campaign was created.
     * @param _campaignAddress Address of the Campaign NFT Contract
     */
    function getCampaignCreator(address _campaignAddress) external view returns (address programContractAddress) {
        return campaignCreator[_campaignAddress];
    }

    /**
     * This function returns the array of all the program contract addresses.
     */
    function getPrograms() external view returns (address[] memory) {
        return s_programs;
    }


    /**
     * This functions returns the details of the program (name, tokenURI)
     * @param _programAddress Program address 
     */
    function getProgramDetails(address _programAddress) external view returns(string memory name, string memory tokenURI) {
        UnitiProgram program = UnitiProgram(_programAddress);
        name =  program.name();
        tokenURI = program.tokenURI(0);
    }

}
