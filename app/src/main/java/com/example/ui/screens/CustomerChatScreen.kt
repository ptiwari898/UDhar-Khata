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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.AttachFile
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.ChatMessage
import com.example.data.Customer
import com.example.ui.UdharViewModel
import com.example.ui.components.CustomerAvatar
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@Composable
fun CustomerChatScreen(
    customer: Customer,
    viewModel: UdharViewModel,
    onBackClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val messagesFlow = remember(customer.id) { viewModel.repository.getChatForCustomer(customer.id) }
    val messages by messagesFlow.collectAsState(initial = emptyList())
    var inputMessage by remember { mutableStateOf("") }
    val coroutineScope = rememberCoroutineScope()

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
    ) {
        // Chat Header
        Surface(
            color = CardSurface,
            shadowElevation = 2.dp,
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 8.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = onBackClick, modifier = Modifier.testTag("chat_back")) {
                    Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = TextPrimary)
                }
                CustomerAvatar(name = customer.name)
                Spacer(modifier = Modifier.width(10.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(customer.name, fontWeight = FontWeight.Bold, style = MaterialTheme.typography.titleMedium, color = TextPrimary)
                    Text(customer.phone, fontSize = 11.sp, color = TextSecondary)
                }
                IconButton(onClick = { }) {
                    Icon(Icons.Default.Phone, contentDescription = "Call", tint = PrimaryBlue)
                }
            }
        }

        // Messages List
        LazyColumn(
            modifier = Modifier
                .weight(1f)
                .padding(horizontal = 16.dp, vertical = 12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(messages, key = { it.id }) { msg ->
                val isShop = msg.sender == "SHOP"
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = if (isShop) Arrangement.End else Arrangement.Start
                ) {
                    Card(
                        shape = RoundedCornerShape(12.dp),
                        colors = CardDefaults.cardColors(
                            containerColor = if (isShop) PrimaryBlue else CardSurface
                        ),
                        modifier = Modifier.testTag("chat_msg_${msg.id}")
                    ) {
                        Column(modifier = Modifier.padding(10.dp)) {
                            if (msg.messageType == "BILL") {
                                Text("🧾 BILL SUMMARY", fontWeight = FontWeight.Bold, fontSize = 11.sp, color = if (isShop) Color(0xFFFFD54F) else PrimaryBlue)
                            }
                            Text(
                                text = msg.message,
                                color = if (isShop) Color(0xFF1C1B1F) else TextPrimary,
                                fontSize = 13.sp
                            )
                        }
                    }
                }
            }
        }

        // Input Bar
        Surface(
            color = CardSurface,
            shadowElevation = 4.dp,
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = { }) {
                    Icon(Icons.Default.AttachFile, contentDescription = "Attach", tint = TextSecondary)
                }

                OutlinedTextField(
                    value = inputMessage,
                    onValueChange = { inputMessage = it },
                    placeholder = { Text("Type message...", color = TextSecondary) },
                    modifier = Modifier
                        .weight(1f)
                        .testTag("chat_input_text"),
                    shape = RoundedCornerShape(20.dp)
                )

                Spacer(modifier = Modifier.width(6.dp))

                IconButton(
                    onClick = {
                        if (inputMessage.isNotBlank()) {
                            val msg = inputMessage
                            inputMessage = ""
                            coroutineScope.launch(Dispatchers.IO) {
                                viewModel.repository.addChatMessage(
                                    ChatMessage(
                                        customerId = customer.id,
                                        sender = "SHOP",
                                        message = msg
                                    )
                                )
                            }
                        }
                    },
                    modifier = Modifier.testTag("send_chat_msg_button")
                ) {
                    Icon(Icons.AutoMirrored.Filled.Send, contentDescription = "Send", tint = PrimaryBlue)
                }
            }
        }
    }
}
