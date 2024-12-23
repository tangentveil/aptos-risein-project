# Fitness Goal Tracker DApp

This decentralized application (DApp) allows users to create fitness goals, track their progress, and earn rewards in the form of tokens when they complete their goals. It leverages smart contracts deployed on an Ethereum-compatible blockchain (e.g., Ethereum, Rinkeby, Goerli) and is integrated with MetaMask for a smooth user experience.

## Features

- **Create a Fitness Goal**: Users can define a fitness goal with a description, target value (e.g., steps, calories), and a token reward for completion.
- **Track Progress**: Users can update their progress towards achieving a fitness goal. Progress is updated based on a numeric value.
- **Token Rewards**: Once a goal is completed, the user is rewarded with tokens, which are tracked in their account.
- **View Goals**: Users can see a list of all their goals, including their current progress and completion status.
- **View Token Balance**: Users can view their token balance, which is updated when they complete a goal.

## Smart Contract

The **FitnessGoalTracker** smart contract is deployed on an Ethereum-compatible blockchain and includes the following features:

- **Create Fitness Goals**: Allows users to create goals with descriptions, target values, and token rewards.
- **Update Goal Progress**: Users can update their progress on a goal, and once the goal is achieved, they are awarded tokens.
- **View Fitness Goals**: Users can query all the fitness goals created by them.
- **Token Rewards**: Tokens are awarded to users when they complete their goals.

### Smart Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FitnessGoalTracker {
    struct FitnessGoal {
        address participant;
        string goalDescription;
        uint256 targetValue;
        uint256 currentProgress;
        uint256 tokenReward;
        bool isCompleted;
    }

    FitnessGoal[] public fitnessGoals;
    mapping(address => uint256) public tokenBalances;

    event GoalCreated(uint256 indexed goalId, address indexed participant, string goalDescription, uint256 targetValue);
    event GoalProgressUpdated(uint256 indexed goalId, uint256 newProgress, bool isCompleted);

    function createFitnessGoal(string memory _goalDescription, uint256 _targetValue, uint256 _tokenReward) public returns (uint256) {
        require(bytes(_goalDescription).length > 0, "Goal description cannot be empty");
        require(_targetValue > 0, "Target value must be greater than zero");
        require(_tokenReward > 0, "Token reward must be greater than zero");

        FitnessGoal memory newGoal = FitnessGoal({
            participant: msg.sender,
            goalDescription: _goalDescription,
            targetValue: _targetValue,
            currentProgress: 0,
            tokenReward: _tokenReward,
            isCompleted: false
        });

        uint256 goalId = fitnessGoals.length;
        fitnessGoals.push(newGoal);

        emit GoalCreated(goalId, msg.sender, _goalDescription, _targetValue);
        return goalId;
    }

    function updateGoalProgress(uint256 _goalId, uint256 _progressValue) public {
        require(_goalId < fitnessGoals.length, "Invalid goal ID");
        require(!fitnessGoals[_goalId].isCompleted, "Goal is already completed");
        require(msg.sender == fitnessGoals[_goalId].participant, "Only goal participant can update progress");

        fitnessGoals[_goalId].currentProgress += _progressValue;

        bool goalCompleted = fitnessGoals[_goalId].currentProgress >= fitnessGoals[_goalId].targetValue;

        if (goalCompleted) {
            fitnessGoals[_goalId].isCompleted = true;
            tokenBalances[msg.sender] += fitnessGoals[_goalId].tokenReward;
        }

        emit GoalProgressUpdated(_goalId, fitnessGoals[_goalId].currentProgress, goalCompleted);
    }
}
```

## Frontend (HTML + JavaScript)

The frontend is a simple HTML and JavaScript application that allows users to:

- **Create Fitness Goals**: Provide a description, target value, and token reward.
- **Update Goal Progress**: Input progress values to update their fitness goal.
- **View Goals**: See a list of goals, including the progress and completion status.
- **View Token Balance**: Track the token balance earned upon completing goals.

### Key Components of the Frontend:

- **Web3.js**: The frontend is built using Web3.js to interact with the Ethereum network and the deployed smart contract.
- **MetaMask**: MetaMask is used for wallet integration, ensuring users can sign transactions and interact with the blockchain.

#### Dependencies:

- **Web3.js**: Library for interacting with Ethereum blockchain and smart contracts.

You can load Web3.js in the frontend by including the following script tag in the HTML:

```html
<script src="https://cdn.jsdelivr.net/npm/web3@1.6.1/dist/web3.min.js"></script>
```

## Setup Instructions

### Prerequisites

1. **MetaMask**: Make sure you have MetaMask installed in your browser for wallet management.
2. **Ethereum Network**: You need an Ethereum-compatible network like Ethereum mainnet, Rinkeby, or Goerli for testing.
3. **Deployed Contract**: The contract needs to be deployed on the blockchain. Replace the `contractAddress` and `contractABI` in the frontend code with your contract's actual address and ABI.

### Steps to Run the DApp:

1. **Install MetaMask**:

   - Install MetaMask in your browser (Chrome/Firefox).
   - Set up MetaMask and connect it to a test network like Rinkeby or Goerli.

2. **Deploy the Smart Contract**:

   - Deploy the `FitnessGoalTracker` contract to an Ethereum-compatible network using Remix IDE or Truffle.

3. **Modify the Frontend**:

   - Replace `YOUR_CONTRACT_ADDRESS` with the actual contract address in the frontend JavaScript code.
   - Make sure the ABI of the deployed contract is included in the frontend code.

4. **Open the Frontend**:
   - Open `index.html` in a browser with MetaMask installed.
   - Connect MetaMask to the DApp, create goals, track progress, and view your token balance!

### Example of Creating a Goal

1. Open the DApp in your browser.
2. Enter a description for the goal (e.g., "Run 5 km"), a target value (e.g., 5 km), and a token reward (e.g., 100 tokens).
3. Click **Create Goal**.
4. Your goal will be added to the list, and you can start updating your progress.
5. Once you complete your goal, you will earn the specified token reward.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
