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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.ui.UdharViewModel
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.TextMuted
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun OrdersScreen(
    customer: Customer? = null,
    viewModel: UdharViewModel,
    modifier: Modifier = Modifier
) {
    val orders by viewModel.allOrders.collectAsState()

    val displayOrders = if (customer != null) {
        orders.filter { it.customerId == customer.id }
    } else {
        orders
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(Color.Transparent)
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = if (customer != null) "${customer.name}'s Orders" else "All Shop Orders",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
                color = TextPrimary
            )

            Button(
                onClick = { viewModel.isAddOrderOpen.value = true },
                modifier = Modifier.testTag("create_order_button")
            ) {
                Icon(Icons.Default.Add, contentDescription = null)
                Spacer(modifier = Modifier.width(4.dp))
                Text("New Order")
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        if (displayOrders.isEmpty()) {
            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Icon(Icons.Default.ShoppingCart, contentDescription = null, tint = TextMuted, modifier = Modifier.height(48.dp))
                Spacer(modifier = Modifier.height(8.dp))
                Text("No orders placed yet", color = TextSecondary)
            }
        } else {
            LazyColumn(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                items(displayOrders, key = { it.id }) { order ->
                    Card(
                        shape = RoundedCornerShape(12.dp),
                        colors = CardDefaults.cardColors(containerColor = CardSurface),
                        elevation = CardDefaults.cardElevation(defaultElevation = 1.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("order_item_${order.id}")
                    ) {
                        Column(modifier = Modifier.padding(14.dp)) {
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text("Order #${order.id + 1024}", fontWeight = FontWeight.Bold, color = PrimaryBlue)
                                Surface(
                                    color = GreenBg,
                                    shape = RoundedCornerShape(8.dp)
                                ) {
                                    Text(
                                        text = order.status,
                                        color = GreenAdvance,
                                        fontSize = 11.sp,
                                        fontWeight = FontWeight.Bold,
                                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                                    )
                                }
                            }

                            Spacer(modifier = Modifier.height(6.dp))
                            Text(order.itemsSummary, fontSize = 13.sp, color = TextPrimary)
                            Spacer(modifier = Modifier.height(8.dp))

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Total: ₹${order.totalAmount.toInt()}", fontWeight = FontWeight.Bold, color = TextPrimary)
                                Text("Advance Paid: ₹${order.advancePaid.toInt()}", color = GreenAdvance, fontSize = 12.sp)
                            }
                        }
                    }
                }
            }
        }
    }
}
