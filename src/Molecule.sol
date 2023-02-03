//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "solmate/tokens/ERC721.sol";
import "./interfaces/IMolecule.sol";

contract Molecule is ERC721, IMolecule {
    error NotOwner();
    error MinterNotBrightlisted();
    error InvalidOwnerAddress();
    error InvalidBrightlistAddress();

    address public owner;
    uint256 public counter;
    mapping(address => bool) brightlistedAddresses;
    mapping(uint256 => string) public _tokenURIs;

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address _owner) ERC721("Molecule", "MLCL") {
        owner = _owner;
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return _tokenURIs[id];
    }

    /**
     * @notice Add to brightlist
     */
    function addToBrightlist(address _addressToBrightlist) external onlyOwner {
        if (_addressToBrightlist == address(0))
            revert InvalidBrightlistAddress();

        brightlistedAddresses[_addressToBrightlist] = true;
    }

    /**
     * @notice Remove from brightlist
     */
    function revokeFromBrightlist(address _addressToRevoke) external onlyOwner {
        if (_addressToRevoke == address(0)) revert InvalidBrightlistAddress();

        brightlistedAddresses[_addressToRevoke] = false;
    }

    /**
     * @notice Change contract owner
     */
    function changeOwner(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert InvalidOwnerAddress();
        owner = newOwner;
    }

    function mintToken(string calldata _tokenURI) external {
        if (!brightlistedAddresses[msg.sender]) revert MinterNotBrightlisted();

        _mint(msg.sender, counter);
        _setTokenURI(counter, _tokenURI);

        counter += 1;
        brightlistedAddresses[msg.sender] = false;
    }
}
