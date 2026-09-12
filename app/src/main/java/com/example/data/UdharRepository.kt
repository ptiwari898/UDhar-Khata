package com.example.data

import com.example.service.FirestoreLedgerService
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first

fun buildOverallShopSummary(
    customers: List<Customer>,
    transactions: List<LedgerTransaction>,
    orders: List<CustomerOrder>
): OverallShopSummary {
    val customerSummaries = customers.map { customer ->
        val custTxns = transactions.filter { it.customerId == customer.id }
        val udhar = custTxns.filter { it.type == "UDHAAR" }.sumOf { it.amount }
        val repaid = custTxns.filter { it.type == "PAYMENT" }.sumOf { it.amount }
        val advance = custTxns.filter { it.type == "ADVANCE" }.sumOf { it.amount }
        val refund = custTxns.filter { it.type == "REFUND" }.sumOf { it.amount }

        val netOutstanding = maxOf(0.0, udhar - repaid)
        // Advance balance includes both explicit ADVANCE transactions AND overpayments
        val overpayment = maxOf(0.0, repaid - udhar)
        val netAdvance = (advance - refund) + overpayment
        val lastDate = custTxns.maxOfOrNull { it.dateMillis } ?: System.currentTimeMillis()

        CustomerFinancialSummary(
            customer = customer,
            totalLoaned = udhar,
            totalRepaid = repaid,
            totalAdvance = advance - refund,
            currentOutstanding = netOutstanding,
            advanceBalance = netAdvance,
            lastTransactionDateMillis = lastDate
        )
    }

    val totalLoaned = customerSummaries.sumOf { it.totalLoaned }
    val totalRepaid = customerSummaries.sumOf { it.totalRepaid }
    val totalAdvanceBalance = customerSummaries.sumOf { it.advanceBalance }
    val grandOutstanding = customerSummaries.sumOf { it.currentOutstanding }

    val customerBreakdownWithShare = customerSummaries.map { custSummary ->
        val percentage = if (grandOutstanding > 0) (custSummary.currentOutstanding / grandOutstanding) * 100.0 else 0.0
        custSummary.copy(percentageShare = percentage)
    }.sortedByDescending { it.currentOutstanding }

    val thisMonthStart = java.util.Calendar.getInstance().apply {
        set(java.util.Calendar.DAY_OF_MONTH, 1)
        set(java.util.Calendar.HOUR_OF_DAY, 0)
        set(java.util.Calendar.MINUTE, 0)
        set(java.util.Calendar.SECOND, 0)
        set(java.util.Calendar.MILLISECOND, 0)
    }.timeInMillis

    val thisMonthTxns = transactions.filter { it.dateMillis >= thisMonthStart }
    val thisMonthUdharGiven = thisMonthTxns.filter { it.type == "UDHAAR" }.sumOf { it.amount }
    val thisMonthCollection = thisMonthTxns.filter { it.type == "PAYMENT" }.sumOf { it.amount }
    val thisMonthAdvanceReceived = thisMonthTxns.filter { it.type == "ADVANCE" }.sumOf { it.amount }

    return OverallShopSummary(
        currentOutstandingUdhar = grandOutstanding,
        totalLoanedTillDate = totalLoaned,
        totalRepaid = totalRepaid,
        advanceBalance = totalAdvanceBalance,
        activeCustomersCount = customers.size,
        customerBreakdown = customerBreakdownWithShare,
        thisMonthUdharGiven = thisMonthUdharGiven,
        thisMonthCollection = thisMonthCollection,
        thisMonthAdvanceReceived = thisMonthAdvanceReceived,
        thisMonthOrdersCount = orders.size
    )
}

data class CustomerFinancialSummary(
    val customer: Customer,
    val totalLoaned: Double,
    val totalRepaid: Double,
    val totalAdvance: Double,
    val currentOutstanding: Double,
    val advanceBalance: Double,
    val percentageShare: Double = 0.0,
    val lastTransactionDateMillis: Long = System.currentTimeMillis()
)

data class OverallShopSummary(
    val currentOutstandingUdhar: Double,
    val totalLoanedTillDate: Double,
    val totalRepaid: Double,
    val advanceBalance: Double,
    val activeCustomersCount: Int,
    val customerBreakdown: List<CustomerFinancialSummary>,
    val thisMonthUdharGiven: Double,
    val thisMonthCollection: Double,
    val thisMonthAdvanceReceived: Double,
    val thisMonthOrdersCount: Int
)

class UdharRepository(
    private val shopDao: ShopDao,
    private val customerDao: CustomerDao,
    private val ledgerDao: LedgerDao,
    private val orderDao: OrderDao,
    private val chatDao: ChatDao,
    private val firestoreLedgerService: FirestoreLedgerService = FirestoreLedgerService()
) {
    val shopProfile: Flow<ShopProfile?> = shopDao.getShopProfile()
    val allCustomers: Flow<List<Customer>> = customerDao.getAllCustomers()
    val allTransactions: Flow<List<LedgerTransaction>> = ledgerDao.getAllTransactions()
    val allOrders: Flow<List<CustomerOrder>> = orderDao.getAllOrders()

    fun getTransactionsForCustomer(customerId: Int): Flow<List<LedgerTransaction>> {
        return ledgerDao.getTransactionsForCustomer(customerId)
    }

    fun getOrdersForCustomer(customerId: Int): Flow<List<CustomerOrder>> {
        return orderDao.getOrdersForCustomer(customerId)
    }

    fun getChatForCustomer(customerId: Int): Flow<List<ChatMessage>> {
        return chatDao.getChatForCustomer(customerId)
    }

    val shopSummary: Flow<OverallShopSummary> = combine(
        customerDao.getAllCustomers(),
        ledgerDao.getAllTransactions(),
        orderDao.getAllOrders()
    ) { customers, transactions, orders ->
        buildOverallShopSummary(customers, transactions, orders)
    }

    suspend fun addCustomer(customer: Customer): Long {
        return customerDao.insertCustomer(customer)
    }

    suspend fun deleteCustomer(customer: Customer) {
        customerDao.deleteCustomer(customer)
    }

    suspend fun addTransaction(transaction: LedgerTransaction, userId: String? = null): Long {
        if (transaction.customerId <= 0) return 0L

        val customerExists = customerDao.getCustomerById(transaction.customerId).first() != null
        if (!customerExists) {
            return 0L
        }

        val insertedId = ledgerDao.insertTransaction(transaction)
        if (!userId.isNullOrEmpty()) {
            val updatedTx = if (transaction.id <= 0) transaction.copy(id = insertedId.toInt()) else transaction
            firestoreLedgerService.saveTransaction(userId, updatedTx)
        }
        return insertedId
    }

    suspend fun syncFirestoreEntries(userId: String) {
        if (userId.isBlank()) return
        val remoteEntries = firestoreLedgerService.fetchTransactions(userId)
        remoteEntries.forEach { entry ->
            ledgerDao.insertTransaction(entry)
        }
    }

    suspend fun addOrder(order: CustomerOrder): Long {
        return orderDao.insertOrder(order)
    }

    suspend fun addChatMessage(message: ChatMessage): Long {
        return chatDao.insertChatMessage(message)
    }

    suspend fun updateShopProfile(profile: ShopProfile) {
        shopDao.insertOrUpdateShop(profile)
    }
}
