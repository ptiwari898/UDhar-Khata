package com.example.service

import android.util.Log
import com.example.BuildConfig
import com.example.data.Customer
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.Query
import java.util.concurrent.TimeUnit
import org.json.JSONObject

data class ParsedTransaction(
    val customerName: String,
    val matchedCustomerId: Int?,
    val transactionType: String, // UDHAAR, PAYMENT, ADVANCE, REFUND
    val amount: Double,
    val note: String,
    val rawSpokenText: String,
    val isAiParsed: Boolean = false,
    val modelName: String = "Gemini 3.5 Flash"
)

// Gemini API Request/Response Data Classes
data class GeminiPart(val text: String)
data class GeminiContent(val parts: List<GeminiPart>)
data class GeminiRequest(val contents: List<GeminiContent>)

data class GeminiCandidate(val content: GeminiContent?)
data class GeminiResponse(val candidates: List<GeminiCandidate>?)

interface GeminiApiService {
    @POST("v1beta/models/gemini-3.5-flash:generateContent")
    suspend fun generateContent(
        @Query("key") apiKey: String,
        @Body request: GeminiRequest
    ): GeminiResponse
}

object VoiceParserService {

    private const val TAG = "VoiceParserService"

    private val okHttpClient = OkHttpClient.Builder()
        .connectTimeout(60, TimeUnit.SECONDS)
        .readTimeout(60, TimeUnit.SECONDS)
        .writeTimeout(60, TimeUnit.SECONDS)
        .build()

    private val retrofit = Retrofit.Builder()
        .baseUrl("https://generativelanguage.googleapis.com/")
        .client(okHttpClient)
        .addConverterFactory(MoshiConverterFactory.create())
        .build()

    private val geminiApi: GeminiApiService = retrofit.create(GeminiApiService::class.java)

    suspend fun parseVoiceCommand(
        spokenText: String,
        customers: List<Customer>
    ): ParsedTransaction = withContext(Dispatchers.IO) {
        val apiKey = BuildConfig.GEMINI_API_KEY.trim()

        // If Gemini API Key is available, perform real Gemini 3.5 Flash LLM parsing
        if (apiKey.isNotBlank() && apiKey != "MY_GEMINI_API_KEY") {
            try {
                val customerListStr = customers.joinToString("\n") { cust ->
                    "- ID: ${cust.id}, Name: ${cust.name}, Phone: ${cust.phone}"
                }

                val prompt = """
                    You are an AI assistant for UdharKhata, an Indian merchant ledger app.
                    The user spoke or entered this transaction message in Hindi, Hinglish, or English:
                    "$spokenText"

                    Existing Customers in database:
                    $customerListStr

                    Task: Extract the transaction details into a JSON object with EXACT keys:
                    {
                      "customerName": "Name of customer detected (match with existing if close, otherwise spoken name)",
                      "matchedCustomerId": integer ID of matched customer or null,
                      "transactionType": "UDHAAR" (debt given/credit sale) OR "PAYMENT" (cash/UPI received) OR "ADVANCE" (advance given/received),
                      "amount": number amount in Rupees,
                      "note": "brief note or items summary (e.g. Grocery items, Milk packet, Cash payment)"
                    }

                    Output ONLY valid raw JSON.
                """.trimIndent()

                val request = GeminiRequest(
                    contents = listOf(
                        GeminiContent(parts = listOf(GeminiPart(text = prompt)))
                    )
                )

                val response = geminiApi.generateContent(apiKey, request)
                val responseText = response.candidates
                    ?.firstOrNull()
                    ?.content
                    ?.parts
                    ?.firstOrNull()
                    ?.text ?: ""

                Log.d(TAG, "Gemini Response: $responseText")

                // Extract JSON object from potential markdown code fences
                val jsonStr = responseText
                    .replace("```json", "")
                    .replace("```", "")
                    .trim()

                if (jsonStr.startsWith("{") && jsonStr.endsWith("}")) {
                    val json = JSONObject(jsonStr)
                    val customerName = json.optString("customerName", "Customer")
                    val matchedCustId = if (json.has("matchedCustomerId") && !json.isNull("matchedCustomerId")) json.getInt("matchedCustomerId") else null
                    val txType = json.optString("transactionType", "UDHAAR").uppercase()
                    val amount = json.optDouble("amount", 0.0)
                    val note = json.optString("note", "Voice Transaction")

                    return@withContext ParsedTransaction(
                        customerName = customerName,
                        matchedCustomerId = matchedCustId ?: customers.find { it.name.equals(customerName, ignoreCase = true) }?.id,
                        transactionType = if (txType in listOf("UDHAAR", "PAYMENT", "ADVANCE")) txType else "UDHAAR",
                        amount = amount,
                        note = note,
                        rawSpokenText = spokenText,
                        isAiParsed = true,
                        modelName = "Gemini 3.5 Flash"
                    )
                }
            } catch (e: Exception) {
                Log.e(TAG, "Gemini API Parsing Error: ${e.message}", e)
                // Fall back to rule-based parser on error
            }
        }

        // --- Fallback Heuristic Local Extraction ---
        val lowerText = spokenText.lowercase()
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

        val type = when {
            lowerText.contains("advance") -> "ADVANCE"
            lowerText.contains("refund") -> "REFUND"
            lowerText.contains("payment") || lowerText.contains("mila") || lowerText.contains("diye") || lowerText.contains("cash") || lowerText.contains("upi") -> "PAYMENT"
            lowerText.contains("udhar") || lowerText.contains("udhaar") || lowerText.contains("diya") || lowerText.contains("gave") -> "UDHAAR"
            else -> "UDHAAR"
        }

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
            rawSpokenText = spokenText,
            isAiParsed = false,
            modelName = "Rule Engine"
        )
    }
}

