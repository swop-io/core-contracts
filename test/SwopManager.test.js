
const PublicEntry = artifacts.require('PublicEntry')
const CommonDB = artifacts.require('CommonDB')
const FundsDB = artifacts.require('FundsDB')
const TicketDB = artifacts.require('TicketDB')
const SwopManager = artifacts.require('SwopManager')
const Funds = artifacts.require('Funds')

contract('SwopManager', ([ owner, seller1, seller2, buyer1, buyer2, airlineReceiver ]) => {
    beforeEach(async () => {
        this.entry = await PublicEntry.new()
        this.commonDB = await CommonDB.new()
        this.fundsDB = await FundsDB.new(this.commonDB.address)
        this.ticketDB = await TicketDB.new(this.commonDB.address)
        this.funds = await Funds.new()
        this.swopManager = await SwopManager.new()

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
        await this.swopManager.setReceiverAddress(airlineReceiver)
    })

    describe('Authority', () => {

    })

    describe('Features', () => {
        it('should be able to post ticket', async () => {
            await this.entry.postTicket('ref123', 12312312, { from: seller1 })
            let ticketStatus = await this.ticketDB.getTicketStatus('ref123')

            assert.equal(ticketStatus.toNumber(), 1)
        })


        it('should be able to buy ticket', async () => {
            let swopRefNo = 'refNo1'
            let ticketAmount = 981231231

            await this.entry.postTicket(swopRefNo, ticketAmount, { from: seller1 })
            await this.entry.buyTicket(swopRefNo, { from : buyer1, value : ticketAmount })

            let contractBalance = await web3.eth.getBalance(this.funds.address)
            console.log(contractBalance)

            assert.equal(contractBalance, ticketAmount)
        })

        it('should be able to disburse funds', async () => {
            let swopRefNo = 'refNo1'
            let ticketAmount = 981231231

            await this.entry.postTicket(swopRefNo, ticketAmount, { from: seller1 })
            await this.entry.buyTicket(swopRefNo, { from : buyer1, value : ticketAmount })

            let sellerBalance = await web3.eth.getBalance(seller1)
            console.log(sellerBalance)
            await this.entry.completeTransaction(swopRefNo)

            let newBalance = await web3.eth.getBalance(seller1)
            console.log(newBalance)

            // assert.isAbove(sellerBalance, newBalance)
        })
    })
})