//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

// #     # ####### #       #######  #####  #     # #       #######
// ##   ## #     # #       #       #     # #     # #       #
// # # # # #     # #       #       #       #     # #       #
// #  #  # #     # #       #####   #       #     # #       #####
// #     # #     # #       #       #       #     # #       #
// #     # #     # #       #       #     # #     # #       #
// #     # ####### ####### #######  #####   #####  ####### #######

import "solmate/tokens/ERC721.sol";
import "./interfaces/IMolecule.sol";

contract Molecule is ERC721, IMolecule {
    address[] public minters;

    mapping(address => bool) brightlistedAddresses;

    address public owner;

    uint256 public counter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    constructor() public ERC721("Molecule", "MLCL") {}

    function tokenURI(
        uint256 id
    ) public view virtual override returns (string memory) {}

    /**
     * @notice Add to brightlist
     */
    function addToBrightlist(address _addressToBrightlist) external onlyOwner {
        brightlistedAddresses[_addressToBrightlist] = true;
    }

    /**
     * @notice Remove from brightlist
     */
    function revokeFromBrightlist(address _addressToRevoke) external onlyOwner {
        brightlistedAddresses[_addressToRevoke] = false;
    }

    function mintToken(string tokenUri) external payable override {
        require(brightlistedAddresses[msg.sender]);

        _mint(msg.sender, tokenUri);
        _setTokenURI(counter, tokenURI);

        counter += 1;
        brightlistedAddresses[msg.sender] = false;

        return counter;
    }
}
