// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "smart_contracts/node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract UnitiCampaign is ERC1155 {
    address private programAddress;

    constructor(
        string memory _tokenURI,
        address _programAddress
    ) ERC1155(_tokenURI) {
        programAddress = _programAddress;
    }

    function setURI(string memory newuri) external {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external {
        _mintBatch(to, ids, amounts, data);
    }

    function getProgramAddresss() external view returns (address) {
        return programAddress;
    }
}
