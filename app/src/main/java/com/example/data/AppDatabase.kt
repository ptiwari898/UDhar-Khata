package com.example.data

import android.content.Context
import androidx.room.Database
import androidx.room.migration.Migration
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.sqlite.db.SupportSQLiteDatabase

@Database(
    entities = [
        ShopProfile::class,
        Customer::class,
        LedgerTransaction::class,
        CustomerOrder::class,
        ChatMessage::class
    ],
    version = 2,
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
                    .addMigrations(MIGRATION_1_2)
                    .build()
                INSTANCE = instance
                instance
            }
        }

        private val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL("ALTER TABLE shop_profile ADD COLUMN email TEXT NOT NULL DEFAULT ''")
                db.execSQL("ALTER TABLE shop_profile ADD COLUMN photoUri TEXT NOT NULL DEFAULT ''")
                db.execSQL("DELETE FROM ledger_transactions WHERE customerId IN (SELECT id FROM customers WHERE phone IN ('98765 11111', '98765 22222', '98765 33333', '98765 44444', '98765 55555', '98765 66666'))")
                db.execSQL("DELETE FROM customer_orders WHERE customerId IN (SELECT id FROM customers WHERE phone IN ('98765 11111', '98765 22222', '98765 33333', '98765 44444', '98765 55555', '98765 66666'))")
                db.execSQL("DELETE FROM chat_messages WHERE customerId IN (SELECT id FROM customers WHERE phone IN ('98765 11111', '98765 22222', '98765 33333', '98765 44444', '98765 55555', '98765 66666'))")
                db.execSQL("DELETE FROM customers WHERE phone IN ('98765 11111', '98765 22222', '98765 33333', '98765 33333', '98765 44444', '98765 55555', '98765 66666'))")
                db.execSQL("DELETE FROM shop_profile WHERE shopName = 'Shivam Kirana Store' AND phone = '+91 98765 43210'")
            }
        }
    }
}
