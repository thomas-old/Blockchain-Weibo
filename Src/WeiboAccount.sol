pragma solidity ^0.4.0;

/**@title Weibo Management Contract */

contract WeiboAccount{
    
    //微博 Struct
    struct Weibo{
        uint timestamp;
        string weiboString;
    }

    //每个账户的微博数组: map 微博id 到微博
    mapping(uint => Weibo) _weibo;

    //微博数：
    uint _numberOfWeibo;

    //微博账户地址 "owner": 只有太能发
    address _adminAddress;

    //Constructor
    constructor() public{
        _numberOfWeibo = 0;
        _adminAddress = msg.sender;
    }

    function isAdmin() view public returns (bool isAdmin){
        return msg.sender == _adminAddress;
    }

    function postWeibo(string _weiboString) public returns (int result){
        if(!isAdmin()){
            result = -1;
        } else if (bytes(_weiboString).length > 1000){
            result = -2;
        } else {
            _weibo[_numberOfWeibo].timestamp = now;
            _weibo[_numberOfWeibo].weiboString = _weiboString;
            _numberOfWeibo++;
            result = 0; 
        }
    }

    function getWeibo(uint weiboId) view public returns (string weiboString, uint timestamp){
        weiboString = _weibo[weiboId].weiboString;
        timestamp = _weibo[weiboId].timestamp;
    }

    function getLatestWeibo() view public returns (string weiboString, uint timestamp, uint numberOfWeibo){
        weiboString = _weibo[_numberOfWeibo - 1].weiboString;
        timestamp = _weibo[_numberOfWeibo - 1].timestamp;
        numberOfWeibo = _numberOfWeibo;
    }

    function getOwnerAddress() view public returns (address adminAddress){
        return _adminAddress;
    }

    function getNumberOfTweets() view public returns (uint numberOfTwweets){
        return _numberOfWeibo;
    }

    //Donation 
    function adminRetrieveDonations(address receiver) public{
        if(isAdmin()){
            receiver.send(this.balance);
        }
    }

    function adminDeleteAccount() public{
        if(isAdmin()){
            selfdestruct(_adminAddress);
        }
    }
}