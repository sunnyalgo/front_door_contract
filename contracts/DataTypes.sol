pragma solidity 0.8.18;

library DataTypes{
    
    struct JobInfo {
        uint256 jobId;
        address client;
        uint256 bounty;
        bool isOpen;
        address hiredDeveloper;
        uint256 budget;
    }

    struct UserInfo {
        address wallet;
        uint256 userId;
        uint256 score;
        uint256 userType; // 0: client, 1: recruiter, 2: candidate, 3:administator
        bool isBanned;
        uint256 registrationTime;
    }
}