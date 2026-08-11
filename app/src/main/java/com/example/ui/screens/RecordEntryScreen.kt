package com.example.ui.screens

import android.app.DatePickerDialog
import android.widget.Toast
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.ArrowDownward
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Mic
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Receipt
import androidx.compose.material.icons.filled.Send
import androidx.compose.material.icons.filled.Stop
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
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.service.ParsedTransaction
import com.example.service.VoiceParserService
import com.example.ui.UdharViewModel
import com.example.ui.components.CustomerAvatar
import com.example.ui.theme.BackgroundSlate
import com.example.ui.theme.CardSurface
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
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

enum class TransactionTypeOption {
    UDHAAR, // Debt Given
    PAYMENT, // Payment Received
    ADVANCE  // Advance Given
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RecordEntryScreen(
    viewModel: UdharViewModel,
    initialCustomerId: Int? = null,
    onBackClick: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val coroutineScope = rememberCoroutineScope()
    val allCustomers by viewModel.allCustomers.collectAsState()

    // Form States
    var selectedCustomer by remember {
        mutableStateOf(allCustomers.find { it.id == initialCustomerId } ?: allCustomers.firstOrNull())
    }
    var transactionType by remember { mutableStateOf(TransactionTypeOption.UDHAAR) }
    var amountText by remember { mutableStateOf("") }
    var noteText by remember { mutableStateOf("") }
    var paymentMethod by remember { mutableStateOf("Cash") }
    var sendWhatsAppNotification by remember { mutableStateOf(true) }

    // Date State
    val calendar = remember { Calendar.getInstance() }
    val dateFormat = remember { SimpleDateFormat("dd MMM yyyy", Locale.getDefault()) }
    var selectedDateText by remember { mutableStateOf(dateFormat.format(calendar.time)) }
    var selectedDateMillis by remember { mutableStateOf(calendar.timeInMillis) }

    // Customer Dropdown state
    var dropdownExpanded by remember { mutableStateOf(false) }

    // Voice Detection Model State
    var isListeningVoice by remember { mutableStateOf(false) }
    var spokenVoiceInput by remember { mutableStateOf("") }
    var parsedVoiceResult by remember { mutableStateOf<ParsedTransaction?>(null) }
    var isVoiceAutoFilled by remember { mutableStateOf(false) }

    // Listening pulse animation
    val micPulse = remember { Animatable(1f) }
    LaunchedEffect(isListeningVoice) {
        if (isListeningVoice) {
            micPulse.animateTo(
                targetValue = 1.3f,
                animationSpec = infiniteRepeatable(
                    animation = tween(600, easing = LinearEasing),
                    repeatMode = RepeatMode.Reverse
                )
            )
        } else {
            micPulse.snapTo(1f)
        }
    }

    // Date Picker Dialog Launcher
    val datePickerDialog = remember {
        DatePickerDialog(
            context,
            { _, year, month, dayOfMonth ->
                calendar.set(year, month, dayOfMonth)
                selectedDateMillis = calendar.timeInMillis
                selectedDateText = dateFormat.format(calendar.time)
            },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        )
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
    ) {
        // Top Header Bar
        Surface(
            color = CardSurface,
            shadowElevation = 3.dp,
            modifier = Modifier.fillMaxWidth()
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                IconButton(onClick = onBackClick, modifier = Modifier.testTag("record_entry_back_btn")) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Back",
                        tint = TextPrimary
                    )
                }
                Spacer(modifier = Modifier.width(4.dp))
                Column {
                    Text(
                        text = "Record New Entry",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Text(
                        text = "Record debt given or payment received in ledger",
                        fontSize = 11.sp,
                        color = TextSecondary
                    )
                }
            }
        }

