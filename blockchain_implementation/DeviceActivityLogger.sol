pragma solidity ^0.5.0;

contract DeviceActivityLogger {
    constructor() public{
        owner = msg.sender;
    }
    address owner;
    mapping(uint => Device) db;
    struct Device {
        uint logCount;
        bytes logs;
    }
    function addLog(uint devId, string memory log) public{
        require(msg.sender == owner, "access denied");
        Device storage dev = db[devId];
        dev.logs = abi.encodePacked(dev.logs,log);
        dev.logCount++;
    }
    function getLogs(uint devId) public view returns(string memory) {
        require(msg.sender == owner, "access denied");
        Device storage dev = db[devId];
        return string(dev.logs);
    }
}