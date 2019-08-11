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
            let bidder1PK = '0x646f1ce2fdad0e6deeeb5c7e8e5543bdde65e86029e2fd9fc169899c440a7913'
            let bidder2PK = '0xadd53f9a7e588d003326d1cbf9e4a43c061aadd9bc938c843a79e7b4fd2ad743'

            let bidder1Wallet = new ethers.Wallet(bidder1PK)
            let bidder2Wallet = new ethers.Wallet(bidder2PK)

            let bids = []

            // BID #1
            let amountWei = ethers.utils.parseEther('1.0')
            let swopRefNo = ethers.utils.formatBytes32String('SWP123');
            let nonce = 0
            let message = ethers.utils.concat([
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(nonce), 8),
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(amountWei), 32),
                            ethers.utils.hexZeroPad(swopRefNo, 32)
            ])
    
            let messageHash = ethers.utils.keccak256(message)
            let sig1 = await bidder1Wallet.signMessage(ethers.utils.arrayify(messageHash));
            bids.push(sig1)


            // BID #2
            let amountWei = ethers.utils.parseEther('2.0')
            let swopRefNo = ethers.utils.formatBytes32String('SWP123');
            let nonce = 1
            let message = ethers.utils.concat([
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(nonce), 8),
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(amountWei), 32),
                            ethers.utils.hexZeroPad(swopRefNo, 32)
            ])
    
            let messageHash = ethers.utils.keccak256(message)
            let sig2 = await bidder2Wallet.signMessage(ethers.utils.arrayify(messageHash));
            bids.push(sig2)
            // let splitSig = ethers.utils.splitSignature(sig);

            console.log(bids)
        })

        it('should be able to refund funds', async () => {

        })


    })
})