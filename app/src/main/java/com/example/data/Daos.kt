package com.example.data

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Update
import kotlinx.coroutines.flow.Flow

@Dao
interface ShopDao {
    @Query("SELECT * FROM shop_profile WHERE id = 1")
    fun getShopProfile(): Flow<ShopProfile?>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdateShop(shop: ShopProfile)
}

@Dao
interface CustomerDao {
    @Query("SELECT * FROM customers ORDER BY name ASC")
    fun getAllCustomers(): Flow<List<Customer>>

    @Query("SELECT * FROM customers WHERE id = :id")
    fun getCustomerById(id: Int): Flow<Customer?>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertCustomer(customer: Customer): Long

    @Update
    suspend fun updateCustomer(customer: Customer)

    @Delete
    suspend fun deleteCustomer(customer: Customer)
}

@Dao
interface LedgerDao {
    @Query("SELECT * FROM ledger_transactions ORDER BY dateMillis DESC")
    fun getAllTransactions(): Flow<List<LedgerTransaction>>

    @Query("SELECT * FROM ledger_transactions WHERE customerId = :customerId ORDER BY dateMillis DESC")
    fun getTransactionsForCustomer(customerId: Int): Flow<List<LedgerTransaction>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertTransaction(transaction: LedgerTransaction): Long

    @Delete
    suspend fun deleteTransaction(transaction: LedgerTransaction)
}

@Dao
interface OrderDao {
    @Query("SELECT * FROM customer_orders ORDER BY dateMillis DESC")
    fun getAllOrders(): Flow<List<CustomerOrder>>

    @Query("SELECT * FROM customer_orders WHERE customerId = :customerId ORDER BY dateMillis DESC")
    fun getOrdersForCustomer(customerId: Int): Flow<List<CustomerOrder>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrder(order: CustomerOrder): Long

    @Update
    suspend fun updateOrder(order: CustomerOrder)
}

@Dao
interface ChatDao {
    @Query("SELECT * FROM chat_messages WHERE customerId = :customerId ORDER BY timestampMillis ASC")
    fun getChatForCustomer(customerId: Int): Flow<List<ChatMessage>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertChatMessage(message: ChatMessage): Long
}
