// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract FeeManagement is AccessControl {
    bytes32 public constant ACCOUNTANT_ROLE = keccak256("ACCOUNTANT_ROLE");

    struct User {
        string fullName;
        string role; // "Student" or "Accountant"
    }

    struct FeeRecord {
        string faculty;
        string semester;
        uint256 feeAmount;
        uint256 generatedAt;
    }

    struct Receipt {
        string studentId;
        string faculty;
        string semester;
        uint256 feeAmount;
        uint256 timestamp;
    }

    // Mappings
    mapping(address => User) public users; // Registered users
    mapping(string => FeeRecord) public fees; // Fee data by faculty & semester
    Receipt[] public receipts; // Array of generated receipts

    // Events
    event UserRegistered(address userAddress, string fullName, string role);
    event FeeEntered(string faculty, string semester, uint256 feeAmount);
    event ReceiptGenerated(string studentId, string faculty, string semester, uint256 feeAmount, uint256 timestamp);

    // Constructor: Assigns deployer as Admin
    constructor() {
_grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Modifier: Ensures the user is a Student
    modifier onlyStudent() {
        require(keccak256(abi.encodePacked(users[msg.sender].role)) == keccak256(abi.encodePacked("Student")), "Not a Student");
        _;
    }

    // Register User (Admin only)
    function registerUser(address userAddress, string memory fullName, string memory role) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(bytes(users[userAddress].fullName).length == 0, "User already registered");
        users[userAddress] = User(fullName, role);

        // Assign ACCOUNTANT_ROLE if role is Accountant
        if (keccak256(abi.encodePacked(role)) == keccak256(abi.encodePacked("Accountant"))) {
            _grantRole(ACCOUNTANT_ROLE, userAddress);
        }

        emit UserRegistered(userAddress, fullName, role);
    }

    // Accountant enters fee details
    function enterFee(string memory faculty, string memory semester, uint256 feeAmount) public onlyRole(ACCOUNTANT_ROLE) {
        fees[string(abi.encodePacked(faculty, semester))] = FeeRecord(faculty, semester, feeAmount, block.timestamp);
        emit FeeEntered(faculty, semester, feeAmount);
    }

    // Generate a receipt for a student (simulated period for testing)
    function generateReceipt(string memory studentId, string memory faculty, string memory semester) public onlyRole(ACCOUNTANT_ROLE) {
        string memory feeKey = string(abi.encodePacked(faculty, semester));
        require(fees[feeKey].feeAmount > 0, "Fee not entered for faculty and semester");

        receipts.push(Receipt({
            studentId: studentId,
            faculty: faculty,
            semester: semester,
            feeAmount: fees[feeKey].feeAmount,
            timestamp: block.timestamp
        }));

        emit ReceiptGenerated(studentId, faculty, semester, fees[feeKey].feeAmount, block.timestamp);
    }

    // Get all receipts
    function getAllReceipts() public view returns (Receipt[] memory) {
        return receipts;
    }

    // Simulate clearing receipts after the test period (e.g., every day/hour/minute)
    function clearReceipts() public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete receipts;
    }
}
