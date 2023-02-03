// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Molecule} from "../src/Molecule.sol";

contract DeployMolecule is Script {
    Molecule internal molecule;

    function run() public {
        vm.startBroadcast();

        address owner = 0x559441FEf78b7E27b66db69C11e5B3827e1aea96;

        string memory name = "Molecule";
        string memory symbol = "MLCL";

        molecule = new Molecule(name, symbol, owner);
        vm.stopBroadcast();
    }
}
