package com.example.service

import com.example.BuildConfig
import com.example.data.Customer
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.Query
import java.util.concurrent.TimeUnit

data class ParsedTransaction(
    val customerName: String,
    val matchedCustomerId: Int?,
    val transactionType: String, // UDHAAR, PAYMENT, ADVANCE, REFUND
    val amount: Double,
    val note: String,
    val rawSpokenText: String
)

object VoiceParserService {

    suspend fun parseVoiceCommand(
        spokenText: String,
        customers: List<Customer>
    ): ParsedTransaction = withContext(Dispatchers.IO) {
        val lowerText = spokenText.lowercase()

        // 1. First try local fallback extraction for quick and reliable results
        var detectedName = ""
        var matchedCust: Customer? = null

        for (cust in customers) {
            val nameTokens = cust.name.lowercase().split(" ")
            for (token in nameTokens) {
                if (token.length > 2 && lowerText.contains(token)) {
                    detectedName = cust.name
                    matchedCust = cust
                    break
                }
            }
            if (matchedCust != null) break
        }

        if (detectedName.isEmpty()) {
            val words = spokenText.split(" ")
            detectedName = words.firstOrNull() ?: "Customer"
        }

        // Determine Transaction Type
        val type = when {
            lowerText.contains("advance") -> "ADVANCE"
            lowerText.contains("refund") -> "REFUND"
            lowerText.contains("payment") || lowerText.contains("mila") || lowerText.contains("diye") || lowerText.contains("cash") || lowerText.contains("upi") -> "PAYMENT"
            lowerText.contains("udhar") || lowerText.contains("udhaar") || lowerText.contains("diya") || lowerText.contains("gave") -> "UDHAAR"
            else -> "UDHAAR"
        }

        // Extract Amount
        var amount = 0.0
        val numberRegex = Regex("(\\d+)")
        val match = numberRegex.find(spokenText)
        if (match != null) {
            amount = match.value.toDoubleOrNull() ?: 0.0
            if (lowerText.contains("hazaar") || lowerText.contains("k") || lowerText.contains("thousand")) {
                amount *= 1000
            }
        } else {
            if (lowerText.contains("hazaar") || lowerText.contains("thousand")) {
                amount = 1000.0
            } else if (lowerText.contains("panch sau") || lowerText.contains("5 sau")) {
                amount = 500.0
            }
        }

        // Extract Note
        val note = when {
            lowerText.contains("grocery") -> "Grocery Items"
            lowerText.contains("oil") -> "Oil & Cooking"
            lowerText.contains("atta") -> "Atta & Provisions"
            lowerText.contains("sugar") -> "Sugar & Tea"
            else -> "Voice Transaction"
        }

        ParsedTransaction(
            customerName = detectedName,
            matchedCustomerId = matchedCust?.id,
            transactionType = type,
            amount = if (amount > 0) amount else 500.0,
            note = note,
            rawSpokenText = spokenText
        )
    }
}
