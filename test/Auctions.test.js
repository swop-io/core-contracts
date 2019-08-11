const BigNumber = web3.utils.BN
const ethers = require('ethers')
require('chai')
  .use(require('chai-shallow-deep-equal'))
  .use(require('chai-bignumber')(BigNumber))
  .use(require('chai-as-promised'))
  .should();


const PublicEntry = artifacts.require('PublicEntry')
const CommonDB = artifacts.require('CommonDB')
const AuctionsDB = artifacts.require('AuctionsDB')
const TicketDB = artifacts.require('TicketDB')
const Auctions = artifacts.require('Auctions')
const AuctionsEscrow = artifacts.require('AuctionsEscrow')

contract('Auctions', ([ owner, seller1, seller2, bidder1, bidder2, airlineReceiver ]) => {
    beforeEach(async () => {
        this.entry = await PublicEntry.new()
        this.commonDB = await CommonDB.new()
        this.ticketDB = await TicketDB.new(this.commonDB.address)
        this.auctionsDB = await AuctionsDB.new(this.commonDB.address)
        this.auctions = await Auctions.new()
        this.escrow = await AuctionsEscrow.new()

        await this.entry.addContract('CommonDB', this.commonDB.address)
        await this.entry.addContract('AuctionsDB', this.auctionsDB.address)
        await this.entry.addContract('TicketDB', this.ticketDB.address)
        await this.entry.addContract('Auctions', this.auctions.address)
        await this.entry.addContract('AuctionsEscrow', this.escrow.address)
        
        await this.commonDB.setContainerEntry(this.entry.address)
        await this.ticketDB.setContainerEntry(this.entry.address)
        await this.auctionsDB.setContainerEntry(this.entry.address)
        await this.auctions.setContainerEntry(this.entry.address)
        await this.escrow.setContainerEntry(this.entry.address)
        await this.auctions.init()

    })

    let swopRefNo = 'SWP123'
    let depositAmount = 1000

    describe('Features', () => {

        it('should be able to make a deposit', async () => {
            
            await this.entry.deposit(swopRefNo, { from : bidder1, value : depositAmount }).should.be.fulfilled
            await this.entry.deposit(swopRefNo, { from : bidder2, value : depositAmount }).should.be.fulfilled

            let isBidder = await this.auctionsDB.isBidder(swopRefNo, bidder1)
            isBidder.should.be.true

            let depositedAmount = await this.auctionsDB.getDepositedAmount(swopRefNo, bidder1)
            depositAmount.should.be.equal(depositedAmount.toNumber())

            let escrowAmount = await this.escrow.depositsOf(bidder1)
            depositAmount.should.be.equal(escrowAmount.toNumber())

            let escrowBalance = await web3.eth.getBalance(this.escrow.address)
            escrowBalance.should.be.equal((depositAmount * 2).toString())

        })

        it('should be able to place bid and close bidding', async () => {

        })

        it('should be able to refund funds', async () => {

        })


    })
})