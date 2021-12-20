// SPDX-License-Identifier: MIT
// Yunus GUMUSSOY - The First Step of Being a Blockchain Developer

// solidity version
pragma solidity ^0.6.0;

// defining contract, contract is equal to class in Java
contract SimpleStorage {
    
    // this will get initialized to 0!
    // uint means unsigned integer
    uint256 favoriteNumber;
    
    //bool means boolean, true or false
    bool favoriteBool;
    
    // struct is a way to creating new objects
    struct People {
        uint256 favoriteNumber;
        string name;
    }
    
    // array is a way of storing a list of an object or type
    // dynamic array [] can change i.e, size
    // fixed array [1] cannot change
    People[] public people;
    // mapping is a dictionary like data structure, with 1 value per key
    mapping(string => uint256) public nameToFavoriteNumber;
    
    // this is the easiest way to define a function
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    // view is used to read the state of the blockchain
    // pure is used to add some formula to change the variable
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    
    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }    
    
}
