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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
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
import com.example.data.CustomerFinancialSummary
import com.example.data.OverallShopSummary
import com.example.ui.UdharViewModel
import com.example.ui.components.CustomerAvatar
import com.example.ui.components.RiskBadge
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.BorderLight
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenUdharRepaid
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CustomerListScreen(
    summary: OverallShopSummary?,
    searchQuery: String,
    sortBy: String,
    viewModel: UdharViewModel,
    onCustomerClick: (Int) -> Unit,
    modifier: Modifier = Modifier
) {
    var sortExpanded by remember { mutableStateOf(false) }

    val customersList = summary?.customerBreakdown?.filter {
        it.customer.name.contains(searchQuery, ignoreCase = true) ||
                it.customer.phone.contains(searchQuery)
    }?.let { list ->
        when (sortBy) {
            "HighToLow" -> list.sortedByDescending { it.currentOutstanding }
            "LowToHigh" -> list.sortedBy { it.currentOutstanding }
            "Name" -> list.sortedBy { it.customer.name }
            else -> list
        }
    } ?: emptyList()

    Scaffold { innerPadding ->
        Column(
            modifier = modifier
                .fillMaxSize()
                .padding(innerPadding)
                .background(BackgroundSlate)
        ) {
            // Header Bar
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 12.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Loaned Individuals",
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = TextPrimary,
                    modifier = Modifier.weight(1f)
                )
                Button(
                    onClick = { viewModel.isAddCustomerOpen.value = true },
                    colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                    modifier = Modifier.testTag("add_customer_button")
                ) {
                    Icon(Icons.Default.Add, contentDescription = null, modifier = Modifier.size(18.dp))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text("Add")
                }
                Spacer(modifier = Modifier.width(4.dp))
                IconButton(onClick = { }) {
                    Icon(Icons.Default.FilterList, contentDescription = "Filter", tint = TextPrimary)
                }
            }

            // Search Bar
            OutlinedTextField(
                value = searchQuery,
                onValueChange = { viewModel.setSearchQuery(it) },
                placeholder = { Text("Search customer...", fontSize = 13.sp, color = TextMuted) },
                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null, tint = TextMuted) },
                shape = RoundedCornerShape(12.dp),
                colors = OutlinedTextFieldDefaults.colors(
                    focusedContainerColor = CardSurface,
                    unfocusedContainerColor = CardSurface,
                    focusedBorderColor = PrimaryBlue,
                    unfocusedBorderColor = BorderLight,
                    focusedTextColor = TextPrimary,
                    unfocusedTextColor = TextPrimary
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
                    .testTag("customer_search_input")
            )

            Spacer(modifier = Modifier.height(10.dp))

            // Sort Dropdown
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text("Sort by: ", fontSize = 12.sp, color = TextSecondary)

                ExposedDropdownMenuBox(
                    expanded = sortExpanded,
                    onExpandedChange = { sortExpanded = !sortExpanded }
                ) {
                    val sortLabel = when (sortBy) {
                        "HighToLow" -> "Outstanding (High to Low)"
                        "LowToHigh" -> "Outstanding (Low to High)"
                        else -> "Name (A-Z)"
                    }
                    Surface(
                        shape = RoundedCornerShape(8.dp),
                        color = CardSurface,
                        modifier = Modifier.menuAnchor()
                    ) {
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                        ) {
                            Text(sortLabel, fontSize = 12.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                            ExposedDropdownMenuDefaults.TrailingIcon(expanded = sortExpanded)
                        }
                    }

                    ExposedDropdownMenu(
                        expanded = sortExpanded,
                        onDismissRequest = { sortExpanded = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("Outstanding (High to Low)", fontSize = 12.sp, color = TextPrimary) },
                            onClick = {
                                viewModel.setSortBy("HighToLow")
                                sortExpanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Outstanding (Low to High)", fontSize = 12.sp, color = TextPrimary) },
                            onClick = {
                                viewModel.setSortBy("LowToHigh")
                                sortExpanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Name (A-Z)", fontSize = 12.sp, color = TextPrimary) },
                            onClick = {
                                viewModel.setSortBy("Name")
                                sortExpanded = false
                            }
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(10.dp))

            // Customer List
            LazyColumn(
                modifier = Modifier
                    .weight(1f)
                    .padding(horizontal = 16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(customersList, key = { it.customer.id }) { item ->
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onCustomerClick(item.customer.id) }
                            .testTag("customer_item_${item.customer.id}"),
                        shape = RoundedCornerShape(12.dp),
                        colors = CardDefaults.cardColors(containerColor = CardSurface),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
                    ) {
                        Row(
                            modifier = Modifier.padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            CustomerAvatar(name = item.customer.name)

                            Spacer(modifier = Modifier.width(12.dp))

                            Column(modifier = Modifier.weight(1f)) {
                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Text(
                                        text = item.customer.name,
                                        style = MaterialTheme.typography.titleSmall,
                                        fontWeight = FontWeight.Bold,
                                        color = TextPrimary
                                    )
                                    Spacer(modifier = Modifier.width(8.dp))
                                    RiskBadge(riskLevel = item.customer.riskLevel)
                                }

                                Spacer(modifier = Modifier.height(2.dp))

                                Row(verticalAlignment = Alignment.CenterVertically) {
                                    Icon(Icons.Default.Phone, contentDescription = null, tint = TextSecondary, modifier = Modifier.size(11.dp))
                                    Spacer(modifier = Modifier.width(4.dp))
                                    Text(
                                        text = item.customer.phone,
                                        fontSize = 11.sp,
                                        color = TextSecondary
                                    )
                                }
                            }

                            Column(horizontalAlignment = Alignment.End) {
                                Text(
                                    text = "₹ ${item.currentOutstanding.toInt()}",
                                    fontWeight = FontWeight.Bold,
                                    color = if (item.currentOutstanding > 0) RedUdhar else GreenUdharRepaid,
                                    fontSize = 14.sp
                                )
                                Text(
                                    text = "${String.format("%.1f", item.percentageShare)}%",
                                    fontSize = 10.sp,
                                    color = TextMuted
                                )
                            }

                            Spacer(modifier = Modifier.width(6.dp))

                            Icon(Icons.Default.ChevronRight, contentDescription = null, tint = TextMuted)
                        }
                    }
                }
            }

            // Bottom Summary Bar
            Surface(
                color = PrimaryBlueBg,
                modifier = Modifier.fillMaxWidth()
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp, vertical = 12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text("Total Outstanding", fontSize = 11.sp, color = TextSecondary)
                        Text(
                            "₹ ${summary?.currentOutstandingUdhar?.toInt() ?: 15000}",
                            fontWeight = FontWeight.ExtraBold,
                            fontSize = 16.sp,
                            color = RedUdhar
                        )
                    }

                    Column(horizontalAlignment = Alignment.End) {
                        Text("Active Customers", fontSize = 11.sp, color = TextSecondary)
                        Text(
                            "${summary?.activeCustomersCount ?: 127}",
                            fontWeight = FontWeight.ExtraBold,
                            fontSize = 16.sp,
                            color = TextPrimary
                        )
                    }
                }
            }
        }
    }
}
