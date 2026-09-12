package com.example.ui.components

import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ReceiptLong
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.service.ParsedTransaction
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.GreenBg
import com.example.ui.theme.OrangeBg
import com.example.ui.theme.OrangeMedium
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary

@Composable
fun CustomerAvatar(
    name: String,
    modifier: Modifier = Modifier,
    backgroundColor: Color = PrimaryBlueBg,
    textColor: Color = PrimaryBlue
) {
    val initials = name.split(" ")
        .mapNotNull { it.firstOrNull()?.uppercase() }
        .take(2)
        .joinToString("")
        .ifEmpty { "C" }

    Box(
        modifier = modifier
            .size(44.dp)
            .clip(CircleShape)
            .background(
                Brush.radialGradient(
                    colors = listOf(
                        backgroundColor.copy(alpha = 0.9f),
                        backgroundColor.copy(alpha = 0.6f)
                    )
                )
            )
            .border(
                1.dp,
                Brush.verticalGradient(
                    listOf(textColor.copy(alpha = 0.45f), textColor.copy(alpha = 0.12f))
                ),
                CircleShape
            ),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = initials,
            fontWeight = FontWeight.Bold,
            color = textColor,
            fontSize = 16.sp
        )
    }
}

@Composable
fun RiskBadge(riskLevel: String) {
    val (bgColor, textColor) = when (riskLevel) {
        "High" -> RedBg to RedUdhar
        "Medium" -> OrangeBg to OrangeMedium
        else -> GreenBg to GreenAdvance
    }

    Surface(
        color = bgColor.copy(alpha = 0.82f),
        shape = RoundedCornerShape(12.dp),
        modifier = Modifier.border(
            0.8.dp,
            textColor.copy(alpha = 0.45f),
            RoundedCornerShape(12.dp)
        )
    ) {
        Text(
            text = riskLevel,
            color = textColor,
            fontSize = 11.sp,
            fontWeight = FontWeight.Bold,
            modifier = Modifier.padding(horizontal = 9.dp, vertical = 3.dp)
        )
    }
}

@Composable
fun QuickActionButton(
    icon: ImageVector,
    label: String,
    tag: String,
    color: Color = PrimaryBlue,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = modifier
            .testTag(tag)
            .bouncyClickable(scaleDown = 0.92f, onClick = onClick)
            .padding(4.dp)
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .clip(CircleShape)
                .background(
                    Brush.verticalGradient(
                        colors = listOf(
                            color.copy(alpha = 0.22f),
                            color.copy(alpha = 0.08f)
                        )
                    )
                )
                .border(
                    1.dp,
                    Brush.verticalGradient(
                        listOf(color.copy(alpha = 0.55f), color.copy(alpha = 0.15f))
                    ),
                    CircleShape
                ),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = label,
                tint = color,
                modifier = Modifier.size(24.dp)
            )
        }
        Spacer(modifier = Modifier.height(6.dp))
        Text(
            text = label,
            fontSize = 11.sp,
            fontWeight = FontWeight.Medium,
            color = TextPrimary,
            textAlign = TextAlign.Center,
            maxLines = 2
        )
    }
}

