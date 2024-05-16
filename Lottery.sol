//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";


contract Lottery{ 
    address payable public _manager; 
    address payable[] public _players;
    uint public lotteryID;
    mapping (uint => address payable) lotteryHistory;
    
   using BokkyPooBahsDateTimeLibrary for uint;

   error InSufficientLotteryValueBuy(uint256 MinimumValue, string msg);
   event ActionSuccess(string message);

    struct WinningDetails {
        uint LotteryID;
        uint WinningAmount;
        string comments;
        string WinningTime; 
        address payable Winner;
    }
    
    mapping (uint => WinningDetails) lotteryHistoryWinning;

    modifier restrictedOnlyOwner(){
        require(msg.sender == _manager); 
        _;
    }


    constructor(){
        _manager = payable (msg.sender);
        lotteryID = 1;
    }

    function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
        (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    function getWinnerDetails(uint _lotteryId) public view returns (WinningDetails memory wd ){
        return lotteryHistoryWinning[_lotteryId];
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return _players;
    }

    

    function enter() public payable{ 
        require(msg.value > .001 ether,"Minimum value of 2000000000000000 Wei needed"); 
        _players.push(payable(msg.sender));
        emit ActionSuccess("Entered into Lottery");
    }
    
    function random() public view returns(uint){ 
        return uint (keccak256(abi.encodePacked(_manager, block.timestamp)));
    }

    function pickWinner(string memory comments) public restrictedOnlyOwner{ 
        uint index = random() % _players.length; 
        string memory wintimestamp = getCurrentTime(); // timestampToDate(block.timestamp);
        uint256 contractBalance = address(this).balance;
        string memory loterymsg = string.concat("Lottery " , Strings.toString(lotteryID), "- ", comments) ;
        WinningDetails memory wd = WinningDetails(lotteryID,contractBalance, loterymsg, wintimestamp,  _players[index]);
      
        _players[index].transfer(contractBalance);
 
        lotteryHistory[lotteryID] =  _players[index];
        lotteryHistoryWinning[lotteryID] = wd;

        lotteryID++;
        _players = new address payable[](0); 
    }

    

    function getCurrentTime() public view returns (string memory currentdate){
        // Get the current date and time (timestamp)
        uint year; uint month; uint day; uint hour;uint minute; uint second;
        (year,month,day,hour,minute,second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(block.timestamp);
        return (string.concat(Strings.toString(day),"/", Strings.toString(month),"/",Strings.toString(year)," ",
                              Strings.toString(hour),":",Strings.toString(minute),":",Strings.toString(second)));
    }

   
    
 

}


