// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FitnessGoalTracker {
    // Struct to represent a fitness goal
    struct FitnessGoal {
        address participant;
        string goalDescription;
        uint256 targetValue;
        uint256 currentProgress;
        uint256 tokenReward;
        bool isCompleted;
    }

    // Array to store all fitness goals
    FitnessGoal[] public fitnessGoals;

    // Mapping to track tokens earned by participants
    mapping(address => uint256) public tokenBalances;

    // Event to log when a new fitness goal is created
    event GoalCreated(
        uint256 indexed goalId, 
        address indexed participant, 
        string goalDescription, 
        uint256 targetValue
    );

    // Event to log when progress is updated
    event GoalProgressUpdated(
        uint256 indexed goalId, 
        uint256 newProgress, 
        bool isCompleted
    );

    // Function to create a new fitness goal
    function createFitnessGoal(
        string memory _goalDescription, 
        uint256 _targetValue, 
        uint256 _tokenReward
    ) public returns (uint256) {
        // Validate input parameters
        require(bytes(_goalDescription).length > 0, "Goal description cannot be empty");
        require(_targetValue > 0, "Target value must be greater than zero");
        require(_tokenReward > 0, "Token reward must be greater than zero");

        // Create new fitness goal
        FitnessGoal memory newGoal = FitnessGoal({
            participant: msg.sender,
            goalDescription: _goalDescription,
            targetValue: _targetValue,
            currentProgress: 0,
            tokenReward: _tokenReward,
            isCompleted: false
        });

        // Add goal to the array and get its ID
        uint256 goalId = fitnessGoals.length;
        fitnessGoals.push(newGoal);

        // Emit event for goal creation
        emit GoalCreated(goalId, msg.sender, _goalDescription, _targetValue);

        return goalId;
    }

    // Function to update goal progress
    function updateGoalProgress(uint256 _goalId, uint256 _progressValue) public {
        // Validate goal exists and is not completed
        require(_goalId < fitnessGoals.length, "Invalid goal ID");
        require(!fitnessGoals[_goalId].isCompleted, "Goal is already completed");
        require(msg.sender == fitnessGoals[_goalId].participant, "Only goal participant can update progress");

        // Update goal progress
        fitnessGoals[_goalId].currentProgress += _progressValue;

        // Check if goal is completed
        bool goalCompleted = fitnessGoals[_goalId].currentProgress >= fitnessGoals[_goalId].targetValue;
        
        if (goalCompleted) {
            // Mark goal as completed
            fitnessGoals[_goalId].isCompleted = true;
            // Award tokens to the participant
            tokenBalances[msg.sender] += fitnessGoals[_goalId].tokenReward;
        }

        // Emit event for progress update
        emit GoalProgressUpdated(_goalId, fitnessGoals[_goalId].currentProgress, goalCompleted);
    }
}