// Add Udhar Dialog
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddUdharDialog(
    customers: List<Customer>,
    initialCustomerId: Int? = null,
    onDismiss: () -> Unit,
    onSave: (customerId: Int, amount: Double, note: String, dateMillis: Long) -> Unit
) {
    var selectedCust by remember { mutableStateOf(customers.find { it.id == initialCustomerId } ?: customers.firstOrNull()) }
    var amountText by remember { mutableStateOf("") }
    var noteText by remember { mutableStateOf("Grocery Items") }
    var expanded by remember { mutableStateOf(false) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.ArrowUpward, contentDescription = null, tint = RedUdhar)
                Spacer(modifier = Modifier.width(8.dp))
                Text("Add Udhar / Credit", fontWeight = FontWeight.Bold)
            }
        },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                // Customer Selector
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded }
                ) {
                    OutlinedTextField(
                        value = selectedCust?.name ?: "Select Customer",
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Customer") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                        modifier = Modifier.menuAnchor().fillMaxWidth()
                    )
                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        customers.forEach { cust ->
                            DropdownMenuItem(
                                text = { Text(cust.name) },
                                onClick = {
                                    selectedCust = cust
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                OutlinedTextField(
                    value = amountText,
                    onValueChange = { amountText = it },
                    label = { Text("Amount (₹)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth().testTag("add_udhar_amount_input")
                )

                OutlinedTextField(
                    value = noteText,
                    onValueChange = { noteText = it },
                    label = { Text("Note (Optional)") },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val amt = amountText.toDoubleOrNull() ?: 0.0
                    selectedCust?.let { cust ->
                        if (amt > 0) {
                            onSave(cust.id, amt, noteText, System.currentTimeMillis())
                            onDismiss()
                        }
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = RedUdhar),
                modifier = Modifier.testTag("save_udhar_button")
            ) {
                Text("Save Udhar")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

// Receive Payment Dialog
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ReceivePaymentDialog(
    customers: List<Customer>,
    initialCustomerId: Int? = null,
    onDismiss: () -> Unit,
    onSave: (customerId: Int, amount: Double, method: String, reference: String) -> Unit
) {
    var selectedCust by remember { mutableStateOf(customers.find { it.id == initialCustomerId } ?: customers.firstOrNull()) }
    var amountText by remember { mutableStateOf("") }
    var selectedMethod by remember { mutableStateOf("Cash") }
    var refText by remember { mutableStateOf("") }
    var expanded by remember { mutableStateOf(false) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.ArrowDownward, contentDescription = null, tint = GreenAdvance)
                Spacer(modifier = Modifier.width(8.dp))
                Text("Receive Payment", fontWeight = FontWeight.Bold)
            }
        },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded }
                ) {
                    OutlinedTextField(
                        value = selectedCust?.name ?: "Select Customer",
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Customer") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = expanded) },
                        modifier = Modifier.menuAnchor().fillMaxWidth()
                    )
                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        customers.forEach { cust ->
                            DropdownMenuItem(
                                text = { Text(cust.name) },
                                onClick = {
                                    selectedCust = cust
                                    expanded = false
                                }
                            )
                        }
                    }
                }

                OutlinedTextField(
                    value = amountText,
                    onValueChange = { amountText = it },
                    label = { Text("Amount (₹)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth().testTag("receive_payment_amount_input")
                )

                Text("Payment Method", style = MaterialTheme.typography.bodySmall)
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf("Cash", "UPI", "Bank Transfer").forEach { method ->
                        val isSel = selectedMethod == method
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            color = if (isSel) GreenAdvance else GreenBg,
                            modifier = Modifier
                                .bouncyClickable(scaleDown = 0.95f) { selectedMethod = method }
                                .border(
                                    0.8.dp,
                                    if (isSel) GreenAdvance else GreenAdvance.copy(alpha = 0.3f),
                                    RoundedCornerShape(8.dp)
                                )
                        ) {
                            Text(
                                text = method,
                                color = if (isSel) Color.White else GreenAdvance,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold,
                                modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp)
                            )
                        }
                    }
                }

                OutlinedTextField(
                    value = refText,
                    onValueChange = { refText = it },
                    label = { Text("Reference / Remark") },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val amt = amountText.toDoubleOrNull() ?: 0.0
                    selectedCust?.let { cust ->
                        if (amt > 0) {
                            onSave(cust.id, amt, selectedMethod, refText)
                            onDismiss()
                        }
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = GreenAdvance),
                modifier = Modifier.testTag("save_payment_button")
            ) {
                Text("Save Payment")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}

// Voice Entry Modal with Animated Audio Pulse Rings
@Composable
fun VoiceEntryModal(
    onDismiss: () -> Unit,
    onProcessVoice: (spokenText: String) -> Unit
) {
    var spokenInput by remember { mutableStateOf("") }
    val pulseTransition = rememberInfiniteTransition(label = "mic_pulse")

    val ringScale1 by pulseTransition.animateFloat(
        initialValue = 1.0f,
        targetValue = 1.35f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "ring_scale_1"
    )

    val ringAlpha1 by pulseTransition.animateFloat(
        initialValue = 0.45f,
        targetValue = 0.08f,
        animationSpec = infiniteRepeatable(
            animation = tween(1200, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "ring_alpha_1"
    )

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("🎙️ Voice Entry (Gemini AI)", fontWeight = FontWeight.Bold) },
        text = {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(16.dp),
                modifier = Modifier.fillMaxWidth()
            ) {
                Box(
                    modifier = Modifier
                        .size(100.dp),
                    contentAlignment = Alignment.Center
                ) {
                    // Outer animated pulse ring
                    Box(
                        modifier = Modifier
                            .size(90.dp)
                            .scale(ringScale1)
                            .clip(CircleShape)
                            .background(PrimaryBlue.copy(alpha = ringAlpha1))
                    )

                    // Inner mic core
                    Box(
                        modifier = Modifier
                            .size(68.dp)
                            .clip(CircleShape)
                            .background(
                                Brush.radialGradient(
                                    colors = listOf(
                                        PrimaryBlue.copy(alpha = 0.35f),
                                        PrimaryBlueBg
                                    )
                                )
                            )
                            .border(1.5.dp, PrimaryBlue.copy(alpha = 0.6f), CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.Mic,
                            contentDescription = "Voice Mic",
                            tint = PrimaryBlue,
                            modifier = Modifier.size(34.dp)
                        )
                    }
                }

                Text(
                    "Speak or type transaction in Hindi, Hinglish, or English",
                    style = MaterialTheme.typography.bodySmall,
                    color = TextSecondary,
                    textAlign = TextAlign.Center
                )

                OutlinedTextField(
                    value = spokenInput,
                    onValueChange = { spokenInput = it },
                    placeholder = { Text("e.g. Rahul ko 500 rupaye udhar diya") },
                    modifier = Modifier.fillMaxWidth().testTag("voice_input_field")
                )

                Surface(
                    color = Color.White.copy(alpha = 0.06f),
                    shape = RoundedCornerShape(10.dp),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = "Examples:\n• Rahul ko 500 rupaye udhar diya\n• Amit ne 1000 cash diya\n• Suresh ne 5000 advance diya",
                        fontSize = 11.sp,
                        color = TextSecondary,
                        modifier = Modifier.padding(8.dp)
                    )
                }
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    if (spokenInput.isNotBlank()) {
                        onProcessVoice(spokenInput)
                    } else {
                        onProcessVoice("Rahul ko 500 rupaye udhar diya grocery ke liye")
                    }
                    onDismiss()
                },
                colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                modifier = Modifier.testTag("process_voice_button")
            ) {
                Text("Process with AI")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Cancel") }
        }
    )
}

