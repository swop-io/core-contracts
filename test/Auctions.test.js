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

    let swopRefNo = ethers.utils.formatBytes32String('SWP123')
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
            // ganache-cli -d
            let bidder1PK = '0x646f1ce2fdad0e6deeeb5c7e8e5543bdde65e86029e2fd9fc169899c440a7913'
            let bidder2PK = '0xadd53f9a7e588d003326d1cbf9e4a43c061aadd9bc938c843a79e7b4fd2ad743'

            let bidder1Wallet = new ethers.Wallet(bidder1PK)
            let bidder2Wallet = new ethers.Wallet(bidder2PK)

            // BID #1
            let amountWei = ethers.utils.parseEther('1.0')
            let nonce = 0
            let message = ethers.utils.concat([
                            ethers.utils.hexZeroPad(swopRefNo, 32),
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(amountWei), 32),
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(nonce), 8)
            ])
    
            let messageHash = ethers.utils.keccak256(message)
            let sig1 = await bidder1Wallet.signMessage(ethers.utils.arrayify(messageHash));
        

            // BID #2
            amountWei = ethers.utils.parseEther('2.0')
            nonce = 1
            let bytesNonce = ethers.utils.formatBytes32String(nonce + ':nonce');

            message = ethers.utils.concat([
                            ethers.utils.hexZeroPad(swopRefNo, 32),
                            ethers.utils.hexZeroPad(ethers.utils.hexlify(amountWei), 32),
                            ethers.utils.hexZeroPad(bytesNonce, 32)
                           
            ])
    
            messageHash = ethers.utils.keccak256(message)

            let sig2 = await bidder2Wallet.signMessage(ethers.utils.arrayify(messageHash))
             
            let splitTopBid = ethers.utils.splitSignature(sig2)

            // CLOSE AUCTION
            await this.entry.close(swopRefNo, 
                                    amountWei,
                                    bytesNonce, 
                                    splitTopBid.r, 
                                    splitTopBid.s, 
                                    splitTopBid.v)
                                    .should.be.fulfilled
            
            let topBidder = await this.auctionsDB.getTopBidder(swopRefNo)
            topBidder.should.be.equal(bidder2)
        })

        it('should be able to refund funds', async () => {

        })


    })
})