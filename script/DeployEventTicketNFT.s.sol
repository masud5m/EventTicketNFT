// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/EventTicketNFT.sol";

contract DeployEventTicketNFT is Script {

    function run() external {

        vm.startBroadcast();

        new EventTicketNFT(
            0.01 ether,
            100,
            0x0000000000000000000000000000000000000000
        );

        vm.stopBroadcast();
    }
}
