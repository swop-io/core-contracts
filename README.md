# core-contracts

Smart Contracts for Swop dApp - https://youtu.be/UamRRDiRd-o

## Smart Contract Design

#### Upgradeable Pattern
![](https://user-images.githubusercontent.com/47552061/63214293-84869600-c0e4-11e9-9bac-72b666d14574.png)

#### Architecture Design
![](https://user-images.githubusercontent.com/47552061/63214294-87818680-c0e4-11e9-8a79-a52de4be2cff.png)

## Deployments

Network : Ropsten

Contract Deployment Addresses : [Link](https://github.com/swop-io/core-contracts/blob/master/ropsten_deployment_details.txt)

Proxy Contract : [Link](https://ropsten.etherscan.io/address/0xADae430656F2f58D3b99dd35A6f10E7c5345B45e)

## Local Tests

1. Run ganache-cli -d
2. truffle test or single tests
3. truffle test test/SwopManager.test.js
4. truffle test test/Auctions.test.js
