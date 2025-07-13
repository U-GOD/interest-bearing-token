# InterestBearingToken

An ERC-20 token that automatically increases balances over time, similar to Compound’s cTokens.

This project was built step by step to learn how interest accrual via an exchange rate works.

---

## 📄 Overview

**InterestBearingToken** is an ERC-20 token where:

- Users *mint* iTokens by depositing an underlying ERC-20.
- The *exchange rate* increases over time, representing accrued interest.
- Users can *redeem* their iTokens to receive more underlying tokens than they deposited, reflecting interest growth.

---

## ⚙️ How It Works

- **Exchange Rate:**
  - Starts at an initial value (e.g., 1e18).
  - Grows every second by `interestRatePerSecond`.
  - Updated by `accrueInterest()` when minting, redeeming, or manually called.

- **Minting:**
  - Users deposit underlying tokens.
  - They receive iTokens proportional to the current exchange rate.

- **Redeeming:**
  - Users burn iTokens.
  - They receive underlying tokens based on the current exchange rate.

---

## 🛠 Contracts

- `InterestBearingToken.sol`: The core contract.
- `InterestToken.sol`: A simple ERC-20 used for testing.

---

## 📝 Example Deployment Parameters

When deploying `InterestBearingToken`, you must provide:

1. **Underlying Token Address**  
   (The ERC-20 contract you deployed)

2. **Initial Exchange Rate (uint256)**  
   Recommended: `1e18`

3. **Interest Rate Per Second (uint256)**  
   Example:  
   For ~5% annual interest:  
5% / 365 days / 24h / 60m / 60s
≈ 1.58e-9 per second

Scaled by `1e18`: `1580000000`

---

## ✨ Example Workflow

1. **Deploy Underlying Token**
- Deploy an ERC20 token called `InterestToken`.
2. **Deploy InterestBearingToken**
- Pass the underlying token address and parameters.
3. **Approve Spending**
- Approve the contract to spend your tokens:
  ```solidity
  approve(<InterestBearingToken address>, <amount>)
  ```
4. **Mint iTokens**
- Call `mint(amount)`.
5. **Wait or accrue interest**
- Optionally call `accrueInterest()`.
6. **Redeem iTokens**
- Call `redeem(iTokenAmount)` to get underlying tokens back with interest.

---


---

## 📚 Learning Goals

✅ Learn how exchange rates model interest growth  
✅ Practice safe ERC-20 transfers  
✅ Understand minting and redeeming tokens  

---

## 📜 License

MIT
