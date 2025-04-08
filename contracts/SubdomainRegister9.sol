// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


interface INameWrapper {
    function setSubnodeRecord(
        bytes32 parentNode,
        string calldata label,
        address owner,
        address resolver,
        uint64 ttl,
        uint32 fuses,
        uint64 expiry
    ) external;
    
    function isApprovedForAll(address account, address operator) external view returns (bool);
    function ownerOf(bytes32 node) external view returns (address);

    
}

contract SubdomainRegister9 is Ownable, ReentrancyGuard {
    INameWrapper public immutable nameWrapper;
    address public immutable resolver;
    bytes32 public immutable parentNode;
    
    uint256 public registrationFee;
    address public feeRecipient;
    
    event SubdomainRegistered(bytes32 indexed parentNode, string label, address indexed owner);
    event FeeUpdated(uint256 newFee);
    event FeeRecipientUpdated(address newRecipient);

    constructor(
        address _nameWrapper,
        address _resolver,
        bytes32 _parentNode,
        uint256 _registrationFee,
        address _feeRecipient
    ) {
        require(_nameWrapper != address(0), "Invalid NameWrapper");
        require(_resolver != address(0), "Invalid resolver");
        require(_feeRecipient != address(0), "Invalid fee recipient");

        nameWrapper = INameWrapper(_nameWrapper);
        resolver = _resolver;
        parentNode = _parentNode;
        registrationFee = _registrationFee;
        feeRecipient = _feeRecipient;
    }

    function register(string calldata label) external payable nonReentrant {
        require(bytes(label).length > 0, "Empty label");
        require(msg.value >= registrationFee, "Insufficient fee");

        // Process fee payment
        (bool feeSuccess, ) = feeRecipient.call{value: registrationFee}("");
        require(feeSuccess, "Fee transfer failed");

        // Refund excess
        uint256 refund = msg.value - registrationFee;
        if (refund > 0) {
            (bool refundSuccess, ) = payable(msg.sender).call{value: refund}("");
            require(refundSuccess, "Refund failed");
        }

        // Try to register the subdomain and capture any revert reason
        try nameWrapper.setSubnodeRecord(
            parentNode,
            label,
            msg.sender,
            resolver,
            0,         // TTL
            0,         // Fuses
            uint64(block.timestamp + 365 days)
        ) {
            emit SubdomainRegistered(parentNode, label, msg.sender);
        } catch (bytes memory reason) {
            revert(string(reason));
        }
    }

    // ADMIN FUNCTIONS
    function setRegistrationFee(uint256 _fee) external onlyOwner {
        registrationFee = _fee;
        emit FeeUpdated(_fee);
    }

    function setFeeRecipient(address _recipient) external onlyOwner {
        require(_recipient != address(0), "Invalid address");
        feeRecipient = _recipient;
        emit FeeRecipientUpdated(_recipient);
    }

    function withdraw() external onlyOwner {
        (bool success, ) = owner().call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    // VIEW FUNCTIONS
    function getParentOwner() external view returns (address) {
        return nameWrapper.ownerOf(parentNode);
    }
    
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function checkApproval() external view returns (bool) {
        return nameWrapper.isApprovedForAll(owner(), address(this));
    }
}
