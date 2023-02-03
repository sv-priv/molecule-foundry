pragma solidity 0.8.15;

import {ERC721} from "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC721.sol";

interface IMolecule {
    // Brightlisting functions
    // only owner
    function addToBrightlist(address minter) external;

    //only owner
    // revoking brightlist
    function revokeFromBrightlist(address minter) external;

    //minting

    function mintToken(string calldata tokenUri) external;
}
