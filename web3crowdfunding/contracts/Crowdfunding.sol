// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding
 {
  struct campaign{
      address owner;
      string title;
      string description;
      uint target;
      uint deadline;
      uint amountCollected;
      string image;
      address [] donators;
       uint [] donations;
  }
  mapping (uint=> campaign) public campaigns;
  uint public noOfCampaigns = 0;


  function  CreateCampaign( address _owner, string memory _title, string memory _description , uint _taarget , uint _deadline, string memory _image) public{
       campaign storage newCamp = campaigns[noOfCampaigns];
       require(newCamp.deadline > block.timestamp, "you should create campaign for future only");
        newCamp.owner = _owner;
        newCamp.title = _title;
        newCamp.description = _description;
        newCamp.target = _taarget;
        newCamp.deadline = _deadline;
        newCamp.amountCollected =0; 
        newCamp.image = _image;
        noOfCampaigns++;
        
  }

  function donateTocampaign(uint returnId) public payable {
     campaign storage newcamp = campaigns[returnId];
     uint amount = msg.value;
     newcamp.donators.push(msg.sender);
     newcamp.donations.push(amount);
     (bool sent, ) = payable (newcamp.owner).call{value:amount}("");
     if(sent){
         newcamp.amountCollected  += amount;
     }


  }

  function getDonators( uint _rid) view  public returns( address [] memory , uint [] memory ){
        return(campaigns[_rid].donators, campaigns[_rid].donations);
  }

  function getCampaigns()  view public  returns ( campaign[] memory){
        campaign[] memory allcampaingn = new campaign[](noOfCampaigns);
         for( uint i =0 ; i < noOfCampaigns ; i++){
             campaign storage item = campaigns [i];
             allcampaingn[i] = item;
         }

         return allcampaingn;
  }
}