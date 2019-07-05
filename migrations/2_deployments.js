
const PublicEntry = artifacts.require('PublicEntry')
const CommonDB = artifacts.require('CommonDB')
const FundsDB = artifacts.require('FundsDB')
const TicketDB = artifacts.require('TicketDB')
const SwopManager = artifacts.require('SwopManager')
const Funds = artifacts.require('Funds')

module.exports = async function(deployer) {
  await deployer.deploy(PublicEntry)
  await deployer.deploy(CommonDB)
  await deployer.deploy(FundsDB, CommonDB.address)
  await deployer.deploy(TicketDB, CommonDB.address)
  await deployer.deploy(Funds)
  await deployer.deploy(SwopManager)

  this.entry = await PublicEntry.deployed()
  this.commonDB = await CommonDB.deployed()
  this.fundsDB = await FundsDB.deployed()
  this.funds = await Funds.deployed()
  this.ticketDB = await TicketDB.deployed()
  this.swopManager = await SwopManager.deployed()

  await this.entry.addContract('CommonDB', this.commonDB.address)
  await this.entry.addContract('FundsDB', this.fundsDB.address)
  await this.entry.addContract('TicketDB', this.ticketDB.address)
  await this.entry.addContract('Funds', this.funds.address)
  await this.entry.addContract('SwopManager', this.swopManager.address)

  await this.commonDB.setContainerEntry(this.entry.address)
  await this.fundsDB.setContainerEntry(this.entry.address)
  await this.ticketDB.setContainerEntry(this.entry.address)
  await this.funds.setContainerEntry(this.entry.address)
  await this.swopManager.setContainerEntry(this.entry.address)

  await this.funds.init()
  await this.swopManager.init()
  await this.swopManager.setReceiverAddress('0x0fBCE7Da7F6247b01DCF5ba5f7e61c2504E081C5')
};
