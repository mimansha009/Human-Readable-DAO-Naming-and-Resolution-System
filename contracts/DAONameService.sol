// SPDX-License-Identifier:mit
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DAONameService is Ownable {
    struct DAORecord {
        address daoAddress;
        string description;
        uint256 registrationDate;
    }

    mapping(string => DAORecord) public nameToRecord;
    mapping(address => string) public addressToName;
    mapping(string => bool) public nameExists;

    event NameRegistered(string name, address daoAddress);
    event NameUpdated(string name, address newDaoAddress);
    event DescriptionUpdated(string name, string newDescription);

    function registerName(
        string memory _name,
        address _daoAddress,
        string memory _description
    ) external onlyOwner {
        require(!nameExists[_name], "Name already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");

        nameToRecord[_name] = DAORecord({
            daoAddress: _daoAddress,
            description: _description,
            registrationDate: block.timestamp
        });

        addressToName[_daoAddress] = _name;
        nameExists[_name] = true;

        emit NameRegistered(_name, _daoAddress);
    }

    function updateDAOAddress(string memory _name, address _newDaoAddress) external onlyOwner {
        require(nameExists[_name], "Name not registered");
        
        address oldAddress = nameToRecord[_name].daoAddress;
        delete addressToName[oldAddress];
        
        nameToRecord[_name].daoAddress = _newDaoAddress;
        addressToName[_newDaoAddress] = _name;

        emit NameUpdated(_name, _newDaoAddress);
    }

    function resolveName(string memory _name) external view returns (address, string memory, uint256) {
        require(nameExists[_name], "Name not registered");
        DAORecord memory record = nameToRecord[_name];
        return (record.daoAddress, record.description, record.registrationDate);
    }
}
