package com.example.ui.screens

import androidx.compose.foundation.background
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.ReceiptLong
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.OverallShopSummary
import com.example.data.ShopProfile
import com.example.ui.UdharViewModel
import com.example.ui.components.OutstandingPieChartCard
import com.example.ui.components.QuickActionButton
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar

@Composable
fun DashboardScreen(
    summary: OverallShopSummary?,
    profile: ShopProfile?,
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
        // Top Bar
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.Menu, contentDescription = "Menu", tint = Color(0xFF0F172A))
                Spacer(modifier = Modifier.width(12.dp))
                Column {
                    Text(
                        text = "My Profile",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = Color(0xFF0F172A)
                    )
                    Text(
                        text = profile?.shopName ?: "Shivam Kirana Store",
                        style = MaterialTheme.typography.bodySmall,
                        color = Color(0xFF64748B)
                    )
                }
            }
            IconButton(
                onClick = { viewModel.isWhatsAppReminderOpen.value = true },
                modifier = Modifier.testTag("notification_bell")
            ) {
                Icon(Icons.Default.Notifications, contentDescription = "Notifications", tint = Color(0xFF0F172A))
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Owner Profile Card
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
        ) {
            Row(
                modifier = Modifier.padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .size(60.dp)
                        .clip(CircleShape)
                        .background(Color(0xFFFEF3C7)),
                    contentAlignment = Alignment.Center
                ) {
                    Text("🏪", fontSize = 28.sp)
                }

                Spacer(modifier = Modifier.width(14.dp))

                Column(modifier = Modifier.weight(1f)) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text(
                            text = profile?.ownerName ?: "Pawan Tiwari",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF0F172A)
                        )
                        Spacer(modifier = Modifier.width(8.dp))
                        Surface(
                            color = PrimaryBlueBg,
                            shape = RoundedCornerShape(8.dp)
                        ) {
                            Text(
                                text = "Owner",
                                color = PrimaryBlue,
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(4.dp))

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Phone, contentDescription = null, tint = Color(0xFF64748B), modifier = Modifier.size(12.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = profile?.phone ?: "+91 98765 43210",
                            style = MaterialTheme.typography.bodySmall,
                            color = Color(0xFF64748B)
                        )
                    }

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.LocationOn, contentDescription = null, tint = Color(0xFF64748B), modifier = Modifier.size(12.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text(
                            text = profile?.location ?: "Bhopal, Madhya Pradesh",
                            style = MaterialTheme.typography.bodySmall,
                            color = Color(0xFF64748B)
                        )
                    }

                    Text(
                        text = "Member Since: ${profile?.memberSince ?: "12 Mar 2024"}",
                        fontSize = 10.sp,
                        color = Color(0xFF94A3B8)
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Large Current Outstanding Banner
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = GreenAdvance)
        ) {
            Column(
                modifier = Modifier.padding(20.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = "Current Outstanding (Udhar)",
                    color = Color.White.copy(alpha = 0.9f),
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = "₹ ${summary?.currentOutstandingUdhar?.toInt() ?: 15000}",
                    color = Color.White,
                    fontSize = 28.sp,
                    fontWeight = FontWeight.ExtraBold
                )
            }
        }

        Spacer(modifier = Modifier.height(12.dp))

        // 3 Metrics Row
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("Total Loaned Till Date", fontSize = 10.sp, color = Color(0xFF64748B))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${summary?.totalLoanedTillDate?.toInt() ?: 125000}", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0F172A))
                }
            }

            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("Total Repaid", fontSize = 10.sp, color = Color(0xFF64748B))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${summary?.totalRepaid?.toInt() ?: 110000}", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0F172A))
                }
            }

            Card(
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = Color.White)
            ) {
                Column(modifier = Modifier.padding(12.dp)) {
                    Text("Advance Balance", fontSize = 10.sp, color = Color(0xFF64748B))
                    Spacer(modifier = Modifier.height(4.dp))
                    Text("₹ ${summary?.advanceBalance?.toInt() ?: 18500}", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GreenAdvance)
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Pie Chart
        OutstandingPieChartCard(
            summaries = summary?.customerBreakdown ?: emptyList(),
            totalOutstanding = summary?.currentOutstandingUdhar ?: 15000.0
        )

        Spacer(modifier = Modifier.height(16.dp))

        // Quick Actions Row
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White)
        ) {
            Column(modifier = Modifier.padding(14.dp)) {
                Text("Quick Actions", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = Color(0xFF1E293B))
                Spacer(modifier = Modifier.height(12.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    QuickActionButton(
                        icon = Icons.Default.ArrowUpward,
                        label = "Add Udhar",
                        tag = "quick_add_udhar",
                        color = RedUdhar,
                        onClick = { viewModel.isAddUdharOpen.value = true }
                    )
                    QuickActionButton(
                        icon = Icons.Default.ArrowDownward,
                        label = "Receive Payment",
                        tag = "quick_receive_payment",
                        color = GreenAdvance,
                        onClick = { viewModel.isReceivePaymentOpen.value = true }
                    )
                    QuickActionButton(
                        icon = Icons.Default.Add,
                        label = "Add Advance",
                        tag = "quick_add_advance",
                        color = PrimaryBlue,
                        onClick = { viewModel.isAddAdvanceOpen.value = true }
                    )
                    QuickActionButton(
                        icon = Icons.Default.ShoppingCart,
                        label = "Create Order",
                        tag = "quick_create_order",
                        color = Color(0xFF8B5CF6),
                        onClick = { viewModel.isAddOrderOpen.value = true }
                    )
                    QuickActionButton(
                        icon = Icons.Default.Mic,
                        label = "Voice Entry",
                        tag = "quick_voice_entry",
                        color = Color(0xFFD97706),
                        onClick = { viewModel.isVoiceEntryOpen.value = true }
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Summary (This Month)
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White)
        ) {
            Column(modifier = Modifier.padding(14.dp)) {
                Text("Summary (This Month)", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = Color(0xFF1E293B))
                Spacer(modifier = Modifier.height(12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = RedBg.copy(alpha = 0.5f))
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("Udhar Given", fontSize = 10.sp, color = RedUdhar)
                            Text("₹ 22,500", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = RedUdhar)
                        }
                    }

                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = GreenBg.copy(alpha = 0.5f))
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("Collection", fontSize = 10.sp, color = GreenAdvance)
                            Text("₹ 18,200", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = GreenAdvance)
                        }
                    }

                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = PrimaryBlueBg)
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("Advance Received", fontSize = 10.sp, color = PrimaryBlue)
                            Text("₹ 9,500", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = PrimaryBlue)
                        }
                    }

                    Card(
                        modifier = Modifier.weight(1f),
                        colors = CardDefaults.cardColors(containerColor = Color(0xFFF1F5F9))
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            Text("Orders", fontSize = 10.sp, color = Color(0xFF475569))
                            Text("26", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = Color(0xFF0F172A))
                        }
                    }
                }
            }
        }
    }
}
