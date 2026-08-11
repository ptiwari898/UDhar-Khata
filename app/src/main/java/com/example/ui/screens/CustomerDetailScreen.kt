package com.example.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.Chat
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.data.LedgerTransaction
import com.example.ui.UdharViewModel
import com.example.ui.components.CustomerAvatar
import com.example.ui.components.QuickActionButton
import com.example.ui.components.TrendLineChartCard
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun CustomerDetailScreen(
    customer: Customer,
    transactions: List<LedgerTransaction>,
    viewModel: UdharViewModel,
    onBackClick: () -> Unit,
    onChatClick: () -> Unit,
    onStatementClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    var selectedSubTab by remember { mutableStateOf(0) } // 0: Overview, 1: Transactions, 2: Orders, 3: Notes
    val scrollState = rememberScrollState()

    val totalUdhar = transactions.filter { it.type == "UDHAAR" }.sumOf { it.amount }
    val totalRepaid = transactions.filter { it.type == "PAYMENT" }.sumOf { it.amount }
    val totalAdvance = transactions.filter { it.type == "ADVANCE" }.sumOf { it.amount }
    val totalRefund = transactions.filter { it.type == "REFUND" }.sumOf { it.amount }

    val currentOutstanding = maxOf(0.0, totalUdhar - totalRepaid)
    val advanceBalance = maxOf(0.0, (totalAdvance - totalRefund) - maxOf(0.0, totalRepaid - totalUdhar))

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
    ) {
        // Top Bar
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 8.dp, vertical = 8.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(
                onClick = onBackClick,
                modifier = Modifier.testTag("back_button")
            ) {
                Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = TextPrimary)
            }

            Row {
                IconButton(
                    onClick = onChatClick,
                    modifier = Modifier.testTag("chat_button")
                ) {
                    Icon(Icons.Default.Chat, contentDescription = "Chat", tint = PrimaryBlue)
                }
                IconButton(onClick = { }) {
                    Icon(Icons.Default.MoreVert, contentDescription = "More", tint = TextPrimary)
                }
            }
        }

        // Sub Tabs
        TabRow(
            selectedTabIndex = selectedSubTab,
            containerColor = CardSurface,
            contentColor = PrimaryBlue
        ) {
            listOf("Overview", "Transactions", "Orders", "Notes").forEachIndexed { index, title ->
                Tab(
                    selected = selectedSubTab == index,
                    onClick = { selectedSubTab = index },
                    text = {
                        Text(
                            title,
                            fontWeight = FontWeight.Bold,
                            fontSize = 12.sp,
                            color = if (selectedSubTab == index) PrimaryBlue else TextSecondary
                        )
                    },
                    modifier = Modifier.testTag("tab_$title")
                )
            }
        }

        when (selectedSubTab) {
            0 -> {
                // Overview Tab Content
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .verticalScroll(scrollState)
                        .padding(16.dp)
                ) {
                    // Header Avatar & Info
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        CustomerAvatar(
                            name = customer.name,
                            backgroundColor = PrimaryBlueBg,
                            textColor = PrimaryBlue,
                            modifier = Modifier.size(64.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = customer.name,
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Phone, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(12.dp))
                            Spacer(modifier = Modifier.width(4.dp))
                            Text(customer.phone, fontSize = 12.sp, color = TextSecondary)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(customer.location, fontSize = 12.sp, color = TextSecondary)
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Surface(
                            color = RedBg,
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Text(
                                text = "High Outstanding",
                                color = RedUdhar,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(horizontal = 10.dp, vertical = 2.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Outstanding & Advance Cards
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = RedBg.copy(alpha = 0.5f))
                        ) {
                            Column(
                                modifier = Modifier.padding(14.dp),
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text("Current Outstanding", fontSize = 11.sp, color = RedUdhar)
                                Spacer(modifier = Modifier.height(4.dp))
                                Text(
                                    "₹ ${currentOutstanding.toInt()}",
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.ExtraBold,
                                    color = RedUdhar
                                )
                            }
                        }

                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = GreenBg.copy(alpha = 0.5f))
                        ) {
                            Column(
                                modifier = Modifier.padding(14.dp),
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text("Advance Balance", fontSize = 11.sp, color = GreenAdvance)
                                Spacer(modifier = Modifier.height(4.dp))
                                Text(
                                    "₹ ${advanceBalance.toInt()}",
                                    fontSize = 20.sp,
                                    fontWeight = FontWeight.ExtraBold,
                                    color = GreenAdvance
                                )
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(12.dp))

                    // Metrics Row
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = CardSurface)
                        ) {
                            Column(modifier = Modifier.padding(10.dp)) {
                                Text("Total Loaned", fontSize = 10.sp, color = TextSecondary)
                                Text("₹ ${totalUdhar.toInt()}", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                            }
                        }

                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = CardSurface)
                        ) {
                            Column(modifier = Modifier.padding(10.dp)) {
                                Text("Total Repaid", fontSize = 10.sp, color = TextSecondary)
                                Text("₹ ${totalRepaid.toInt()}", fontSize = 13.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                            }
                        }

                        Card(
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(12.dp),
                            colors = CardDefaults.cardColors(containerColor = CardSurface)
                        ) {
                            Column(modifier = Modifier.padding(10.dp)) {
                                Text("Last Transaction", fontSize = 10.sp, color = TextSecondary)
                                Text("08 Aug 2026", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    // Trend Line Chart
                    TrendLineChartCard()

                    Spacer(modifier = Modifier.height(16.dp))

                    // Quick Actions Card
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(16.dp),
                        colors = CardDefaults.cardColors(containerColor = CardSurface)
                    ) {
                        Column(modifier = Modifier.padding(14.dp)) {
                            Text("Quick Actions", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = TextPrimary)
                            Spacer(modifier = Modifier.height(12.dp))
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                QuickActionButton(
                                    icon = Icons.Default.ArrowUpward,
                                    label = "Add Udhar",
                                    tag = "cust_add_udhar",
                                    color = RedUdhar,
                                    onClick = { viewModel.isAddUdharOpen.value = true }
                                )
                                QuickActionButton(
                                    icon = Icons.Default.ArrowDownward,
                                    label = "Receive Payment",
                                    tag = "cust_receive_payment",
                                    color = GreenAdvance,
                                    onClick = { viewModel.isReceivePaymentOpen.value = true }
                                )
                                QuickActionButton(
                                    icon = Icons.Default.Add,
                                    label = "Add Advance",
                                    tag = "cust_add_advance",
                                    color = PrimaryBlue,
                                    onClick = { viewModel.isAddAdvanceOpen.value = true }
                                )
                                QuickActionButton(
                                    icon = Icons.Default.Notifications,
                                    label = "Send Reminder",
                                    tag = "cust_send_reminder",
                                    color = Color(0xFFFFB74D),
                                    onClick = { viewModel.isWhatsAppReminderOpen.value = true }
                                )
                                QuickActionButton(
                                    icon = Icons.Default.Description,
                                    label = "View Statement",
                                    tag = "cust_view_statement",
                                    color = Color(0xFFB69DF8),
                                    onClick = onStatementClick
                                )
                            }
                        }
                    }
                }
            }

            1 -> {
                // Embedded Transactions Screen
                TransactionHistoryScreen(
                    customer = customer,
                    transactions = transactions,
                    viewModel = viewModel,
                    modifier = Modifier.weight(1f)
                )
            }

            2 -> {
                // Orders Screen
                OrdersScreen(
                    customer = customer,
                    viewModel = viewModel,
                    modifier = Modifier.weight(1f)
                )
            }

            else -> {
                // Notes Tab
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp)
                ) {
                    Text("Customer Notes", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = TextPrimary)
                    Spacer(modifier = Modifier.height(8.dp))
                    Card(
                        modifier = Modifier.fillMaxWidth(),
                        colors = CardDefaults.cardColors(containerColor = CardSurface)
                    ) {
                        Text(
                            text = customer.notes.ifEmpty { "Regular grocery buyer. Prefers payment via Cash or UPI." },
                            modifier = Modifier.padding(16.dp),
                            color = TextPrimary
                        )
                    }
                }
            }
        }
    }
}
