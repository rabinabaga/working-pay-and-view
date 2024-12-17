// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentRecorder {
    struct Payment {
        address payer;
        uint256 amount;
        uint256 timestamp;
    }

     struct Student {
        string studentId;
        string fullName;
        address walletAddress;
    }

    // Mapping to store registered students
    mapping(string => Student) public students;

     // Array to track all student IDs for iteration
    string[] public studentIds;

    // Event to notify registration of a student
    event StudentRegistered(string studentId, string fullName, address walletAddress);

    // Function to register a student
    function registerStudent(string memory studentId, string memory fullName, address walletAddress) public {
        require(students[studentId].walletAddress == address(0), "Student already registered");

        students[studentId] = Student({
            studentId: studentId,
            fullName: fullName,
            walletAddress: walletAddress
        });

            // Track the student ID in the array
        studentIds.push(studentId);

        emit StudentRegistered(studentId, fullName, walletAddress);
    }


    // Function to return all students
    function getStudents() public view returns (Student[] memory) {
        Student[] memory allStudents = new Student[](studentIds.length);

        for (uint256 i = 0; i < studentIds.length; i++) {
            allStudents[i] = students[studentIds[i]];
        }

        return allStudents;
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
