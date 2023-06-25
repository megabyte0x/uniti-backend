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
    error Uniti__NoParticipationInCampaign(address _programAddress);

    ////////////////////
    // Struct //
    ////////////////////
    struct UserParticipation {
        address[] programsIncludedIn;
        mapping(address programAddress => uint256[] ids) campaignIds;
    }

    struct ProgramDetails {
        bytes32 merkleRoot;
        bytes32 blackListedMerkleRoot;
        uint256 latestCampaignsId;
        uint256 programJoinFee;
        address programCreator;
        address[] campaigns;
    }

    struct CampaignDetails {
        uint256 campaignId;
        uint256 joinFee;
        address programAddress;
        address campaignAddress;
    }

    ////////////////////
    // State Variables //
    ////////////////////

    address private s_erc6551Registry;
    address private s_erc6551Account;
    address[] private s_programs;

    mapping(address userAdddress => UserParticipation) userParticipation;
    mapping(address programAddress => ProgramDetails) programDetails;
    mapping(address campaignAddress => CampaignDetails) campaignDetails;

    ////////////////////
    // Events //
    ////////////////////
    event Uniti__ProgramCreated(address indexed _programCreator, address indexed _programContractAddress);
    event Uniti__CampaginCreated(address indexed _programAddress, address indexed _campaignContractAddress);
    event Uniti__MerkleRootUpdated(address indexed _programAddress, bytes32 indexed _merkleRoot);
    event Uniti__RegistryContractAddressUpdated(address indexed _registryContractAddress);
    event Uniti__RegistryAccountAddressUpdated(address indexed _registryAccountAddress);

    ////////////////////
    // Modifiers //
    ////////////////////

    modifier isZeroAddress(address _address) {
        if (_address == address(0)) revert Uniti__ZeroAddress();
        _;
    }

    modifier isProgramCreator(address _programAddress) {
        if (programDetails[_programAddress].programCreator != msg.sender) revert Uniti__NotProgramCreator();
        _;
    }

    ////////////////////
    // Functions //
    ////////////////////
    constructor() {}

    ////////////////////
    // External Functions //
    ////////////////////

    /**
     * The function is to create a programv (Polygon Advocate) and store it in the mapping.
     * @param _name Name of the Program NFT
     * @param _symbol Symbol of the Program NFT
     * @param _tokenURI TokenURI of the Program NFT
     */
    function createProgram(
        string memory _name,
        string memory _symbol,
        string memory _tokenURI,
        bytes32 _merkleRoot,
        uint256 _joinFee
    ) external returns (address programContractAddress) {
        UnitiProgram program = new UnitiProgram(
            _name,
            _symbol,
            _tokenURI,
            msg.sender,
            s_erc6551Registry,
            s_erc6551Account
        );

        programDetails[address(program)] = ProgramDetails({
            merkleRoot: _merkleRoot,
            blackListedMerkleRoot: bytes32(0x0),
            latestCampaignsId: 0,
            programJoinFee: _joinFee,
            programCreator: msg.sender,
            campaigns: new address[](0)
        });

        emit Uniti__ProgramCreated(msg.sender, address(program));

        return address(program);
    }

    /**
     * This function is to create the campaign (THE QUEST) contract and store it in the mapping.
     * @notice The program creator is the only one who can create the campaign.
     * @param _tokenURI TokenURI of the Campaign NFT
     * @param _programAddress Address of the Program NFT Contract
     */
    function createCampaign(string memory _tokenURI, address _programAddress, uint256 _joinFee)
        external
        isZeroAddress(_programAddress)
        isProgramCreator(_programAddress)
        returns (address campaignContractAddress)
    {
        ProgramDetails storage programDetail = programDetails[_programAddress];
        uint256 latestCampaignId = programDetail.latestCampaignsId + 1;

        UnitiCampaign campaign = new UnitiCampaign(_tokenURI, _programAddress);

        programDetail.campaigns.push(address(campaign));
        programDetail.latestCampaignsId = latestCampaignId;

        campaignDetails[address(campaign)] = CampaignDetails({
            campaignId: latestCampaignId,
            joinFee: _joinFee,
            programAddress: _programAddress,
            campaignAddress: address(campaign)
        });

        emit Uniti__CampaginCreated(_programAddress, address(campaign));

        return address(campaign);
    }

    function updateMerkleRoot(address _programAddress, bytes32 _merkleRoot)
        external
        isZeroAddress(_programAddress)
        isProgramCreator(_programAddress)
    {
        programDetails[_programAddress].merkleRoot = _merkleRoot;

        emit Uniti__MerkleRootUpdated(_programAddress, _merkleRoot);
    }

    function updateBlacklistedMerkleRoot(address _programAddress, bytes32 _blackListedMerkleRoot)
        external
        isZeroAddress(_programAddress)
        isProgramCreator(_programAddress)
    {
        programDetails[_programAddress].blackListedMerkleRoot = _blackListedMerkleRoot;

        emit Uniti__MerkleRootUpdated(_programAddress, _blackListedMerkleRoot);
    }

    ////////////////////
    // Private Functions //
    ////////////////////

    /**
     * The function is to set the registry contract address.
     * @param _registryContractAddress New registry contract address
     */
    function setRegistryContractAddress(address _registryContractAddress)
        private
        isZeroAddress(_registryContractAddress)
    {
        s_erc6551Registry = _registryContractAddress;

        emit Uniti__RegistryContractAddressUpdated(_registryContractAddress);
    }

    function setRegistryAccountAddress(address _registryAccountAddress)
        private
        isZeroAddress(_registryAccountAddress)
    {
        s_erc6551Account = _registryAccountAddress;

        emit Uniti__RegistryContractAddressUpdated(_registryAccountAddress);
    }

    ////////////////////
    // External and View Functions //
    ////////////////////

    /**
     * This functiuon returns the address of the program creator.
     * @param _programAddress Address of the Program NFT Contract
     */
    function getProgramCreator(address _programAddress)
        external
        view
        isZeroAddress(_programAddress)
        returns (address programCreatorAddress)
    {
        return programDetails[_programAddress].programCreator;
    }

    /**
     * This function is to get the address of the program contract through which the campaign was created.
     * @param _programAddress Address of the Campaign NFT Contract
     */
    function getCampaigns(address _programAddress)
        external
        view
        isZeroAddress(_programAddress)
        returns (address[] memory campaignContractAddress)
    {
        return programDetails[_programAddress].campaigns;
    }

    /**
     * This function returns the array of all the program contract addresses.
     */
    function getPrograms() external view returns (address[] memory) {
        return s_programs;
    }

    function getProgramForUser(address _userAddress)
        external
        view
        isZeroAddress(_userAddress)
        returns (address[] memory)
    {
        return userParticipation[_userAddress].programsIncludedIn;
    }

    function getCampaignsForUserInProgram(address _programAddress, address _userAddress)
        external
        view
        isZeroAddress(_programAddress)
        isZeroAddress(_userAddress)
        returns (uint256[] memory campaignIds)
    {
        if (userParticipation[_userAddress].campaignIds[_programAddress].length == 0) {
            revert Uniti__NoParticipationInCampaign(_programAddress);
        }
        return userParticipation[_userAddress].campaignIds[_programAddress];
    }

    /**
     * This functions returns the details of the program (name, tokenURI)
     * @param _programAddress Program address
     */
    function getProgramDetails(address _programAddress)
        external
        view
        isZeroAddress(_programAddress)
        returns (string memory name, string memory tokenURI)
    {
        UnitiProgram program = UnitiProgram(_programAddress);
        name = program.name();
        tokenURI = program.tokenURI(0);
    }
}
