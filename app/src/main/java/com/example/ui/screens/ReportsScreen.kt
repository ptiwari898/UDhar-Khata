package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.OverallShopSummary
import com.example.ui.UdharViewModel
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.RedUdhar

@Composable
fun ReportsScreen(
    summary: OverallShopSummary?,
    viewModel: UdharViewModel,
    modifier: Modifier = Modifier
) {
    val scrollState = rememberScrollState()

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Color(0xFFF8FAFC))
            .verticalScroll(scrollState)
            .padding(16.dp)
    ) {
        Text("Business Reports & Analytics", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold, color = Color(0xFF0F172A))
        Spacer(modifier = Modifier.height(16.dp))

        // Financial Overview Card
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = PrimaryBlue),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Monthly Business Financials", color = Color.White.copy(alpha = 0.8f), fontSize = 12.sp)
                Spacer(modifier = Modifier.height(6.dp))
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                    Column {
                        Text("Total Udhar", color = Color.White, fontSize = 11.sp)
                        Text("₹ 22,500", color = Color.White, fontWeight = FontWeight.ExtraBold, fontSize = 18.sp)
                    }
                    Column {
                        Text("Total Collection", color = Color.White, fontSize = 11.sp)
                        Text("₹ 18,200", color = Color.White, fontWeight = FontWeight.ExtraBold, fontSize = 18.sp)
                    }
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Outstanding Aging Analysis
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Outstanding Aging Analysis", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))

                AgingItem("0 – 7 Days", "₹ 4,500", GreenAdvance)
                AgingItem("8 – 30 Days", "₹ 8,200", Color(0xFFD97706))
                AgingItem("31 – 60 Days", "₹ 3,700", Color(0xFFEA580C))
                AgingItem("60+ Days (High Risk)", "₹ 6,500", RedUdhar)
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Customer Ranking
        Card(
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            modifier = Modifier.fillMaxWidth()
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Top Customer Ranking", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(12.dp))

                summary?.customerBreakdown?.take(5)?.forEachIndexed { idx, cust ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 6.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("${idx + 1}. ${cust.customer.name}", fontWeight = FontWeight.Bold, fontSize = 13.sp)
                        Text("₹ ${cust.currentOutstanding.toInt()}", fontWeight = FontWeight.Bold, color = RedUdhar, fontSize = 13.sp)
                    }
                }
            }
        }
    }
}

@Composable
private fun AgingItem(period: String, amount: String, color: Color) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 6.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(period, fontSize = 13.sp, color = Color(0xFF334155))
        Text(amount, fontWeight = FontWeight.Bold, fontSize = 14.sp, color = color)
    }
}
