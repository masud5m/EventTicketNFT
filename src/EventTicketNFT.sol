// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventTicketNFT is ERC721, Ownable {

    uint256 public ticketPrice;
    uint256 public maxSupply;
    uint256 public totalMinted;

    IERC20 public paymentToken;

    mapping(address => uint256) public walletMints;

    uint256 public constant MAX_PER_WALLET = 2;

    constructor(
        uint256 _ticketPrice,
        uint256 _maxSupply,
        address _paymentToken
    )
        ERC721("EventTicket", "ETK")
        Ownable(msg.sender)
    {
        ticketPrice = _ticketPrice;
        maxSupply = _maxSupply;
        paymentToken = IERC20(_paymentToken);
    }

    function mintWithETH() external payable {

        require(msg.value >= ticketPrice, "Not enough ETH");

        require(totalMinted < maxSupply, "Sold out");

        require(
            walletMints[msg.sender] < MAX_PER_WALLET,
            "Wallet limit reached"
        );

        totalMinted++;

        walletMints[msg.sender]++;

        _safeMint(msg.sender, totalMinted);
    }

    function mintWithToken() external {

        require(totalMinted < maxSupply, "Sold out");

        require(
            walletMints[msg.sender] < MAX_PER_WALLET,
            "Wallet limit reached"
        );

        paymentToken.transferFrom(
            msg.sender,
            address(this),
            ticketPrice
        );

        totalMinted++;

        walletMints[msg.sender]++;

        _safeMint(msg.sender, totalMinted);
    }

    function withdrawETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
