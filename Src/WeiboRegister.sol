pragma solidity ^0.4.0;

contract WeiboRegistry{
    
    //Map 账户地址，id和名字
    mapping(address => string) _addressToAccountName;
    mapping(uint => address) _accountIdToAccountAddress;
    mapping(string => address) _accountNameToAddress;

    uint _numberOfAccounts;

    //Owner
    address _registryAdmin;

    //Administrate WeiboAccount only
    address _accountAddress;

    bool _registrationDisabled;

    constructor() public {
        _numberOfAccounts = 0;
        _registryAdmin = msg.sender;
        _accountAddress = msg.sender;
        _registrationDisabled = false;
    }

    function register(string name, address accountAddress) public returns (int result){
        if (_accountNameToAddress[name] != address(0)){
            //账户名已被注册
            result = -1;
        } else if (bytes(_addressToAccountName[accountAddress]).length != 0){
            //以太坊地址已有注册账户
            result = -2;
        } else if (bytes(name).length >= 64){
            result = -3;
        } else if (_registrationDisabled){
            result = -4;
        } else {
            _addressToAccountName[accountAddress] = name;
            _accountIdToAccountAddress[_numberOfAccounts] = accountAddress;
            _accountNameToAddress[name] = accountAddress;
            _numberOfAccounts ++;
            result = 0;
        }
    }

    function getNumberOfAccounts() view public returns (uint numberOfAccounts) {
        numberOfAccounts = _numberOfAccounts;
    }

    function getAddressOfName(string name) view public returns (address addr) {
        addr = _accountNameToAddress[name];
    }

    function getNameOfAddress(address addr) view public returns (string name) {
        name = _addressToAccountName[addr];
    }
	
    function getAddressOfId(uint id) view public returns (address addr) {
        addr = _accountIdToAccountAddress[id];
    }

    function unregister() public returns (string unregisteredAccountName) {
        unregisteredAccountName = _addressToAccountName[msg.sender];
        _addressToAccountName[msg.sender] = "";
        _accountNameToAddress[unregisteredAccountName] = address(0); 
    }
	
    function adminUnregister(string name) public{
        if (msg.sender == _registryAdmin || msg.sender == _accountAddress) {
            address addr = _accountNameToAddress[name];
            _addressToAccountName[addr] = "";
            _accountNameToAddress[name] = address(0);
		}
    }
	
    function adminSetRegistrationDisabled(bool registrationDisabled) public {
        if (msg.sender == _registryAdmin) {
            _registrationDisabled = registrationDisabled;
        }
    }
	    
    function adminSetAccountAdministrator(address accountAdmin) public {  
        if (msg.sender == _registryAdmin) {
            _accountAddress = accountAdmin;
        }
    }
	
    function adminRetrieveDonations() public {
        if (msg.sender == _registryAdmin) {
            _registryAdmin.send(this.balance);
        }
    }
			
    function adminDeleteRegistry() public {
        if (msg.sender == _registryAdmin) {
            selfdestruct(_registryAdmin); 
		}
    }
}


