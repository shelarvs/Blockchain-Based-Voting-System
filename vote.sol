pragma solidity ^0.8.0;

contract Database{
    
    address government;
    bool isVotingData;
    address[] candidateData;
    address[] citizenData;
    address canWin;
    
    
    struct citizen{
        address id;
        string assem;
        bool isVoting;
    }
    
    struct candidate{
        address can_id;
        string name;
        string assem;
        bool verify;
    }
    
    struct votes{
        address candidate_id;
        address[] voterID;
        uint count;
    }
    
    mapping(address=>citizen)voter;
    mapping(address=>candidate)candi;
    mapping(address=>votes)vote;
    
    
    event message(string msg);
    event winner(string msg,address id, uint votes);
    
    constructor(){
        government = msg.sender;
        isVotingData = false;
    }
    
     modifier onlyGov(){
        require (government == msg.sender, "Access Denied");
        _;
    }
    
    function register_voter(address _id,string memory _assem)public onlyGov{
        require(government != _id, "GOVERMENT CANNOT BE CITIZEN");
        voter[msg.sender].id = _id;
        voter[msg.sender].assem = _assem;
      
        citizenData.push(_id);
        emit message("Voter Registered Successfully");
    }
    
    function register_candiate( string memory _name, string memory _assem)public{
        require(government != msg.sender, "GOVERMENT CANNOT BE CANDIDATE");
        candi[msg.sender].can_id = msg.sender;
        candi[msg.sender].name = _name;
        candi[msg.sender].assem = _assem;
        candi[msg.sender].verify = false;
        emit message("Candiate Registered Successfully");
        candidateData.push(msg.sender);
    }
    
    function verifyCandidate(address _can_id)public onlyGov{
        candi[_can_id].verify = true;
        emit message("Candiate Verified Successfully");
    }
    
    function startVoting() public onlyGov{
        require(isVotingData==false,"Voting Process is already STARTED");
        isVotingData = true;
        emit message("Voting process started");
    }
    
    function stopVoting() public onlyGov{
        require(isVotingData==true,"Voting Process is already STOPED");
        isVotingData = false;
    }
    
    function voteNow(address _can_id)public{
        require(voter[msg.sender].isVoting == false,"Candidate Already Voted");
        require(voter[msg.sender].id == msg.sender,"Voter Not Registered");
        vote[_can_id].candidate_id = _can_id;
        vote[_can_id].count +=1 ;       
        voter[_can_id].isVoting = true;
        }
    
    
    function countVotes() public onlyGov{
         uint i=0;
         uint high = 0;
         uint prev_temp_counting = 0;
         uint size = candidateData.length;
         for(i=0;i<size;i++){
             high = vote[candidateData[i]].count;
             if(high>prev_temp_counting){
                 canWin = candidateData[i];
             }
             else{
                 prev_temp_counting = high;
             }
         }
        
        emit winner("winner", canWin, high);
    }
    
    function viewCandiate(address _can_id) public view returns(address,string memory,string memory,bool){
        return(candi[_can_id].can_id,candi[_can_id].name,candi[_can_id].assem,candi[_can_id].verify);
    }
    
}
