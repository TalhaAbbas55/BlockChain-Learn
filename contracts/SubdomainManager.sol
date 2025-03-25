// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubdomainManager {
    mapping(string => address) public subdomainOwner;
    uint256 public constant PRICE = 0.01 ether;

    event SubdomainPurchased(string subdomain, address indexed buyer);

    // Function to purchase/transfer a subdomain
    function buySubdomain(string memory subdomain) external payable {
        require(msg.value == PRICE, "Incorrect payment");
        require(subdomainOwner[subdomain] == address(0), "Subdomain already taken");

        subdomainOwner[subdomain] = msg.sender;
        emit SubdomainPurchased(subdomain, msg.sender);
    }

    // Check if a subdomain is available
    function isAvailable(string memory subdomain) external view returns (bool) {
        return subdomainOwner[subdomain] == address(0);
    }
}
