package com.example.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@Database(
    entities = [
        ShopProfile::class,
        Customer::class,
        LedgerTransaction::class,
        CustomerOrder::class,
        ChatMessage::class
    ],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase() {
    abstract fun shopDao(): ShopDao
    abstract fun customerDao(): CustomerDao
    abstract fun ledgerDao(): LedgerDao
    abstract fun orderDao(): OrderDao
    abstract fun chatDao(): ChatDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null

        fun getInstance(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "udhar_khata_db"
                )
                    .addCallback(DatabaseCallback())
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }

    private class DatabaseCallback : RoomDatabase.Callback() {
        override fun onCreate(db: SupportSQLiteDatabase) {
            super.onCreate(db)
            INSTANCE?.let { database ->
                CoroutineScope(Dispatchers.IO).launch {
                    populateInitialData(database)
                }
            }
        }
    }
}

private suspend fun populateInitialData(db: AppDatabase) {
    // 1. Seed Shop Profile
    db.shopDao().insertOrUpdateShop(
        ShopProfile(
            id = 1,
            shopName = "Shivam Kirana Store",
            ownerName = "Pawan Tiwari",
            phone = "+91 98765 43210",
            location = "Bhopal, Madhya Pradesh",
            memberSince = "12 Mar 2024"
        )
    )

    // 2. Seed Customers
    val c1Id = db.customerDao().insertCustomer(
        Customer(name = "Rahul Sharma", phone = "98765 11111", location = "Bhopal, MP", riskLevel = "High", notes = "Regular grocery buyer")
    ).toInt()

    val c2Id = db.customerDao().insertCustomer(
        Customer(name = "Amit Verma", phone = "98765 22222", location = "Bhopal, MP", riskLevel = "High", notes = "Monthly billing customer")
    ).toInt()

    val c3Id = db.customerDao().insertCustomer(
        Customer(name = "Ramesh Kumar", phone = "98765 33333", location = "Bhopal, MP", riskLevel = "Medium", notes = "")
    ).toInt()

    val c4Id = db.customerDao().insertCustomer(
        Customer(name = "Suresh Patel", phone = "98765 44444", location = "Bhopal, MP", riskLevel = "Medium", notes = "")
    ).toInt()

    val c5Id = db.customerDao().insertCustomer(
        Customer(name = "Neha Singh", phone = "98765 55555", location = "Bhopal, MP", riskLevel = "Low", notes = "")
    ).toInt()

    val c6Id = db.customerDao().insertCustomer(
        Customer(name = "Vikas Yadav", phone = "98765 66666", location = "Bhopal, MP", riskLevel = "Low", notes = "")
    ).toInt()

    // Base Timestamps (08 Aug 2026, 07 Aug 2026, 05 Aug 2026, 04 Aug 2026)
    val day8Aug = 1786185600000L // 08 Aug 2026
    val day7Aug = 1786099200000L // 07 Aug 2026
    val day5Aug = 1785926400000L // 05 Aug 2026
    val day4Aug = 1785840000000L // 04 Aug 2026

    // 3. Seed Ledger Transactions for Rahul Sharma (Total Loaned 18,300, Total Repaid 12,500, Current Outstanding 5,800, Advance 500)
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "UDHAAR", amount = 12500.0, note = "Previous Udhar Balance", dateMillis = day4Aug - 86400000L))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "ADVANCE", amount = 10000.0, note = "Advance Payment", paymentMethod = "UPI", dateMillis = day5Aug))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "REFUND", amount = 500.0, note = "Advance Refund", dateMillis = day4Aug))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "UDHAAR", amount = 4100.0, note = "Oil, Sugar, Tea", dateMillis = day7Aug))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "PAYMENT", amount = 700.0, note = "UPI Payment", paymentMethod = "UPI", dateMillis = day7Aug))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "UDHAAR", amount = 1700.0, note = "Grocery Items", dateMillis = day8Aug))
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c1Id, type = "PAYMENT", amount = 11800.0, note = "Cash Payment", paymentMethod = "Cash", dateMillis = day8Aug))

    // Seed Amit Verma (4,200)
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c2Id, type = "UDHAAR", amount = 4200.0, note = "Monthly Provisions", dateMillis = day8Aug))

    // Seed Ramesh Kumar (2,500)
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c3Id, type = "UDHAAR", amount = 2500.0, note = "Grains & Spices", dateMillis = day7Aug))

    // Seed Suresh Patel (1,500)
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c4Id, type = "UDHAAR", amount = 1500.0, note = "Dairy & Snacks", dateMillis = day7Aug))

    // Seed Neha Singh (1,000)
    db.ledgerDao().insertTransaction(LedgerTransaction(customerId = c5Id, type = "UDHAAR", amount = 1000.0, note = "Household Items", dateMillis = day5Aug))

    // 4. Seed Customer Orders
    db.orderDao().insertOrder(
        CustomerOrder(
            customerId = c1Id,
            itemsSummary = "Atta 5kg, Rice 2kg, Oil 1L, Sugar 2kg",
            totalAmount = 680.0,
            advancePaid = 200.0,
            status = "DELIVERED",
            dateMillis = day8Aug
        )
    )

    // 5. Seed Customer Chat
    db.chatDao().insertChatMessage(ChatMessage(customerId = c1Id, sender = "CUSTOMER", message = "Bhaiya 5kg atta aur 1L oil ready rakhna", messageType = "TEXT", timestampMillis = day8Aug - 3600000L))
    db.chatDao().insertChatMessage(ChatMessage(customerId = c1Id, sender = "SHOP", message = "Ha Rahul, ready ho gaya hai.", messageType = "TEXT", timestampMillis = day8Aug - 1800000L))
    db.chatDao().insertChatMessage(ChatMessage(customerId = c1Id, sender = "SHOP", message = "Bill: ₹680. Current Udhar: ₹5,800", messageType = "BILL", timestampMillis = day8Aug))
}
