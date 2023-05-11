//Hediene Bahri
pragma solidity ^0.7.0;


interface ERC20 {
    function totalSupply()  external returns (uint256);
    function balanceOf(address account) external returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract HandmadeCraftsToken  {

    address public owner;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;

    
    constructor() public {
        owner = msg.sender;
        totalSupply = 100000000;
        balances[owner] = totalSupply;
    }

    
    function issueTokens(uint256 _amount) public {
        
    require(msg.sender == owner, "Only the owner can issue tokens.");
    
    totalSupply += _amount;
    
    balances[owner] += _amount;
    }
    function buyCraft(address _seller, uint256 _price) public payable {
       
        require(balances[msg.sender] >= _price, "Insufficient balance.");
        require(balances[_seller] >= 1, "Seller does not have enough crafts to sell.");
        balances[msg.sender] -= _price;
        balances[_seller] += _price;
        balances[_seller] -= 1;
        balances[msg.sender] += 1;
    }

    
    function sellCraft(address _buyer, uint256 _price) public {
        require(balances[msg.sender] >= 1, "Seller does not have any crafts to sell.");
        require(balances[_buyer] >= _price, "Buyer does not have enough tokens.");
        balances[_buyer] -= _price;
        balances[msg.sender] += _price;
        balances[msg.sender] -= 1;
        balances[_buyer] += 1;
    }
}


contract ICO is HandmadeCraftsToken {

    uint256 public tokenPrice;
    uint256 public startTime;
    uint256 public endTime;
    event TokenPurchase(address purchaser, uint256 value, uint256 tokens);
    constructor(uint256 _tokenPrice, uint256 _startTime, uint256 _endTime) public HandmadeCraftsToken() {
    tokenPrice = 1 wei;
    startTime = block.timestamp;
    endTime = block.timestamp + 7 weeks;
}

function buyTokens(uint256 value) public payable {

    require(block.timestamp >= startTime && block.timestamp <= endTime, "ICO is not ongoing.");
    uint256 tokens = (value*(10 ** 18)) / (tokenPrice);
    if (block.timestamp <= startTime + 1 weeks) {
        uint256 discount = (tokens*(22)) / (100);
        tokens = tokens - discount;
    }

    require(value >= (tokens*(tokenPrice)) / (10 ** 18), "Insufficient balance.");
    balances[msg.sender] = balances[msg.sender] + tokens;
    totalSupply = totalSupply - tokens;
    msg.sender.transfer(tokens);
    emit TokenPurchase(msg.sender, value, tokens);
}
}


