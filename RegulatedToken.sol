// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/access/Ownable.sol";

// Interface to connect with IdentityRegistry
interface IIdentityRegistry {
    function isVerified(address user) external view returns (bool);
}

contract RegulatedToken is ERC20, Ownable {
    IIdentityRegistry public identityRegistry;

    // Constructor: pass IdentityRegistry contract address
    constructor(address _identityRegistry)
        ERC20("RegulatedToken", "RGT")
        Ownable(msg.sender) // ✅ set deployer as owner
    {
        identityRegistry = IIdentityRegistry(_identityRegistry);
        _mint(msg.sender, 1_000_000 * 10 ** decimals()); // initial supply to deployer
    }

    // Override ERC20 transfer checks with KYC rules
    function _update(address from, address to, uint256 amount) internal override {
        if (from != address(0)) {
            require(identityRegistry.isVerified(from), "Sender not verified");
        }
        if (to != address(0)) {
            require(identityRegistry.isVerified(to), "Receiver not verified");
        }
        super._update(from, to, amount);
    }
}
