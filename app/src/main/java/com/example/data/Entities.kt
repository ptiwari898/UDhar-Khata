package com.example.data

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey

@Entity(tableName = "shop_profile")
data class ShopProfile(
    @PrimaryKey val id: Int = 1,
    val shopName: String,
    val ownerName: String,
    val phone: String,
    val location: String = "Bhopal, MP",
    val memberSince: String = "2023",
    val address: String = "Shop No. 12, Main Market, Bhopal, MP",
    val upiId: String = "shivamkirana@upi",
    val gstin: String = "23AAAAA0000A1Z5",
    val email: String = "",
    val photoUri: String = ""
)

@Entity(tableName = "customers")
data class Customer(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val name: String,
    val phone: String,
    val location: String,
    val riskLevel: String = "Low", // High, Medium, Low
    val notes: String = ""
)

@Entity(
    tableName = "ledger_transactions",
    foreignKeys = [
        ForeignKey(
            entity = Customer::class,
            parentColumns = ["id"],
            childColumns = ["customerId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("customerId")]
)
data class LedgerTransaction(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val customerId: Int,
    val type: String, // UDHAAR, PAYMENT, ADVANCE, REFUND
    val amount: Double,
    val note: String = "",
    val dateMillis: Long = System.currentTimeMillis(),
    val paymentMethod: String = "Cash", // Cash, UPI, Bank Transfer
    val reference: String = "",
    val photoUri: String = "",
    val orderId: Int? = null
)

@Entity(
    tableName = "customer_orders",
    foreignKeys = [
        ForeignKey(
            entity = Customer::class,
            parentColumns = ["id"],
            childColumns = ["customerId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("customerId")]
)
data class CustomerOrder(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val customerId: Int,
    val itemsSummary: String, // e.g. "Atta 5kg, Rice 2kg, Oil 1L, Sugar 2kg"
    val totalAmount: Double,
    val advancePaid: Double = 0.0,
    val status: String = "CONFIRMED", // DRAFT, CONFIRMED, READY, DELIVERED, COMPLETED
    val dateMillis: Long = System.currentTimeMillis()
)

@Entity(
    tableName = "chat_messages",
    foreignKeys = [
        ForeignKey(
            entity = Customer::class,
            parentColumns = ["id"],
            childColumns = ["customerId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("customerId")]
)
data class ChatMessage(
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
    val customerId: Int,
    val sender: String, // SHOP, CUSTOMER
    val message: String,
    val messageType: String = "TEXT", // TEXT, IMAGE, BILL, VOICE, PAYMENT_PROOF
    val attachmentUrl: String = "",
    val timestampMillis: Long = System.currentTimeMillis()
)
