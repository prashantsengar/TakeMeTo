pragma solidity ^0.4.24;

/// Changelog





/// Changelog ends


// ----------------------------------------------------------------------------
// '0Fucks' token contract
//
// Deployed to : 0x5A86f0cafD4ef3ba4f0344C138afcC84bd1ED222
// Symbol      : 0FUCKS
// Name        : 0 Fucks Token
// Total supply: 100000000
// Decimals    : 18
//
// Enjoy.
//
// (c) by Moritz Neto with BokkyPooBah / Bok Consulting Pty Ltd Au 2017. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract TakeMeTo is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    
    address contract_owner = 0x3926c523A7A40962012992880d8E8E939234D4f6;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    uint totalReviews;
    address contract_address;
    string contract_time;
    

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "TM2";
        name = "TaMeTo Coin";
        decimals = 3;
        _totalSupply = 10000000000;
        balances[contract_owner] = _totalSupply;
        emit Transfer(address(0), contract_owner, _totalSupply);
        
        
        /// Change the contract address
        contract_address = address(this);
        
        totalReviews=0;
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to to account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public onlyOwner returns (bool success) {
        balances[contract_owner] = safeSub(balances[contract_owner], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(contract_owner, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public onlyOwner returns (bool success) {
        allowed[contract_owner][spender] = tokens;
        emit Approval(contract_owner, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer tokens from the from account to the to account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the from account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public onlyOwner returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        // allowed[from][contract_owner] = safeSub(allowed[from][contract_owner], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for spender to transferFrom(...) tokens
    // from the token owner's account. The spender contract function
    // receiveApproval(...) is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[contract_owner][spender] = tokens;
        emit Approval(contract_owner, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(contract_owner, tokens, this, data);
        return true;
    }


    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    
    function get_contract_address() public view returns(address){
        return contract_address;
    }
    
struct website{
    uint category;
    string url;
    string title;
    address submitter;
    bool stakingOver;
    
    uint totalVotes;
    int votes;
    uint128 stakes;
    mapping (address => int) validators;
    mapping (address => uint[2]) rewards;
    address[] allValidators;
    bool calculated_rewards;
    uint creationTime;
}

mapping  (string => bool) allURLs;
mapping (uint => uint[2]) URLtoCat; // x[URLid] = categorynum, categoryINDEX

website[] cat1;
website[] cat2;
website[] cat3;
website[] cat4;
website[] cat5;
website[] cat6;
uint[6][] categorized_websites;
uint totalWebsites = 0;

function gettotal(uint category) public view returns(uint){
    if (category==1){
        return cat1.length;
    }
    else if (category==2){
        return cat2.length;
    }
    else if (category==3){
        return cat3.length;
    }
    else if (category==4){
        return cat4.length;
    }
    else if (category==5){
        return cat5.length;
    }
    else if (category==6){
        return cat6.length;
    }
    else if (category==0){
        return cat1.length+cat2.length+cat3.length+cat4.length+cat5.length+cat6.length;
    }
}


function submitUrl(uint category, string url, string title, address submitter) public returns(bool){
    if (allURLs[url]==true){
        return false;
    }
    address[] memory v;
    if (category==1){
        URLtoCat[totalWebsites] = [1, cat1.length];
        cat1.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    else if (category==2){
        URLtoCat[totalWebsites] = [2, cat1.length];
        cat2.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    else if (category==3){
        URLtoCat[totalWebsites] = [3, cat1.length];
        cat3.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    else if (category==4){
        URLtoCat[totalWebsites] = [4, cat1.length];
        cat4.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    else if (category==5){
        URLtoCat[totalWebsites] = [5, cat1.length];
        cat5.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    else if (category==6){
        URLtoCat[totalWebsites] = [6, cat1.length];
        cat6.push(website(category, url, title, submitter, false, 0, 0, 0, v, false, now));
    }
    totalWebsites++;
    return true;
}

function getURL(uint ID, uint category) public view returns (string){
    if (category==0){
        if (ID<cat1.length){
            return cat1[ID].url;
        }
        if (ID<cat2.length){
            return cat2[ID].url;
        }
        if (ID<cat3.length){
            return cat3[ID].url;
        }
        if (ID<cat4.length){
            return cat4[ID].url;
        }
        if (ID<cat5.length){
            return cat5[ID].url;
        }
        if (ID<cat6.length){
            return cat6[ID].url;
        }
    }
    
    if (category==1){
        return cat1[ID].url;
    }
    if (category==2){
        return cat2[ID].url;
    }
    if (category==3){
        return cat3[ID].url;
    }
    if (category==4){
        return cat4[ID].url;
    }
    if (category==5){
        return cat5[ID].url;
    }
    if (category==6){
        return cat6[ID].url;
    }
}

function getWeb(uint urlID) internal view returns(website storage){
    uint[2] storage categoryNid = URLtoCat[urlID];
    website storage Web;
    if (categoryNid[0]==1){
        Web = cat1[categoryNid[1]];
    }
    else if (categoryNid[0]==2){
        Web = cat2[categoryNid[1]];
    }
    else if (categoryNid[0]==3){
        Web = cat3[categoryNid[1]];
    }
    else if (categoryNid[0]==4){
        Web = cat4[categoryNid[1]];
    }
    else if (categoryNid[0]==5){
        Web = cat5[categoryNid[1]];
    }
    else if (categoryNid[0]==6){
        Web = cat6[categoryNid[1]];
    }
    return Web;
}

function AddVote(uint urlID, address validator, int votes, uint128 stakes) internal {
    website storage Web = getWeb(urlID);
    
    require(Web.validators[validator]==0, 'Validator has already voted');
    require(Web.submitter!=validator, 'Reviewer cannot validate');
    Web.validators[validator] = votes;
    Web.votes += votes;
    Web.stakes += stakes;
    Web.totalVotes+=1;
    Web.allValidators.push(validator);

}

function isUnderStaking(uint URLid)public view returns(bool){
    return !getWeb(URLid).stakingOver;
}

function Vote(uint urlID, address validator, bool up, uint128 tokens) public returns(bool){
    // require(validator.tokens >= tokens, "Insufficient balance");
    int votes = 0;
    if (up==true){
        votes = tokens;
    } 
    else{
        votes = -1*int(tokens);
    }
    // stakingToken.burn(validator, tokens);
    transferFrom(validator, contract_address, tokens);
    AddVote(urlID, validator, votes, tokens);
    return true;
}


function claimReward(address person, uint URLid) public{
    website storage Web = getWeb(URLid);
    
    if (Web.calculated_rewards==false){
        calculateReward(URLid);
    }
    require(Web.rewards[person][1]==0, 'Already claimed reward');
    if (Web.calculated_rewards==true){
        uint reward_amount = Web.rewards[person][0];
        giveReward(person, reward_amount);
        Web.rewards[person][0] = 0; // After a person has claimed his reward, make his reward amount to be 0 so that he cannot claim again
        Web.rewards[person][1] = 1;
    }
}

function giveReward(address person, uint reward_amount) internal{
    // stakingToken.reward(person, reward_amount);
    transferFrom(contract_address, person, reward_amount);
}

function ifrewardCalculated(uint URLid) public view returns(bool){
    return getWeb(URLid).calculated_rewards;
}

function stakingStatus(uint URLid) internal view returns (bool) {
    website memory Web = getWeb(URLid);
    if (now < Web.creationTime + 5 seconds) {
        return false;
    } else {
        return true;
    }
}

function calculateReward(uint URLid) public returns(bool){
    require(stakingStatus(URLid), "Not yet");
    website storage Web = getWeb(URLid);
    
    uint total = Web.stakes;
    
    uint total_reviewers = Web.allValidators.length;
    require(total_reviewers>0, "No validators");
    
    int votes = Web.votes;
    


    if (votes>0){
        
        uint positive_reviewers = 0;
        
        for( uint i=0; i<total_reviewers; i++){
            if ( Web.validators[Web.allValidators[i]] > 0){
                positive_reviewers++;
            }
        }
        
        for( i=0; i<total_reviewers; i++){
            if ( Web.validators[Web.allValidators[i]] > 0){
                Web.rewards[Web.allValidators[i]][0] = total/positive_reviewers;
            }
        }
    }
    
    // if invalidated Web
    else if (votes<0){
        
        uint negative_reviewers = 0;
        
        for( i=0; i<total_reviewers; i++){
            if ( Web.validators[Web.allValidators[i]] < 0){
                negative_reviewers++;
            }
        }
        
        for( i=0; i<total_reviewers; i++){
            if ( Web.validators[Web.allValidators[i]] < 0){
                Web.rewards[Web.allValidators[i]][0] = total/negative_reviewers;
            }
        }
    }
    
    else if (votes==0){
        
        
        for( i=0; i<total_reviewers; i++){
            uint reward = 0;
            
            if (Web.validators[Web.allValidators[i]]<0){
                reward = uint(-1*Web.validators[Web.allValidators[i]]);
            }
            else{
                reward = uint(Web.validators[Web.allValidators[i]]);   
            }
            Web.rewards[Web.allValidators[i]][0] = reward;
        }
    }
    
    Web.calculated_rewards = true;
    Web.stakingOver = true;
    return true;
}


}