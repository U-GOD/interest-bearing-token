// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title InterestBearingToken
 * @notice ERC20 token whose balances grow over time based on an exchange rate.
 */
contract InterestBearingToken is ERC20, Ownable {
    // Underlying token that users supply
    IERC20 public immutable underlying;

    // The exchange rate scaled by 1e18
    uint256 public exchangeRate;

    // Last time the interest accrued
    uint256 public lastAccrualTime;

    // Interest rate per second, scaled by 1e18
    uint256 public interestRatePerSecond;

    event Mint(address indexed user, uint256 underlyingAmount, uint256 iTokenAmount);
    event Redeem(address indexed user, uint256 underlyingAmount, uint256 iTokenAmount);

    constructor(
        address _underlying,
        uint256 _initialExchangeRate,
        uint256 _interestRatePerSecond
    ) ERC20("Interest Bearing Token", "iToken") Ownable(msg.sender) {
        require(_underlying != address(0), "Invalid underlying token");
        require(_initialExchangeRate > 0, "Initial exchange rate required");

        underlying = IERC20(_underlying);
        exchangeRate = _initialExchangeRate;
        interestRatePerSecond = _interestRatePerSecond;
        lastAccrualTime = block.timestamp;
    }

    /**
     * @notice Accrue interest by updating the exchange rate
     */
    function accrueInterest() public {
        uint256 elapsed = block.timestamp - lastAccrualTime;
        if (elapsed > 0) {
            // New exchange rate = old rate * (1 + rate * time)
            uint256 interest = (exchangeRate * interestRatePerSecond * elapsed) / 1e18;
            exchangeRate += interest;
            lastAccrualTime = block.timestamp;
        }
    }

    /**
     * @notice Mint iTokens by depositing underlying tokens
     * @param amount The amount of underlying tokens to deposit
     */
    function mint(uint256 amount) external {
        require(amount > 0, "Amount must be >0");

        // Accrue interest up to now
        accrueInterest();

        // Transfer underlying tokens from the user to this contract
        require(underlying.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        // Calculate how many iTokens to mint
        uint256 iTokensToMint = (amount * 1e18) / exchangeRate;

        _mint(msg.sender, iTokensToMint);

        emit Mint(msg.sender, amount, iTokensToMint);
    }

        /**
     * @notice Redeem underlying tokens by burning iTokens
     * @param iTokenAmount The amount of iTokens to redeem
     */
    function redeem(uint256 iTokenAmount) external {
        require(iTokenAmount > 0, "Amount must be >0");
        require(balanceOf(msg.sender) >= iTokenAmount, "Not enough balance");

        // Accrue interest up to now
        accrueInterest();

        // Calculate how much underlying token to return
        uint256 underlyingAmount = (iTokenAmount * exchangeRate) / 1e18;

        require(underlyingAmount > 0, "Redeem amount too small");

        _burn(msg.sender, iTokenAmount);

        // Transfer underlying tokens to the user
        require(underlying.transfer(msg.sender, underlyingAmount), "Transfer failed");

        emit Redeem(msg.sender, underlyingAmount, iTokenAmount);
    }
}
