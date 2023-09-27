// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {DataTypes} from "./DataTypes.sol"

contract Job {

    mapping(uint256 => DataTypes.JobInfo) public jobs;
    uint256 public jobCount;

    // Mapping to track used job IDs
    mapping(uint256 => bool) private usedJobIds;

    event JobPosted(address indexed client, uint256 indexed jobId, uint256 bounty);
    event JobHired(address indexed client, address indexed recruiter, address indexed developer, uint256 bounty);

    constructor() {
        // Initialize the contract
    }

    function postJob(uint256 _jobId, uint256 _bounty, uint256 _budget) public {
        require(_jobId > 0, "Job ID must be greater than 0");
        require(!usedJobIds[_jobId], "Job ID already in use");
        require(_bounty > 0, "Bounty must be greater than 0");

        jobs[_jobId] = JobInfo({
            jobId: _jobId,
            client: msg.sender,
            bounty: _bounty,
            isOpen: true,
            hiredDeveloper: address(0),
            budget: _budget
        });

        usedJobIds[_jobId] = true; // Mark job ID as used
        jobCount++;

        emit JobPosted(msg.sender, _jobId, _bounty);
    }

    // Additional functions to hire developers, close jobs, etc.

    // ...
}
