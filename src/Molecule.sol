//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "solmate/tokens/ERC721.sol";
import "./interfaces/IMolecule.sol";

contract Molecule is ERC721, IMolecule {
    mapping(address => bool) brightlistedAddresses;
    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    address public owner;

    uint256 public counter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
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
        brightlistedAddresses[_addressToBrightlist] = true;
    }

    /**
     * @notice Remove from brightlist
     */
    function revokeFromBrightlist(address _addressToRevoke) external onlyOwner {
        brightlistedAddresses[_addressToRevoke] = false;
    }

    function mintToken(string calldata _tokenURI) external {
        require(brightlistedAddresses[msg.sender]);

        _mint(msg.sender, counter);
        _setTokenURI(counter, _tokenURI);

        counter += 1;
        brightlistedAddresses[msg.sender] = false;
    }
}
