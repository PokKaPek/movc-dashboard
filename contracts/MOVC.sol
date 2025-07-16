// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Move Coin (MOVC)
/// @notice A decentralized, fixed-supply, fee-on-transfer ERC-20 token with dynamic inactivity-based fees.
interface IClaimVerifier {
    function verifyClaim(address user, uint256 distance, uint256 timestamp, bytes calldata proof) external view returns (bool);
}

contract MOVC is ERC20 {
    uint256 public constant MAX_SUPPLY = 21_000_000 * 1e18;
    uint256 public constant BASE_FEE = 1; // 0.01% in basis points (1/10000)
    address public immutable reservePool;
    IClaimVerifier public claimVerifier;

    mapping(address => uint256) public lastActivity;

    event FeeCollected(address indexed from, uint256 amount);
    event InactivityFeeCharged(address indexed from, uint256 feePercent);
    event MintedFromInactive(uint256 amount);
    event BurnedInactive(uint256 amount);

    modifier noMinting() {
        require(totalSupply() < MAX_SUPPLY, "Max supply reached");
        _;
    }

    constructor(address _verifier, address _reservePool) ERC20("Move Coin", "MOVC") {
        require(_reservePool != address(0), "Invalid reserve pool");
        claimVerifier = IClaimVerifier(_verifier);
        reservePool = _reservePool;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 feePercent = getDynamicFee(msg.sender);
        uint256 feeAmount = (amount * feePercent) / 10000;
        uint256 netAmount = amount - feeAmount;

        _transfer(_msgSender(), recipient, netAmount);
        _transfer(_msgSender(), reservePool, feeAmount);

        emit FeeCollected(_msgSender(), feeAmount);
        if (feePercent > BASE_FEE) {
            emit InactivityFeeCharged(_msgSender(), feePercent);
        }

        lastActivity[msg.sender] = block.timestamp;
        lastActivity[recipient] = block.timestamp;

        return true;
    }

    function getDynamicFee(address user) public view returns (uint256) {
        uint256 last = lastActivity[user];
        if (last == 0) return BASE_FEE;

        uint256 inactiveYears = (block.timestamp - last) / 365 days;
        return BASE_FEE + inactiveYears * 100; // +1% per year of inactivity
    }

    /// @notice Utility: check if address inactive by threshold
    function isInactive(address user, uint256 minInactiveYears) external view returns (bool) {
        uint256 last = lastActivity[user];
        if (last == 0) return false;
        return (block.timestamp - last) >= (minInactiveYears * 365 days);
    }

    /// @notice Minting logic based on detected total inactivity
    function mintInactive(uint256 amount) external noMinting {
        require(amount + totalSupply() <= MAX_SUPPLY, "Exceeds supply");
        _mint(reservePool, amount);
        emit MintedFromInactive(amount);
    }

    /// @notice Burn minted inactive coins if users return
    function burnFromReserve(uint256 amount) external {
        _burn(reservePool, amount);
        emit BurnedInactive(amount);
    }
}
