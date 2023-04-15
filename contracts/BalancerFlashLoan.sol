// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IFlashLoanRecipient.sol";

contract FlashLoanRecipient is IFlashLoanRecipient {
    /**
    * @dev the vault holds and manages all the assets added by all Balancer pools.
    **/
    IVault private constant vault;
    address private owner;

    constructor(address _vault) {
        owner = msg.sender;
        vault = _vault;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action");
        _;
    }

    function makeFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external {
      vault.flashLoan(this, tokens, amounts, userData);
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external override {
        require(msg.sender == vault);

    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}
