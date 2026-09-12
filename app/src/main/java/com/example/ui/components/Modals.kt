package com.example.ui.components

import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.Customer
import com.example.ui.theme.GreenAdvance
import com.example.ui.theme.PrimaryBlue
import java.util.Locale

@Composable
fun AddCustomerDialog(
    existingCustomers: List<Customer>,
    onDismiss: () -> Unit,
    onSave: (name: String, phone: String, location: String, risk: String) -> Unit
) {
    var name by remember { mutableStateOf("") }
    var phone by remember { mutableStateOf("") }
    var location by remember { mutableStateOf("Bhopal, MP") }
    var risk by remember { mutableStateOf("Low") }
    var validationError by remember { mutableStateOf<String?>(null) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Add New Customer", fontWeight = FontWeight.Bold) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                OutlinedTextField(
                    value = name,
                    onValueChange = {
                        name = it
                        validationError = null
                    },
                    label = { Text("Customer Name") },
                    modifier = Modifier.fillMaxWidth().testTag("add_cust_name_input")
                )

                OutlinedTextField(
                    value = phone,
                    onValueChange = {
                        phone = it
                        validationError = null
                    },
                    label = { Text("Mobile Number") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                    modifier = Modifier.fillMaxWidth().testTag("add_cust_phone_input")
                )

                validationError?.let { error ->
                    Text(error, color = MaterialTheme.colorScheme.error, fontSize = 12.sp)
                }

                OutlinedTextField(
                    value = location,
                    onValueChange = { location = it },
                    label = { Text("Location / City") },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val normalizedPhone = phone.filter(Char::isDigit)
                    val duplicatePhone = normalizedPhone.isNotEmpty() && existingCustomers.any {
                        it.phone.filter(Char::isDigit) == normalizedPhone
                    }

                    validationError = when {
                        name.isBlank() -> "Enter a customer name"
                        duplicatePhone -> "This mobile number is already assigned to a customer"
                        else -> null
                    }

                    if (validationError == null) {
                        onSave(name, phone, location, risk)
                        onDismiss()
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                modifier = Modifier.testTag("save_new_cust_button")
            ) {
                Text("Save Customer")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Cancel") }
        }
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddOrderDialog(
    customers: List<Customer>,
    onDismiss: () -> Unit,
    onSave: (customerId: Int, itemsSummary: String, total: Double, advance: Double) -> Unit
) {
    var selectedCust by remember { mutableStateOf(customers.firstOrNull()) }
    var itemsText by remember { mutableStateOf("Atta 5kg, Rice 2kg, Oil 1L") }
    var totalText by remember { mutableStateOf("750") }
    var advanceText by remember { mutableStateOf("200") }
    var expanded by remember { mutableStateOf(false) }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Create New Grocery Order", fontWeight = FontWeight.Bold) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
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
                    value = itemsText,
                    onValueChange = { itemsText = it },
                    label = { Text("Items / Grocery List") },
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = totalText,
                    onValueChange = { totalText = it },
                    label = { Text("Total Bill (₹)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth()
                )

                OutlinedTextField(
                    value = advanceText,
                    onValueChange = { advanceText = it },
                    label = { Text("Advance Paid (₹)") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val total = totalText.toDoubleOrNull() ?: 0.0
                    val adv = advanceText.toDoubleOrNull() ?: 0.0
                    selectedCust?.let { cust ->
                        if (total > 0) {
                            onSave(cust.id, itemsText, total, adv)
                            onDismiss()
                        }
                    }
                },
                colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue),
                modifier = Modifier.testTag("save_order_button")
            ) {
                Text("Create Order")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Cancel") }
        }
    )
}

@Composable
fun WhatsAppReminderDialog(
    customer: Customer?,
    shopName: String,
    outstandingAmount: Double,
    upiId: String,
    onDismiss: () -> Unit
) {
    val context = LocalContext.current
    val custName = customer?.name ?: "Customer"
    val formattedOutstanding = String.format(Locale.getDefault(), "%.0f", outstandingAmount)
    val upiDetails = upiId.trim().takeIf { it.contains("@") }?.let { savedUpiId ->
        val paymentLink = Uri.Builder()
            .scheme("upi")
            .authority("pay")
            .appendQueryParameter("pa", savedUpiId)
            .appendQueryParameter("pn", shopName)
            .appendQueryParameter("am", formattedOutstanding)
            .appendQueryParameter("cu", "INR")
            .build()
        "\nUPI ID: $savedUpiId\nPay now: $paymentLink"
    }.orEmpty()
    val reminderMsg = "Hello $custName,\n\nYour current outstanding balance at $shopName is Rs. $formattedOutstanding.$upiDetails\n\nPlease clear the pending amount when convenient via UPI or Cash.\n\nThank you!"

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("📱 Send WhatsApp Reminder", fontWeight = FontWeight.Bold) },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("Pre-filled WhatsApp message:", fontSize = 12.sp, color = Color(0xFF64748B))

                OutlinedTextField(
                    value = reminderMsg,
                    onValueChange = {},
                    readOnly = true,
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    val phoneDigits = customer?.phone?.filter(Char::isDigit).orEmpty()
                    if (phoneDigits.isEmpty()) {
                        Toast.makeText(context, "Customer mobile number is missing", Toast.LENGTH_SHORT).show()
                        return@Button
                    }
                    val whatsappNumber = if (phoneDigits.length == 10) "91$phoneDigits" else phoneDigits
                    val intent = Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("https://wa.me/$whatsappNumber?text=${Uri.encode(reminderMsg)}")
                    )
                    context.startActivity(intent)
                    onDismiss()
                },
                colors = ButtonDefaults.buttonColors(containerColor = GreenAdvance),
                modifier = Modifier.testTag("send_whatsapp_now")
            ) {
                Text("Send on WhatsApp")
            }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("Close") }
        }
    )
}
