// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DataTypes} from './DataTypes.sol';

contract User {

    mapping(address => DataTypes.UserInfo) public users;
    address[] public userAddresses;

    // Mapping to track used user IDs
    mapping(uint256 => bool) private usedUserIds;

    event UserRegistered(address indexed userAddress, uint256 userId, uint256 userType);
    event UserDeleted(address indexed userAddress);
    event UserBanned(address indexed userAddress);

    // Modifier to check if the user exists and is not banned
    modifier userExistsAndNotBanned(address userAddress) {
        require(users[userAddress].wallet != address(0), "User does not exist");
        require(!users[userAddress].isBanned, "User is banned");
        _;
    }

    constructor() {
        // Initialize the contract
    }

    function registerUser(uint256 _userId, uint256 _userType) public {
        require(_userId > 0, "User ID must be greater than 0");
        require(_userType >= 0 && _userType <= 2, "Invalid user type");
        require(!usedUserIds[_userId], "User ID already in use");

        require(users[msg.sender].wallet == address(0), "User already registered");

        UserInfo storage newUser = users[msg.sender];
        newUser.wallet = msg.sender;
        newUser.userId = _userId;
        newUser.userType = _userType;
        newUser.score = 0;
        newUser.isBanned = false;
        newUser.registrationTime = block.timestamp;

        usedUserIds[_userId] = true; // Mark user ID as used

        userAddresses.push(msg.sender);

        emit UserRegistered(msg.sender, _userId, _userType);
    }

    function deleteUser(address _userAddress) public userExistsAndNotBanned(_userAddress) {
        require(msg.sender == _userAddress || users[msg.sender].userType == 3, "You cannot delete this user");

        // Release the used user ID
        usedUserIds[users[_userAddress].userId] = false;

        delete users[_userAddress];
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (userAddresses[i] == _userAddress) {
                userAddresses[i] = userAddresses[userAddresses.length - 1];
                userAddresses.pop();
                break;
            }
        }

        emit UserDeleted(_userAddress);
    }

    function banUser(address _userAddress) public userExistsAndNotBanned(_userAddress) {
        require(users[msg.sender].userType == 3, "Only administrators can ban users");

        users[_userAddress].isBanned = true;

        emit UserBanned(_userAddress);
    }
    function get_score() public view(uint16 score) {
        return users[msg.sender].score;
    }
}
