pragma solidity ^0.4.4;

import 'democracy/LiquidDemocracy.sol';

library CreatorLiquidDemocracy {
    function create(address votingWeightToken, string forbiddenFunctionCall, uint256 percentLossInEachRound) returns (LiquidDemocracy)
    { return new LiquidDemocracy(votingWeightToken, forbiddenFunctionCall, percentLossInEachRound); }

    function version() constant returns (string)
    { return "v0.5.0 (6d589277)"; }

    function abi() constant returns (string)
    { return '[{"constant":true,"inputs":[],"name":"numberOfVotes","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"lastWeightCalculation","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"delegatedPercent","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"voterId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"nominatedAddress","type":"address"}],"name":"vote","outputs":[{"name":"voteIndex","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"voteWeight","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numberOfDelegationRounds","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"appointee","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"votingToken","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"forbiddenFunction","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"target","type":"address"},{"name":"valueInEther","type":"uint256"},{"name":"bytecode","type":"bytes32"}],"name":"execute","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"delegatedVotes","outputs":[{"name":"nominee","type":"address"},{"name":"voter","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"calculateVotes","outputs":[{"name":"winner","type":"address"}],"payable":false,"type":"function"},{"inputs":[{"name":"votingWeightToken","type":"address"},{"name":"forbiddenFunctionCall","type":"string"},{"name":"percentLossInEachRound","type":"uint256"}],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newAppointee","type":"address"},{"indexed":false,"name":"changed","type":"bool"}],"name":"NewAppointee","type":"event"}]'; }
}
