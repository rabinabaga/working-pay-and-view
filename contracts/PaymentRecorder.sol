// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentRecorder {
    struct Payment {
        address payer;
        uint256 amount;
        uint256 timestamp;
    }

    Payment[] public payments;

    event PaymentMade(address indexed payer, uint256 amount, uint256 timestamp);

    function makePayment() external payable {
        require(msg.value > 0, "Payment must be greater than zero");

        payments.push(Payment(msg.sender, msg.value, block.timestamp));

        emit PaymentMade(msg.sender, msg.value, block.timestamp);
    }

    function getPayments() external view returns (Payment[] memory) {
        return payments;
    }
}
