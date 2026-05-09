// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../src/EventTicketNFT.sol";
import "../src/MockToken.sol";

contract EventTicketNFTTest is Test {

    EventTicketNFT nft;
    MockToken token;

    address user = address(1);

    function setUp() public {

        token = new MockToken();

        nft = new EventTicketNFT(
            1 ether,
            5,
            address(token)
        );

        vm.deal(user, 10 ether);

        token.transfer(user, 100 ether);
    }

    function testMintWithETH() public {

        vm.prank(user);

        nft.mintWithETH{value: 1 ether}();

        assertEq(nft.balanceOf(user), 1);
    }

    function testMintWithToken() public {

        vm.startPrank(user);

        token.approve(address(nft), 1 ether);

        nft.mintWithToken();

        vm.stopPrank();

        assertEq(nft.balanceOf(user), 1);
    }

    function testWalletLimit() public {

        vm.startPrank(user);

        nft.mintWithETH{value: 1 ether}();
        nft.mintWithETH{value: 1 ether}();

        vm.expectRevert(bytes("Wallet limit reached"));

        nft.mintWithETH{value: 1 ether}();

        vm.stopPrank();
    }
}
