package com.example

import com.example.data.Customer
import com.example.data.CustomerOrder
import com.example.data.LedgerTransaction
import com.example.data.buildOverallShopSummary
import org.junit.Assert.assertEquals
import org.junit.Test

class ShopSummaryLogicTest {
    @Test
    fun buildOverallShopSummary_usesRealCustomerAndTransactionData() {
        val customers = listOf(
            Customer(id = 1, name = "A", phone = "1", location = "X"),
            Customer(id = 2, name = "B", phone = "2", location = "Y")
        )

        val transactions = listOf(
            LedgerTransaction(id = 1, customerId = 1, type = "UDHAAR", amount = 1000.0),
            LedgerTransaction(id = 2, customerId = 1, type = "PAYMENT", amount = 250.0),
            LedgerTransaction(id = 3, customerId = 2, type = "UDHAAR", amount = 500.0),
            LedgerTransaction(id = 4, customerId = 2, type = "ADVANCE", amount = 100.0),
            LedgerTransaction(id = 5, customerId = 2, type = "REFUND", amount = 40.0)
        )

        val orders = listOf(
            CustomerOrder(id = 1, customerId = 1, itemsSummary = "Rice", totalAmount = 400.0),
            CustomerOrder(id = 2, customerId = 2, itemsSummary = "Flour", totalAmount = 600.0)
        )

        val summary = buildOverallShopSummary(customers, transactions, orders)

        assertEquals(1250.0, summary.currentOutstandingUdhar, 0.01)
        assertEquals(1500.0, summary.totalLoanedTillDate, 0.01)
        assertEquals(250.0, summary.totalRepaid, 0.01)
        assertEquals(60.0, summary.advanceBalance, 0.01)
        assertEquals(2, summary.activeCustomersCount)
        assertEquals(2, summary.thisMonthOrdersCount)
    }

    @Test
    fun buildOverallShopSummary_includesOverpaymentAsAdvanceBalance() {
        val customers = listOf(
            Customer(id = 1, name = "Customer", phone = "1", location = "X")
        )

        val transactions = listOf(
            LedgerTransaction(id = 1, customerId = 1, type = "UDHAAR", amount = 10100.0),
            LedgerTransaction(id = 2, customerId = 1, type = "PAYMENT", amount = 50050.0)
        )

        val orders = emptyList<CustomerOrder>()

        val summary = buildOverallShopSummary(customers, transactions, orders)

        // Customer paid 50050 but only owed 10100
        // Outstanding = 0 (fully paid)
        // Advance balance = 50050 - 10100 = 39950 (overpayment as credit)
        assertEquals(0.0, summary.currentOutstandingUdhar, 0.01)
        assertEquals(10100.0, summary.totalLoanedTillDate, 0.01)
        assertEquals(50050.0, summary.totalRepaid, 0.01)
        assertEquals(39950.0, summary.advanceBalance, 0.01)
    }
}
