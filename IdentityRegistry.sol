
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityRegistry {
    mapping(address => bool) public isVerified;
    mapping(address => string) public country;
    address public admin;

    event InvestorVerified(address indexed user, string country);
    event VerificationRevoked(address indexed user);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function verifyInvestor(address user, string calldata userCountry) external onlyAdmin {
        require(user != address(0), "Invalid user address");
        require(bytes(userCountry).length > 0, "Country cannot be empty");
        isVerified[user] = true;
        country[user] = userCountry;
        emit InvestorVerified(user, userCountry);
    }

    function revokeVerification(address user) external onlyAdmin {
        require(user != address(0), "Invalid user address");
        isVerified[user] = false;
        delete country[user];
        emit VerificationRevoked(user);
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Invalid admin address");
        require(newAdmin != admin, "Same admin address");
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminTransferred(oldAdmin, newAdmin);
    }

    function batchVerifyInvestors(address[] calldata users, string[] calldata countries) external onlyAdmin {
        require(users.length == countries.length, "Arrays length mismatch");
        require(users.length > 0, "Empty arrays");
        for (uint256 i = 0; i < users.length; i++) {
            require(users[i] != address(0), "Invalid user address");
            require(bytes(countries[i]).length > 0, "Country cannot be empty");
            isVerified[users[i]] = true;
            country[users[i]] = countries[i];
            emit InvestorVerified(users[i], countries[i]);
        }
    }
}
