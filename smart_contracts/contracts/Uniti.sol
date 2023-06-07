// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "smart_contracts/node_modules/@opengsn/contracts/src/ERC2771Recipient.sol";

import "./UnitiCampaign.sol";
import "./UnitiProgram.sol";

contract Uniti is ERC2771Recipient {
    // array of all the programs
    address[] public programs;

    // programCreator Address => Program Contract Address
    mapping(address => address) programCreator;

    // program contract address => campaign contract address
    mapping(address => address) campaignProgramCreator;

    constructor(address _trustedForwarder) {
        _setTrustedForwarder(trustedForwarder);
    }

    function setTrustedForwarder(address _trustedForwarder) {
        _setTrustedForwarder(_trustedForwarder);
    }

    function createProgram(
        string memory _name,
        string _symbol,
        string _tokenURI
    ) external returns (address) {
        UnitiProgram program = new UnitiProgram(
            _name,
            _symbol,
            tokenURI,
            _msgSender()
        );
        programCreator[_msgSender()] = address(program);
    }

    function createCampaign(
        string memory _tokenURI,
        address _programAddress
    ) external returns (address) {
        require(
            programCreator[_msgSender()] == _programAddress,
            "ERR:Not program creator"
        );
        UnitiCampaign campaign = new UnitiCampaign(_tokenURI, _programAddress);

        campaignProgramCreator[_programAddress] = address(campaign);
    }

    function versionRecipient() external view override returns (string memory) {
        return "1";
    }
}
