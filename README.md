# Airline Rewards Points Management System

A decentralized rewards points management system for airlines built using Ethereum smart contracts.

This project contains a set of smart contracts designed to manage various aspects of an airline rewards points system, such as user registration, points management, tier management, referral bonuses, promotions, and more. The smart contracts are written in Solidity and can be deployed using Truffle.

## Table of Contents

- [Requirements](#requirements)
- [Setup](#setup)
- [Smart Contracts](#smart-contracts)
- [Deployment](#deployment)
- [Testing](#testing)

## Requirements

- Node.js v12.x or later
- Truffle v5.x or later
- Ganache (optional, for local development)

## Setup

1. Clone the repository:
    ```
    git clone https://github.com/christossk/airline-rewards-points-system.git
    cd airline-rewards-points-system
    ```

2. Install the required Node.js packages:
    ```
    npm install
    ```

3. Configure your desired network in the `truffle-config.js` file. If you're using Ganache for local development, the configuration should be already set up for you.

## Smart Contracts

This project contains the following smart contracts:

- UserRegistration
- UserPreferences
- AccountRecovery
- PointsManagement
- PointsRedemption
- PointsConversion
- PointsMarketplace
- TierManagement
- TierBenefits
- ReferralBonus
- PromotionsManagement
- PartnerIntegration
- CustomerSupport
- Leaderboard
- PointsHistory
- TierExpiry
- Challenges
- CorporateAccounts
- FraudDetection
- Notifications

Each smart contract is located in the `contracts` directory, with the Solidity source code and unit tests provided.

## Deployment

To deploy the smart contracts, follow these steps:

1. Compile the contracts:
    ```
    truffle compile
    ```

2. Run the deployment script:
    ```
    truffle migrate --network <your_network>
    ```
   Replace `<your_network>` with the name of the network you configured in `truffle-config.js`.

## Testing

(pending)
To run the provided unit tests, use the following command:
    ```
truffle test
    ```

This will execute the test suite using the configured network. Make sure to have a running instance of the network (e.g., Ganache) before running the tests.

---

For more information about the project and how to interact with the smart contracts, please refer to the inline comments in the Solidity source code and the deployment scripts.