        // Scrollable Input Content
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // 🎙️ Voice Detection Model Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                colors = CardDefaults.cardColors(
                    containerColor = if (isListeningVoice) PrimaryBlueBg else CardSurface
                ),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Box(
                                modifier = Modifier
                                    .size(36.dp)
                                    .clip(CircleShape)
                                    .background(PrimaryBlue.copy(alpha = 0.2f)),
                                contentAlignment = Alignment.Center
                            ) {
                                Text("🎙️", fontSize = 18.sp)
                            }
                            Spacer(modifier = Modifier.width(10.dp))
                            Column {
                                Text(
                                    text = "Voice Detection Input",
                                    style = MaterialTheme.typography.titleSmall,
                                    fontWeight = FontWeight.Bold,
                                    color = TextPrimary
                                )
                                Text(
                                    text = "Speak entry details in Hindi / Hinglish / English",
                                    fontSize = 11.sp,
                                    color = TextSecondary
                                )
                            }
                        }

                        if (isVoiceAutoFilled) {
                            Surface(
                                color = GreenBg,
                                shape = RoundedCornerShape(8.dp)
                            ) {
                                Row(
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(Icons.Default.CheckCircle, contentDescription = null, tint = GreenAdvance, modifier = Modifier.size(12.dp))
                                    Spacer(modifier = Modifier.width(4.dp))
                                    Text("Auto-Filled", color = GreenAdvance, fontSize = 10.sp, fontWeight = FontWeight.Bold)
                                }
                            }
                        }
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    // Big Mic Recording Pulse Button
                    Box(
                        modifier = Modifier
                            .scale(micPulse.value)
                            .size(68.dp)
                            .clip(CircleShape)
                            .background(if (isListeningVoice) RedUdhar else PrimaryBlue)
                            .clickable {
                                if (isListeningVoice) {
                                    isListeningVoice = false
                                } else {
                                    isListeningVoice = true
                                    spokenVoiceInput = "Listening..."
                                    coroutineScope.launch {
                                        delay(1500)
                                        // Sample speech simulations or process input
                                        val samples = listOf(
                                            "Rahul ko 850 rupaye udhar diya grocery ke liye",
                                            "Amit se 1200 cash payment mila today",
                                            "Suresh ne 2000 rupaye advance diya"
                                        )
                                        spokenVoiceInput = samples.random()
                                        isListeningVoice = false

                                        // Parse with Gemini Voice Parser Model
                                        val parsed = VoiceParserService.parseVoiceCommand(spokenVoiceInput, allCustomers)
                                        parsedVoiceResult = parsed

                                        // Auto-fill form fields!
                                        parsed.matchedCustomerId?.let { id ->
                                            allCustomers.find { it.id == id }?.let { selectedCustomer = it }
                                        }
                                        if (parsed.amount > 0) {
                                            amountText = parsed.amount.toInt().toString()
                                        }
                                        if (parsed.note.isNotBlank()) {
                                            noteText = parsed.note
                                        }
                                        transactionType = when (parsed.transactionType) {
                                            "PAYMENT" -> TransactionTypeOption.PAYMENT
                                            "ADVANCE" -> TransactionTypeOption.ADVANCE
                                            else -> TransactionTypeOption.UDHAAR
                                        }
                                        isVoiceAutoFilled = true
                                        Toast.makeText(context, "Parsed: ${parsed.customerName} - ₹${parsed.amount.toInt()} (${parsed.transactionType})", Toast.LENGTH_SHORT).show()
                                    }
                                }
                            }
                            .testTag("voice_mic_button"),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = if (isListeningVoice) Icons.Default.Stop else Icons.Default.Mic,
                            contentDescription = "Voice Input Mic",
                            tint = Color.White,
                            modifier = Modifier.size(32.dp)
                        )
                    }

                    Spacer(modifier = Modifier.height(8.dp))

                    Text(
                        text = if (isListeningVoice) "Listening to voice... Speak now" else "Tap Mic to record entry with voice",
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Medium,
                        color = if (isListeningVoice) RedUdhar else PrimaryBlue
                    )

                    // Spoken command text box
                    if (spokenVoiceInput.isNotBlank()) {
                        Spacer(modifier = Modifier.height(10.dp))
                        Surface(
                            color = BackgroundSlate,
                            shape = RoundedCornerShape(10.dp),
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Text(
                                text = "🗣️ \"$spokenVoiceInput\"",
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Medium,
                                color = TextPrimary,
                                modifier = Modifier.padding(10.dp),
                                textAlign = TextAlign.Center
                            )
                        }
                    }

                    // Suggested Voice Prompts Chips
                    Spacer(modifier = Modifier.height(10.dp))
                    Text("Try speaking:", fontSize = 10.sp, color = TextSecondary)
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 4.dp),
                        horizontalArrangement = Arrangement.SpaceEvenly
                    ) {
                        listOf(
                            "Rahul 500 udhar",
                            "Amit 1000 cash",
                            "Suresh 2000 advance"
                        ).forEach { sample ->
                            Surface(
                                shape = RoundedCornerShape(12.dp),
                                color = PrimaryBlueBg,
                                modifier = Modifier.clickable {
                                    spokenVoiceInput = sample
                                    coroutineScope.launch {
                                        val parsed = VoiceParserService.parseVoiceCommand(sample, allCustomers)
                                        parsedVoiceResult = parsed
                                        parsed.matchedCustomerId?.let { id ->
                                            allCustomers.find { it.id == id }?.let { selectedCustomer = it }
                                        }
                                        if (parsed.amount > 0) amountText = parsed.amount.toInt().toString()
                                        if (parsed.note.isNotBlank()) noteText = parsed.note
                                        transactionType = when (parsed.transactionType) {
                                            "PAYMENT" -> TransactionTypeOption.PAYMENT
                                            "ADVANCE" -> TransactionTypeOption.ADVANCE
                                            else -> TransactionTypeOption.UDHAAR
                                        }
                                        isVoiceAutoFilled = true
                                    }
                                }
                            ) {
                                Text(
                                    text = "💡 $sample",
                                    fontSize = 10.sp,
                                    color = PrimaryBlue,
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                                )
                            }
                        }
                    }
                }
            }

            // 1. Transaction Type Segmented Toggle
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "1. Select Transaction Type",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(12.dp))
                            .background(BackgroundSlate)
                            .padding(4.dp),
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        // Udhar (Debt Given)
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(10.dp))
                                .background(if (transactionType == TransactionTypeOption.UDHAAR) RedUdhar else Color.Transparent)
                                .clickable {
                                    transactionType = TransactionTypeOption.UDHAAR
                                    isVoiceAutoFilled = false
                                }
                                .padding(vertical = 12.dp)
                                .testTag("type_udhaar"),
                            contentAlignment = Alignment.Center
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    Icons.Default.ArrowUpward,
                                    contentDescription = null,
                                    tint = if (transactionType == TransactionTypeOption.UDHAAR) Color(0xFF1C1B1F) else RedUdhar,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    text = "Udhar Given",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 12.sp,
                                    color = if (transactionType == TransactionTypeOption.UDHAAR) Color(0xFF1C1B1F) else RedUdhar
                                )
                            }
                        }

                        // Payment Received
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(10.dp))
                                .background(if (transactionType == TransactionTypeOption.PAYMENT) GreenAdvance else Color.Transparent)
                                .clickable {
                                    transactionType = TransactionTypeOption.PAYMENT
                                    isVoiceAutoFilled = false
                                }
                                .padding(vertical = 12.dp)
                                .testTag("type_payment"),
                            contentAlignment = Alignment.Center
                        ) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    Icons.Default.ArrowDownward,
                                    contentDescription = null,
                                    tint = if (transactionType == TransactionTypeOption.PAYMENT) Color.White else GreenAdvance,
                                    modifier = Modifier.size(16.dp)
                                )
                                Spacer(modifier = Modifier.width(4.dp))
                                Text(
                                    text = "Payment Recv",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 12.sp,
                                    color = if (transactionType == TransactionTypeOption.PAYMENT) Color.White else GreenAdvance
                                )
                            }
                        }

                        // Advance
                        Box(
                            modifier = Modifier
                                .weight(1f)
                                .clip(RoundedCornerShape(10.dp))
                                .background(if (transactionType == TransactionTypeOption.ADVANCE) OrangeMedium else Color.Transparent)
                                .clickable {
                                    transactionType = TransactionTypeOption.ADVANCE
                                    isVoiceAutoFilled = false
                                }
                                .padding(vertical = 12.dp)
                                .testTag("type_advance"),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = "Advance",
                                fontWeight = FontWeight.Bold,
                                fontSize = 12.sp,
                                color = if (transactionType == TransactionTypeOption.ADVANCE) Color(0xFF1C1B1F) else OrangeMedium
                            )
                        }
                    }
                }
            }

            // 2. Customer Selector Field
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "2. Select Customer",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    ExposedDropdownMenuBox(
                        expanded = dropdownExpanded,
                        onExpandedChange = { dropdownExpanded = !dropdownExpanded }
                    ) {
                        OutlinedTextField(
                            value = selectedCustomer?.name ?: "Select Customer",
                            onValueChange = {},
                            readOnly = true,
                            label = { Text("Customer Name") },
                            leadingIcon = {
                                if (selectedCustomer != null) {
                                    CustomerAvatar(name = selectedCustomer!!.name, modifier = Modifier.size(28.dp))
                                } else {
                                    Icon(Icons.Default.Person, contentDescription = null, tint = TextSecondary)
                                }
                            },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = dropdownExpanded) },
                            shape = RoundedCornerShape(12.dp),
                            modifier = Modifier
                                .menuAnchor()
                                .fillMaxWidth()
                                .testTag("select_customer_dropdown"),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = PrimaryBlue,
                                unfocusedBorderColor = TextSecondary.copy(alpha = 0.4f),
                                focusedLabelColor = PrimaryBlue,
                                unfocusedLabelColor = TextSecondary
                            )
                        )

                        ExposedDropdownMenu(
                            expanded = dropdownExpanded,
                            onDismissRequest = { dropdownExpanded = false }
                        ) {
                            allCustomers.forEach { cust ->
                                DropdownMenuItem(
                                    text = {
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            CustomerAvatar(name = cust.name, modifier = Modifier.size(24.dp))
                                            Spacer(modifier = Modifier.width(10.dp))
                                            Column {
                                                Text(cust.name, fontWeight = FontWeight.Bold, color = TextPrimary)
                                                Text("Phone: ${cust.phone} • ${cust.location}", fontSize = 11.sp, color = TextSecondary)
                                            }
                                        }
                                    },
                                    onClick = {
                                        selectedCustomer = cust
                                        dropdownExpanded = false
                                    }
                                )
                            }
                        }
                    }
                }
            }

            // 3. Amount Field & Quick Amount Chips
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "3. Amount (₹)",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = amountText,
                        onValueChange = { amountText = it },
                        label = { Text("Enter Amount in Rupees") },
                        leadingIcon = {
                            Text(
                                text = "₹",
                                fontSize = 22.sp,
                                fontWeight = FontWeight.Bold,
                                color = when (transactionType) {
                                    TransactionTypeOption.UDHAAR -> RedUdhar
                                    TransactionTypeOption.PAYMENT -> GreenAdvance
                                    TransactionTypeOption.ADVANCE -> OrangeMedium
                                }
                            )
                        },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("entry_amount_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.4f),
                            focusedLabelColor = PrimaryBlue,
                            unfocusedLabelColor = TextSecondary
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    // Quick Add Amount Chips
                    Text("Quick Amounts:", fontSize = 11.sp, color = TextSecondary)
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 4.dp),
                        horizontalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        listOf(50, 100, 500, 1000, 2000).forEach { chipAmt ->
                            Surface(
                                shape = RoundedCornerShape(8.dp),
                                color = PrimaryBlueBg,
                                modifier = Modifier.clickable {
                                    val current = amountText.toDoubleOrNull() ?: 0.0
                                    amountText = (current + chipAmt).toInt().toString()
                                }
                            ) {
                                Text(
                                    text = "+₹$chipAmt",
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = PrimaryBlue,
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
                                )
                            }
                        }
                    }
                }
            }

            // 4. Date Picker Selection
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "4. Date of Transaction",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = selectedDateText,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("Transaction Date") },
                        leadingIcon = {
                            Icon(Icons.Default.CalendarToday, contentDescription = null, tint = PrimaryBlue)
                        },
                        trailingIcon = {
                            IconButton(onClick = { datePickerDialog.show() }) {
                                Text("Change", color = PrimaryBlue, fontSize = 12.sp, fontWeight = FontWeight.Bold)
                            }
                        },
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { datePickerDialog.show() }
                            .testTag("entry_date_picker"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.4f),
                            focusedLabelColor = PrimaryBlue,
                            unfocusedLabelColor = TextSecondary
                        )
                    )

                    // Quick Date Chips
                    Spacer(modifier = Modifier.height(10.dp))
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        listOf("Today", "Yesterday", "2 Days Ago").forEach { dateLabel ->
                            Surface(
                                shape = RoundedCornerShape(8.dp),
                                color = PrimaryBlueBg,
                                modifier = Modifier.clickable {
                                    val cal = Calendar.getInstance()
                                    when (dateLabel) {
                                        "Yesterday" -> cal.add(Calendar.DAY_OF_YEAR, -1)
                                        "2 Days Ago" -> cal.add(Calendar.DAY_OF_YEAR, -2)
                                    }
                                    selectedDateMillis = cal.timeInMillis
                                    selectedDateText = dateFormat.format(cal.time)
                                }
                            ) {
                                Text(
                                    text = dateLabel,
                                    fontSize = 11.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = PrimaryBlue,
                                    modifier = Modifier.padding(horizontal = 10.dp, vertical = 6.dp)
                                )
                            }
                        }
                    }
                }
            }

            // 5. Note / Reference & Payment Method
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "5. Items / Note / Reference",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    OutlinedTextField(
                        value = noteText,
                        onValueChange = { noteText = it },
                        label = { Text("Note / Items Purchased") },
                        placeholder = { Text("e.g. 5kg Atta, 2L Cooking Oil") },
                        leadingIcon = {
                            Icon(Icons.Default.Receipt, contentDescription = null, tint = TextSecondary)
                        },
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("entry_note_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.4f),
                            focusedLabelColor = PrimaryBlue,
                            unfocusedLabelColor = TextSecondary
                        )
                    )

                    // Quick category chips
                    Spacer(modifier = Modifier.height(10.dp))
                    Text("Common Notes:", fontSize = 11.sp, color = TextSecondary)
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 4.dp),
                        horizontalArrangement = Arrangement.spacedBy(6.dp)
                    ) {
                        listOf("Grocery Items", "Milk & Dairy", "Vegetables", "UPI Payment", "Cash Deposit").forEach { noteSample ->
                            Surface(
                                shape = RoundedCornerShape(8.dp),
                                color = BackgroundSlate,
                                modifier = Modifier.clickable { noteText = noteSample }
                            ) {
                                Text(
                                    text = noteSample,
                                    fontSize = 10.sp,
                                    color = TextSecondary,
                                    modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                                )
                            }
                        }
                    }

                    if (transactionType == TransactionTypeOption.PAYMENT) {
                        Spacer(modifier = Modifier.height(14.dp))
                        Text("Payment Method:", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                        Spacer(modifier = Modifier.height(6.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            listOf("Cash", "UPI", "Bank Transfer").forEach { method ->
                                val isSel = paymentMethod == method
                                Surface(
                                    shape = RoundedCornerShape(8.dp),
                                    color = if (isSel) GreenAdvance else GreenBg,
                                    modifier = Modifier.clickable { paymentMethod = method }
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
                    }
                }
            }

            // WhatsApp Notification Switch
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("📲", fontSize = 20.sp)
                        Spacer(modifier = Modifier.width(10.dp))
                        Column {
                            Text("Send WhatsApp Receipt", fontWeight = FontWeight.Bold, fontSize = 13.sp, color = TextPrimary)
                            Text("Notify customer on WhatsApp immediately", fontSize = 11.sp, color = TextSecondary)
                        }
                    }
                    Switch(
                        checked = sendWhatsAppNotification,
                        onCheckedChange = { sendWhatsAppNotification = it },
                        colors = SwitchDefaults.colors(checkedThumbColor = PrimaryBlue)
                    )
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Save Entry Button
            Button(
                onClick = {
                    val amount = amountText.toDoubleOrNull() ?: 0.0
                    val customer = selectedCustomer

                    if (customer == null) {
                        Toast.makeText(context, "Please select a customer", Toast.LENGTH_SHORT).show()
                        return@Button
                    }
                    if (amount <= 0) {
                        Toast.makeText(context, "Please enter a valid amount", Toast.LENGTH_SHORT).show()
                        return@Button
                    }

                    when (transactionType) {
                        TransactionTypeOption.UDHAAR -> {
                            viewModel.saveUdhar(
                                customerId = customer.id,
                                amount = amount,
                                note = noteText.ifBlank { "Grocery Udhar" },
                                dateMillis = selectedDateMillis
                            )
                            Toast.makeText(context, "✅ Recorded Udhar of ₹${amount.toInt()} for ${customer.name}", Toast.LENGTH_SHORT).show()
                        }
                        TransactionTypeOption.PAYMENT -> {
                            viewModel.savePayment(
                                customerId = customer.id,
                                amount = amount,
                                method = paymentMethod,
                                reference = noteText.ifBlank { "Payment Received" }
                            )
                            Toast.makeText(context, "✅ Payment of ₹${amount.toInt()} received from ${customer.name}", Toast.LENGTH_SHORT).show()
                        }
                        TransactionTypeOption.ADVANCE -> {
                            viewModel.saveAdvance(
                                customerId = customer.id,
                                amount = amount,
                                method = paymentMethod,
                                note = noteText.ifBlank { "Advance Deposit" }
                            )
                            Toast.makeText(context, "✅ Advance of ₹${amount.toInt()} added for ${customer.name}", Toast.LENGTH_SHORT).show()
                        }
                    }

                    if (sendWhatsAppNotification) {
                        viewModel.isWhatsAppReminderOpen.value = true
                    }

                    onBackClick()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(52.dp)
                    .testTag("save_record_entry_btn"),
                shape = RoundedCornerShape(14.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = when (transactionType) {
                        TransactionTypeOption.UDHAAR -> RedUdhar
                        TransactionTypeOption.PAYMENT -> GreenAdvance
                        TransactionTypeOption.ADVANCE -> OrangeMedium
                    }
                )
            ) {
                Text(
                    text = when (transactionType) {
                        TransactionTypeOption.UDHAAR -> "Save Udhar Entry (₹${amountText.ifBlank { "0" }})"
                        TransactionTypeOption.PAYMENT -> "Save Payment Entry (₹${amountText.ifBlank { "0" }})"
                        TransactionTypeOption.ADVANCE -> "Save Advance Entry (₹${amountText.ifBlank { "0" }})"
                    },
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                    color = if (transactionType == TransactionTypeOption.PAYMENT) Color.White else Color(0xFF1C1B1F)
                )
            }

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}
