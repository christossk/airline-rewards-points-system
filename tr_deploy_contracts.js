const UserRegistration = artifacts.require("UserRegistration");
const UserPreferences = artifacts.require("UserPreferences");
const AccountRecovery = artifacts.require("AccountRecovery");
const PointsManagement = artifacts.require("PointsManagement");
const PointsRedemption = artifacts.require("PointsRedemption");
const PointsConversion = artifacts.require("PointsConversion");
const PointsMarketplace = artifacts.require("PointsMarketplace");
const TierManagement = artifacts.require("TierManagement");
const TierBenefits = artifacts.require("TierBenefits");
const ReferralBonus = artifacts.require("ReferralBonus");
const PromotionsManagement = artifacts.require("PromotionsManagement");
const PartnerIntegration = artifacts.require("PartnerIntegration");
const CustomerSupport = artifacts.require("CustomerSupport");
const Leaderboard = artifacts.require("Leaderboard");
const PointsHistory = artifacts.require("PointsHistory");
const TierExpiry = artifacts.require("TierExpiry");
const Challenges = artifacts.require("Challenges");
const CorporateAccounts = artifacts.require("CorporateAccounts");
const FraudDetection = artifacts.require("FraudDetection");
const Notifications = artifacts.require("Notifications");

module.exports = async function (deployer, network, accounts) {
  // Deploy UserRegistration contract
  await deployer.deploy(UserRegistration);
  const userRegistration = await UserRegistration.deployed();

  // Deploy UserPreferences contract
  await deployer.deploy(UserPreferences, userRegistration.address);
  const userPreferences = await UserPreferences.deployed();

  // Deploy AccountRecovery contract
  await deployer.deploy(AccountRecovery, userRegistration.address);
  const accountRecovery = await AccountRecovery.deployed();

  // Deploy PointsManagement contract
  await deployer.deploy(PointsManagement, userRegistration.address);
  const pointsManagement = await PointsManagement.deployed();

  // Deploy PointsRedemption contract
  await deployer.deploy(PointsRedemption, userRegistration.address, pointsManagement.address);
  const pointsRedemption = await PointsRedemption.deployed();

  // Deploy PointsConversion contract
  await deployer.deploy(PointsConversion, userRegistration.address, pointsManagement.address);
  const pointsConversion = await PointsConversion.deployed();

  // Deploy PointsMarketplace contract
  await deployer.deploy(PointsMarketplace, userRegistration.address, pointsManagement.address);
  const pointsMarketplace = await PointsMarketplace.deployed();

  // Deploy TierManagement contract
  await deployer.deploy(TierManagement, userRegistration.address);
  const tierManagement = await TierManagement.deployed();

  // Deploy TierBenefits contract
  await deployer.deploy(TierBenefits, userRegistration.address, tierManagement.address);
  const tierBenefits = await TierBenefits.deployed();

  // Deploy ReferralBonus contract
  await deployer.deploy(ReferralBonus, userRegistration.address, pointsManagement.address);
  const referralBonus = await ReferralBonus.deployed();

  // Deploy PromotionsManagement contract
  await deployer.deploy(PromotionsManagement, userRegistration.address, pointsManagement.address);
  const promotionsManagement = await PromotionsManagement.deployed();

  // Deploy PartnerIntegration contract
  await deployer.deploy(PartnerIntegration, userRegistration.address, pointsManagement.address);
  const partnerIntegration = await PartnerIntegration.deployed();

  // Deploy CustomerSupport contract
  await deployer.deploy(CustomerSupport, userRegistration.address);
  const customerSupport = await CustomerSupport.deployed();

  // Deploy Leaderboard contract
  await deployer.deploy(Leaderboard, userRegistration.address, pointsManagement.address);
  const leaderboard = await Leaderboard.deployed();

  // Deploy PointsHistory contract
  await deployer.deploy(PointsHistory, userRegistration.address, pointsManagement.address);
  const pointsHistory = await PointsHistory.deployed();

  // Deploy TierExpiry contract
  await deployer.deploy(TierExpiry, userRegistration.address, tierManagement.address);
  const tierExpiry = await TierExpiry.deployed();

  // Deploy Challenges contract
  await deployer.deploy(Challenges, userRegistration.address, pointsManagement.address);
  const challenges = await Challenges.deployed();

  // Deploy CorporateAccounts contract
  await deployer.deploy(CorporateAccounts, userRegistration.address);
  const corporateAccounts = await CorporateAccounts.deployed();

  // Deploy FraudDetection contract
  await deployer.deploy(FraudDetection, userRegistration.address);
  const fraudDetection = await FraudDetection.deployed();

  // Deploy Notifications contract
  await deployer.deploy(Notifications, userRegistration.address);
  const notifications = await Notifications.deployed();

  // Display the deployed contract addresses
  console.log("UserRegistration address:", userRegistration.address);
  console.log("UserPreferences address:", userPreferences.address);
  console.log("AccountRecovery address:", accountRecovery.address);
  console.log("PointsManagement address:", pointsManagement.address);
  console.log("PointsRedemption address:", pointsRedemption.address);
  console.log("PointsConversion address:", pointsConversion.address);
  console.log("PointsMarketplace address:", pointsMarketplace.address);
  console.log("TierManagement address:", tierManagement.address);
  console.log("TierBenefits address:", tierBenefits.address);
  console.log("ReferralBonus address:", referralBonus.address);
  console.log("PromotionsManagement address:", promotionsManagement.address);
  console.log("PartnerIntegration address:", partnerIntegration.address);
  console.log("CustomerSupport address:", customerSupport.address);
  console.log("Leaderboard address:", leaderboard.address);
  console.log("PointsHistory address:", pointsHistory.address);
  console.log("TierExpiry address:", tierExpiry.address);
  console.log("Challenges address:", challenges.address);
  console.log("CorporateAccounts address:", corporateAccounts.address);
  console.log("FraudDetection address:", fraudDetection.address);
  console.log("Notifications address:", notifications.address);
};