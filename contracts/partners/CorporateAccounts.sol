pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./UserRegistration.sol";

contract CorporateAccounts is Ownable {
    // Instance of UserRegistration contract
    UserRegistration private userRegistration;

    // Struct to store corporate account information
    struct CorporateAccount {
        uint256 id;
        string companyName;
        string companyRegistrationNumber;
        address wallet;
        bool active;
    }

    // Array containing all corporate accounts
    CorporateAccount[] private corporateAccounts;

    // Mapping to check if an address belongs to a corporate account
    mapping(address => bool) private isCorporateAccount;

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    /**
     * @dev Create a new corporate account.
     * This function can only be called by the contract owner.
     * @param _companyName The name of the company.
     * @param _companyRegistrationNumber The registration number of the company.
     * @param _wallet The wallet address associated with the corporate account.
     */
    function createCorporateAccount(
        string memory _companyName,
        string memory _companyRegistrationNumber,
        address _wallet
    ) external onlyOwner {
        require(!isCorporateAccount[_wallet], "Wallet already linked to a corporate account");
        require(_wallet != address(0), "Wallet address cannot be zero");

        CorporateAccount memory newAccount = CorporateAccount(corporateAccounts.length, _companyName, _companyRegistrationNumber, _wallet, true);
        corporateAccounts.push(newAccount);
        isCorporateAccount[_wallet] = true;
    }

    /**
     * @dev Set the active status of a corporate account.
     * This function can only be called by the contract owner.
     * @param _accountId The ID of the corporate account.
     * @param _active The new active status of the corporate account.
     */
    function setActiveStatus(uint256 _accountId, bool _active) external onlyOwner {
        require(_accountId < corporateAccounts.length, "Invalid account ID");

        corporateAccounts[_accountId].active = _active;
    }

    /**
     * @dev Get the details of a corporate account.
     * @param _accountId The ID of the corporate account.
     * @return companyName, companyRegistrationNumber, wallet, active
     */
    function getCorporateAccountDetails(uint256 _accountId)
        external
        view
        returns (
            string memory companyName,
            string memory companyRegistrationNumber,
            address wallet,
            bool active
        )
    {
        require(_accountId < corporateAccounts.length, "Invalid account ID");

        CorporateAccount memory account = corporateAccounts[_accountId];
        return (account.companyName, account.companyRegistrationNumber, account.wallet, account.active);
    }

    /**
     * @dev Check if a wallet address belongs to a corporate account.
     * @param _wallet The wallet address to check.
     * @return True if the wallet belongs to a corporate account, false otherwise.
     */
    function isWalletCorporateAccount(address _wallet) external view returns (bool) {
        return isCorporateAccount[_wallet];
    }
}
