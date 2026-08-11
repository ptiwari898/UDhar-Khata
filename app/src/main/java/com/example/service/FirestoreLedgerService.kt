package com.example.service

import android.util.Log
import com.example.data.LedgerTransaction
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext

class FirestoreLedgerService {

    private val firestore: FirebaseFirestore? by lazy {
        try {
            FirebaseFirestore.getInstance()
        } catch (e: Exception) {
            Log.e("FirestoreLedgerService", "Firestore initialization exception: ${e.message}")
            null
        }
    }

    suspend fun saveTransaction(userId: String, transaction: LedgerTransaction) = withContext(Dispatchers.IO) {
        try {
            val db = firestore ?: return@withContext
            val docData = hashMapOf(
                "id" to transaction.id,
                "customerId" to transaction.customerId,
                "type" to transaction.type,
                "amount" to transaction.amount,
                "note" to transaction.note,
                "dateMillis" to transaction.dateMillis,
                "paymentMethod" to transaction.paymentMethod,
                "reference" to transaction.reference,
                "updatedAt" to System.currentTimeMillis()
            )
            val docId = if (transaction.id > 0) transaction.id.toString() else "tx_${System.currentTimeMillis()}"
            db.collection("users")
                .document(userId)
                .collection("udhar_ledger")
                .document(docId)
                .set(docData)
                .await()
            Log.d("FirestoreLedgerService", "Transaction saved to Firestore successfully for user $userId")
        } catch (e: Exception) {
            Log.e("FirestoreLedgerService", "Error saving transaction to Firestore: ${e.message}")
        }
    }

    suspend fun fetchTransactions(userId: String): List<LedgerTransaction> = withContext(Dispatchers.IO) {
        try {
            val db = firestore ?: return@withContext emptyList()
            val querySnapshot = db.collection("users")
                .document(userId)
                .collection("udhar_ledger")
                .get()
                .await()

            querySnapshot.documents.mapNotNull { doc ->
                val customerId = doc.getLong("customerId")?.toInt() ?: return@mapNotNull null
                val type = doc.getString("type") ?: "UDHAAR"
                val amount = doc.getDouble("amount") ?: 0.0
                val note = doc.getString("note") ?: ""
                val dateMillis = doc.getLong("dateMillis") ?: System.currentTimeMillis()
                val paymentMethod = doc.getString("paymentMethod") ?: "Cash"
                val reference = doc.getString("reference") ?: ""

                LedgerTransaction(
                    id = doc.getLong("id")?.toInt() ?: 0,
                    customerId = customerId,
                    type = type,
                    amount = amount,
                    note = note,
                    dateMillis = dateMillis,
                    paymentMethod = paymentMethod,
                    reference = reference
                )
            }
        } catch (e: Exception) {
            Log.e("FirestoreLedgerService", "Error fetching transactions from Firestore: ${e.message}")
            emptyList()
        }
    }
}
