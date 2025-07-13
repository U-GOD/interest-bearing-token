# InterestBearingToken

An ERC-20 token that automatically increases balances over time, similar to Compound’s cTokens. This project was built step by step to learn how interest accrual via an exchange rate works.

**InterestBearingToken** is an ERC-20 token where users mint iTokens by depositing an underlying ERC-20. The exchange rate increases over time, representing accrued interest. Users can redeem their iTokens to receive more underlying tokens than they deposited, reflecting interest growth.

**How It Works:** Exchange Rate starts at an initial value (e.g., 1e18) and grows every second by interestRatePerSecond, updated by accrueInterest() when minting, redeeming, or manually called. Minting allows users to deposit underlying tokens and receive iTokens proportional to the current exchange rate. Redeeming lets users burn iTokens and receive underlying tokens based on the current exchange rate.

**Contracts:** InterestBearingToken.sol (the core contract) and InterestToken.sol (a simple ERC-20 used for testing).

**Example Deployment Parameters:** When deploying InterestBearingToken, you must provide: 1) Underlying Token Address (the ERC-20 contract you deployed), 2) Initial Exchange Rate (uint256), recommended: 1000000000000000000 (1e18), 3) Interest Rate Per Second (uint256), for example, for ~5% annual interest: 5% / 365 days / 24h / 60m / 60s ≈ 1.58e-9 per second, scaled by 1e18: 1580000000.

**Example Workflow:** Deploy Underlying Token (e.g., InterestToken), deploy InterestBearingToken with the underlying token address and parameters, approve the contract to spend your tokens using approve(<InterestBearingToken address>, <amount>), mint iTokens with mint(amount), wait or accrue interest by calling accrueInterest(), redeem iTokens with redeem(iTokenAmount) to get underlying tokens back with interest.

**Repo Name Suggestion:** interest-bearing-token

**Learning Goals:** Learn how exchange rates model interest growth, practice safe ERC-20 transfers, understand minting and redeeming tokens.

**License:** MIT
