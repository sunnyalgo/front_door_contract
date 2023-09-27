// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./User.sol"; // Import the User contract
import "./Job.sol"

contract Client is User {
    DataTypes.JobInfo[] my_job;
    constructor() {
        // Additional constructor logic for clients if needed
    }

    function getMyJobs() public view returns (DataTypes.JobInfo[] memory) {
        return my_job;
    }

    function updateJobStatus(uint256 _jobId, bool _isOpen) public {
        require(users[msg.sender].userType == 0, "Only clients can update job status");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");
        
        jobs[_jobId].isOpen = _isOpen;
    }

    function withdrawFunds(uint256 _jobId) public {
        require(users[msg.sender].userType == 0, "Only clients can withdraw funds");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");
        require(!jobs[_jobId].isOpen, "Cannot withdraw funds from an open job");
        
        // Implement the fund withdrawal logic here, which may involve transferring funds to the client's wallet.
    }

    function getJobDetails(uint256 _jobId) public view returns (address client, uint256 bounty, bool isOpen) {
        require(users[msg.sender].userType == 0, "Only clients can view job details");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");
        
        return (jobs[_jobId].client, jobs[_jobId].bounty, jobs[_jobId].isOpen);
    }

    // Function to update the bounty of a job
    function update_bounty(uint256 _jobId, uint256 _newBounty) public {
        require(users[msg.sender].userType == 0, "Only clients can update bounties");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");

        jobs[_jobId].bounty = _newBounty;
    }


    // Function to hire a candidate for a job
    function hire_candidate(uint256 _jobId, address _candidate) public {
        require(users[msg.sender].userType == 0, "Only clients can hire candidates");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");
        require(jobs[_jobId].isOpen, "Job is not open");
        
        // Implement the hiring logic here, which may involve transferring funds and updating job status.
    }


    // Function to post a new job
    function job_post(uint256 _jobId, uint256 _bounty) public {
        require(users[msg.sender].userType == 0, "Only clients can post jobs");
        require(!usedJobIds[_jobId], "Job ID already in use");
        require(_bounty > 0, "Bounty must be greater than 0");

        jobs[_jobId] = JobInfo({
            jobId: _jobId,
            client: msg.sender,
            bounty: _bounty,
            isOpen: true,
            hiredDeveloper: address(0),
            postingTime: block.timestamp
        });

        usedJobIds[_jobId] = true; // Mark job ID as used
        jobCount++;
    }


    // Function to remove a posted job
    function job_remove(uint256 _jobId) public {
        require(users[msg.sender].userType == 0, "Only clients can remove jobs");
        require(jobs[_jobId].client == msg.sender, "You do not own this job");

        // Release the used job ID
        usedJobIds[_jobId] = false;

        delete jobs[_jobId];
        jobCount--;
    }

    // Add more functions or logic specific to clients as needed
}
