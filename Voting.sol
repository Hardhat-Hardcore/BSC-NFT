pragma solidity 0.8.1;

contract Voting {
    
    mapping(uint256 => uint256) voteCount;
    string[] candidates;
    
    constructor(string[] memory _candidates) {
        for(uint256 i = 0; i < _candidates.length; i++){
            candidates.push(_candidates[i]);
        }
    }
    
    function getCandidate() 
        external 
        view 
        returns(string[] memory) 
    {
        return candidates;
    }
    
    function getVotingResult(uint256 _candidatesIndex) 
        external 
        view
        returns(string memory, uint256) 
    {
        return (candidates[_candidatesIndex], voteCount[_candidatesIndex]);
    }
    
    function voteToCandadite(uint256 _candidatesIndex) 
        external 
    {
        require(_candidatesIndex < candidates.length, "Index of candidates is not existed.");
        voteCount[_candidatesIndex] += 1;
    }
    
}
