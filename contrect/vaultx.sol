// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VeriTrust
 * @dev A simple decentralized trust verification system using blockchain.
 * Users can register, verify others, and view trust scores on-chain.
 */
contract VeriTrust {
    struct User {
        string name;
        uint256 trustScore;
        bool registered;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed user, string name);
    event TrustUpdated(address indexed user, uint256 newScore);
    event VerificationGiven(address indexed verifier, address indexed target, uint256 increase);

    modifier onlyRegistered() {
        require(users[msg.sender].registered, "You must be registered first");
        _;
    }

    /// @notice Register a new user on the blockchain.
    function registerUser(string memory _name) external {
        require(!users[msg.sender].registered, "Already registered");
        users[msg.sender] = User(_name, 50, true); // default trust score 50
        emit UserRegistered(msg.sender, _name);
    }

    /// @notice Increase trust score of another user.
    function verifyUser(address _user, uint256 _increase) external onlyRegistered {
        require(users[_user].registered, "Target not registered");
        require(_increase > 0 && _increase <= 10, "Increase must be between 1 and 10");
        users[_user].trustScore += _increase;
        emit VerificationGiven(msg.sender, _user, _increase);
    }

    /// @notice Retrieve the trust score of a user.
    function getTrustScore(address _user) external view returns (uint256) {
        require(users[_user].registered, "User not registered");
        return users[_user].trustScore;
    }
}
