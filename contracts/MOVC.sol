
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MoveCoin {
    string public name = "Move Coin";
    string public symbol = "MOVC";
    uint8 public decimals = 18;
    uint256 public totalSupply = 21000000 * 10**uint256(decimals);
    uint256 public distributedSupply = 0;

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public lastActive;
    mapping(address => mapping(address => uint256)) public allowance;

    address public immutable owner;
    uint256 public feeBase = 1; // 0.01% default
    uint256 public constant FEE_DIVISOR = 10000; // 0.01% = 1/10000
    address public reservePool;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event FeeCollected(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _reservePool) {
        owner = msg.sender;
        reservePool = _reservePool;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _updateInactivity(msg.sender);
        uint256 fee = calculateFee(msg.sender, value);
        uint256 sendAmount = value - fee;

        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += sendAmount;
        balanceOf[reservePool] += fee;

        emit Transfer(msg.sender, to, sendAmount);
        emit FeeCollected(msg.sender, fee);
        return true;
    }

    function _updateInactivity(address user) internal {
        lastActive[user] = block.timestamp;
    }

    function calculateFee(address user, uint256 value) public view returns (uint256) {
        uint256 inactivityYears = (block.timestamp - lastActive[user]) / 31536000;
        uint256 multiplier = inactivityYears > 0 ? inactivityYears : 1;
        return (value * feeBase * multiplier) / FEE_DIVISOR;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(distributedSupply + amount <= totalSupply, "Exceeds cap");
        distributedSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        distributedSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
