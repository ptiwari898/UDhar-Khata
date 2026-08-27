package com.example.ui.screens

import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Download
import androidx.compose.material.icons.filled.Share
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.data.LedgerTransaction
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.OrangeMedium
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun CustomerStatementScreen(
    customer: Customer,
    transactions: List<LedgerTransaction>,
    shopName: String,
    upiId: String,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val totalLoaned = transactions.filter { it.type == "UDHAAR" }.sumOf { it.amount }
    val totalRepaid = transactions.filter { it.type == "PAYMENT" }.sumOf { it.amount }
    val totalAdvance = transactions.filter { it.type == "ADVANCE" }.sumOf { it.amount }
    val totalRefund = transactions.filter { it.type == "REFUND" }.sumOf { it.amount }

    val currentOutstanding = maxOf(0.0, totalLoaned - totalRepaid)
    val advanceBalance = maxOf(0.0, (totalAdvance - totalRefund) - maxOf(0.0, totalRepaid - totalLoaned))

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
            .padding(16.dp)
    ) {
        // Top Bar
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                IconButton(onClick = onBackClick, modifier = Modifier.testTag("statement_back")) {
                    Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = TextPrimary)
                }
                Spacer(modifier = Modifier.width(4.dp))
                Text(
                    text = customer.name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    color = TextPrimary
                )
            }

            OutlinedButton(
                onClick = { },
                shape = RoundedCornerShape(8.dp),
                modifier = Modifier.testTag("download_statement_button")
            ) {
                Icon(Icons.Default.Download, contentDescription = null, modifier = Modifier.width(16.dp))
                Spacer(modifier = Modifier.width(4.dp))
                Text("Download", fontSize = 12.sp)
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // Date Range Selector Card
        Card(
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = CardSurface),
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier.padding(12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Default.CalendarToday, contentDescription = null, tint = PrimaryBlue, modifier = Modifier.width(18.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Text("01 Jun 2026 - 11 Aug 2026", fontWeight = FontWeight.Bold, fontSize = 13.sp, color = TextPrimary)
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Stat Cards Grid
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Card(
                modifier = Modifier.weight(1f),
                colors = CardDefaults.cardColors(containerColor = CardSurface)
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text("Total Loaned", fontSize = 11.sp, color = TextSecondary)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${totalLoaned.toInt()}", fontSize = 18.sp, fontWeight = FontWeight.ExtraBold, color = PrimaryBlue)
                }
            }

            Card(
                modifier = Modifier.weight(1f),
                colors = CardDefaults.cardColors(containerColor = CardSurface)
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text("Total Repaid", fontSize = 11.sp, color = TextSecondary)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${totalRepaid.toInt()}", fontSize = 18.sp, fontWeight = FontWeight.ExtraBold, color = GreenAdvance)
                }
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            Card(
                modifier = Modifier.weight(1f),
                colors = CardDefaults.cardColors(containerColor = RedBg.copy(alpha = 0.5f))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text("Current Outstanding", fontSize = 11.sp, color = RedUdhar)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${currentOutstanding.toInt()}", fontSize = 18.sp, fontWeight = FontWeight.ExtraBold, color = RedUdhar)
                }
            }

            Card(
                modifier = Modifier.weight(1f),
                colors = CardDefaults.cardColors(containerColor = GreenBg.copy(alpha = 0.5f))
            ) {
                Column(modifier = Modifier.padding(14.dp)) {
                    Text("Advance Balance", fontSize = 11.sp, color = GreenAdvance)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${advanceBalance.toInt()}", fontSize = 18.sp, fontWeight = FontWeight.ExtraBold, color = OrangeMedium)
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        // Info banner
        Surface(
            color = CardSurface,
            shape = RoundedCornerShape(8.dp),
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                text = "Statement shows all transactions in selected period.",
                fontSize = 12.sp,
                color = TextSecondary,
                modifier = Modifier.padding(12.dp)
            )
        }

        Spacer(modifier = Modifier.weight(1f))

        // Share Action Button
        Button(
            onClick = {
                val phoneDigits = customer.phone.filter(Char::isDigit)
                if (phoneDigits.isEmpty()) {
                    Toast.makeText(context, "Customer mobile number is missing", Toast.LENGTH_SHORT).show()
                    return@Button
                }
                val whatsappNumber = if (phoneDigits.length == 10) "91$phoneDigits" else phoneDigits
                val paymentDetails = upiId.trim().takeIf { it.contains("@") }?.let { savedUpiId ->
                    val paymentLink = Uri.Builder()
                        .scheme("upi")
                        .authority("pay")
                        .appendQueryParameter("pa", savedUpiId)
                        .appendQueryParameter("pn", shopName)
                        .appendQueryParameter("am", currentOutstanding.toString())
                        .appendQueryParameter("cu", "INR")
                        .build()
                    "\n\nPay outstanding via UPI\nUPI ID: $savedUpiId\nPay now: $paymentLink"
                }.orEmpty()
                val statementMessage = "Hello ${customer.name},\n\nYour ledger statement:\nTotal Udhar: Rs. ${totalLoaned.toInt()}\nTotal Paid: Rs. ${totalRepaid.toInt()}\nOutstanding: Rs. ${currentOutstanding.toInt()}\nAdvance Balance: Rs. ${advanceBalance.toInt()}$paymentDetails\n\nThank you."
                val intent = Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("https://wa.me/$whatsappNumber?text=${Uri.encode(statementMessage)}")
                )
                context.startActivity(intent)
            },
            colors = ButtonDefaults.buttonColors(containerColor = GreenAdvance),
            modifier = Modifier
                .fillMaxWidth()
                .testTag("share_whatsapp_statement_button")
        ) {
            Icon(Icons.Default.Share, contentDescription = null)
            Spacer(modifier = Modifier.width(8.dp))
            Text("Share Statement on WhatsApp")
        }
    }
}
