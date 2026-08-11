package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.Savings
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.data.LedgerTransaction
import com.example.ui.UdharViewModel
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun TransactionHistoryScreen(
    customer: Customer,
    transactions: List<LedgerTransaction>,
    viewModel: UdharViewModel,
    modifier: Modifier = Modifier
) {
    val activeFilter by viewModel.transactionFilter.collectAsState()

    val filteredList = transactions.filter {
        when (activeFilter) {
            "Udhar" -> it.type == "UDHAAR"
            "Payment" -> it.type == "PAYMENT"
            "Advance" -> it.type == "ADVANCE"
            "Refund" -> it.type == "REFUND"
            else -> true
        }
    }

    val totalLoaned = transactions.filter { it.type == "UDHAAR" }.sumOf { it.amount }
    val totalRepaid = transactions.filter { it.type == "PAYMENT" }.sumOf { it.amount }
    val currentOutstanding = maxOf(0.0, totalLoaned - totalRepaid)

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
    ) {
        // Header
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = customer.name,
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )
            IconButton(onClick = { }) {
                Icon(Icons.Default.FilterList, contentDescription = "Filter", tint = TextPrimary)
            }
        }

        // Filter Pills Row
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 6.dp),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            listOf("ALL", "Udhar", "Payment", "Advance", "Refund").forEach { filterName ->
                val isSelected = activeFilter.equals(filterName, ignoreCase = true)
                Surface(
                    shape = RoundedCornerShape(16.dp),
                    color = if (isSelected) PrimaryBlue else CardSurface,
                    modifier = Modifier.clickable { viewModel.setTransactionFilter(filterName) }
                ) {
                    Text(
                        text = filterName,
                        color = if (isSelected) Color(0xFF1C1B1F) else TextSecondary,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(horizontal = 14.dp, vertical = 6.dp)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        // Grouped Transactions List
        LazyColumn(
            modifier = Modifier
                .weight(1f)
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(filteredList, key = { it.id }) { txn ->
                val (icon, iconColor, iconBg, textPrefix) = when (txn.type) {
                    "UDHAAR" -> QuadrantStyle(Icons.Default.ArrowUpward, RedUdhar, RedBg, "Udhar")
                    "PAYMENT" -> QuadrantStyle(Icons.Default.ArrowDownward, GreenAdvance, GreenBg, "Payment")
                    "ADVANCE" -> QuadrantStyle(Icons.Default.Savings, GreenAdvance, GreenBg, "Advance")
                    else -> QuadrantStyle(Icons.Default.Refresh, RedUdhar, RedBg, "Refund")
                }

                Card(
                    shape = RoundedCornerShape(12.dp),
                    colors = CardDefaults.cardColors(containerColor = CardSurface),
                    elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .testTag("txn_item_${txn.id}")
                ) {
                    Row(
                        modifier = Modifier.padding(12.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Box(
                            modifier = Modifier
                                .size(40.dp)
                                .clip(CircleShape)
                                .background(iconBg),
                            contentAlignment = Alignment.Center
                        ) {
                            Icon(icon, contentDescription = null, tint = iconColor, modifier = Modifier.size(20.dp))
                        }

                        Spacer(modifier = Modifier.width(12.dp))

                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = textPrefix,
                                fontWeight = FontWeight.Bold,
                                style = MaterialTheme.typography.bodyMedium,
                                color = TextPrimary
                            )
                            Text(
                                text = txn.note.ifEmpty { txn.paymentMethod },
                                fontSize = 11.sp,
                                color = TextSecondary
                            )
                        }

                        Column(horizontalAlignment = Alignment.End) {
                            Text(
                                text = "₹ ${txn.amount.toInt()}",
                                fontWeight = FontWeight.Bold,
                                color = iconColor,
                                fontSize = 15.sp
                            )
                        }
                    }
                }
            }
        }

        // Bottom Sticky Summary
        Surface(
            color = RedBg,
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text("Total Loaned", fontSize = 10.sp, color = TextSecondary)
                    Text("₹ ${totalLoaned.toInt()}", fontWeight = FontWeight.Bold, fontSize = 14.sp, color = TextPrimary)
                }
                Column {
                    Text("Total Repaid", fontSize = 10.sp, color = TextSecondary)
                    Text("₹ ${totalRepaid.toInt()}", fontWeight = FontWeight.Bold, fontSize = 14.sp, color = GreenAdvance)
                }
                Column {
                    Text("Current Outstanding", fontSize = 10.sp, color = TextSecondary)
                    Text("₹ ${currentOutstanding.toInt()}", fontWeight = FontWeight.ExtraBold, fontSize = 14.sp, color = RedUdhar)
                }
            }
        }
    }
}

private data class QuadrantStyle(
    val icon: androidx.compose.ui.graphics.vector.ImageVector,
    val color: Color,
    val bg: Color,
    val label: String
)