// Voice Confirmation Dialog
@Composable
fun VoiceConfirmationModal(
    parsed: ParsedTransaction,
    onDismiss: () -> Unit,
    onConfirm: (ParsedTransaction) -> Unit
) {
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Confirm AI Transaction", fontWeight = FontWeight.Bold) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("Parsed from: \"${parsed.rawSpokenText}\"", fontSize = 12.sp, color = TextSecondary)

                Card(
                    colors = CardDefaults.cardColors(containerColor = PrimaryBlueBg.copy(alpha = 0.7f)),
                    shape = RoundedCornerShape(14.dp),
                    modifier = Modifier
                        .fillMaxWidth()
                        .border(1.dp, PrimaryBlue.copy(alpha = 0.35f), RoundedCornerShape(14.dp))
                ) {
                    Column(modifier = Modifier.padding(14.dp)) {
                        Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                            Text("Customer:", fontWeight = FontWeight.Bold, fontSize = 13.sp, color = TextSecondary)
                            Text(parsed.customerName, fontWeight = FontWeight.Bold, color = PrimaryBlue, fontSize = 14.sp)
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                            Text("Transaction:", fontWeight = FontWeight.Bold, fontSize = 13.sp, color = TextSecondary)
                            Text(
                                parsed.transactionType,
                                fontWeight = FontWeight.Bold,
                                color = if (parsed.transactionType == "UDHAAR") RedUdhar else GreenAdvance,
                                fontSize = 13.sp
                            )
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                            Text("Amount:", fontWeight = FontWeight.Bold, fontSize = 13.sp, color = TextSecondary)
                            Text("₹${parsed.amount.toInt()}", fontWeight = FontWeight.Bold, color = TextPrimary, fontSize = 16.sp)
                        }
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                            Text("Note:", fontSize = 12.sp, color = TextSecondary)
                            Text(parsed.note, fontSize = 12.sp, color = TextPrimary)
                        }
                    }
                }
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    onConfirm(parsed)
                    onDismiss()
                },
                colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                modifier = Modifier.testTag("confirm_voice_save_button")
            ) {
                Text("Confirm & Save")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Cancel") }
        }
    )
}
