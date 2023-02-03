// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {console2} from "forge-std/console2.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Molecule} from "../src/Molecule.sol";

contract MoleculeTest is PRBTest, StdCheats {
    Molecule public molecule;
    address public owner;

    function setUp() public {
        owner = makeAddr("owner");

        molecule = new Molecule(owner);
    }

    function testAddBrightlistedAddressShouldBeSuccessful() public {
        address user = makeAddr("user");

        assertEq(molecule.brightlistedAddresses(user), false);

        vm.prank(owner);
        molecule.addToBrightlist(user);

        assertEq(molecule.brightlistedAddresses(user), true);
    }

    function testRemoveBrightlistedAddressShouldBeSuccessful() public {
        address user = makeAddr("user");
        assertEq(molecule.brightlistedAddresses(user), false);

        vm.startPrank(owner);
        molecule.addToBrightlist(user);
        assertEq(molecule.brightlistedAddresses(user), true);

        molecule.revokeFromBrightlist(user);
        assertEq(molecule.brightlistedAddresses(user), false);
        vm.stopPrank();
    }

    function testMintingShouldBeSuccessful() public {
        address user = makeAddr("user");

        vm.prank(owner);
        molecule.addToBrightlist(user);
        assertEq(molecule.brightlistedAddresses(user), true);

        vm.prank(user);
        molecule.mintToken("https://test.url");

        assertEq(molecule.counter(), 1);
        assertEq(molecule.balanceOf(user), 1);
        assertEq(molecule.brightlistedAddresses(user), false);
    }

    function testChangeOwnerShouldBeSuccessful() public {
        address newOwner = makeAddr("newOwner");

        vm.prank(owner);
        molecule.changeOwner(newOwner);

        assertEq(molecule.owner(), newOwner);
    }
}
