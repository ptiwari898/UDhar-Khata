package com.example.ui.screens

import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.Image
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
import androidx.compose.material.icons.automirrored.filled.ExitToApp
import androidx.compose.material.icons.filled.Business
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.CloudDone
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.QrCode2
import androidx.compose.material.icons.filled.Save
import androidx.compose.material.icons.filled.Security
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.ShopProfile
import com.example.ui.UdharViewModel
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
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.common.BitMatrix
import coil.compose.AsyncImage

@Composable
fun ProfileScreen(
    profile: ShopProfile?,
    viewModel: UdharViewModel,
    onBackClick: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    val context = LocalContext.current
    val currentUser by viewModel.currentUser.collectAsState()
    val allCustomers by viewModel.allCustomers.collectAsState()
    val allOrders by viewModel.allOrders.collectAsState()

    var shopNameText by remember(profile) { mutableStateOf(profile?.shopName.orEmpty()) }
    var ownerNameText by remember(profile) { mutableStateOf(profile?.ownerName ?: currentUser?.name.orEmpty()) }
    var phoneText by remember(profile) { mutableStateOf(profile?.phone.orEmpty()) }
    var emailText by remember(profile) { mutableStateOf(profile?.email ?: currentUser?.email.orEmpty()) }
    var addressText by remember(profile) { mutableStateOf(profile?.address.orEmpty()) }
    var upiIdText by remember(profile) { mutableStateOf(profile?.upiId.orEmpty()) }
    var gstinText by remember(profile) { mutableStateOf(profile?.gstin.orEmpty()) }
    var photoUriText by remember(profile) { mutableStateOf(profile?.photoUri.orEmpty()) }

    var isEditing by remember(profile) { mutableStateOf(profile == null) }
    val photoPicker = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
        uri?.let {
            context.contentResolver.takePersistableUriPermission(it, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            photoUriText = it.toString()
        }
    }
    val upiQrCode = remember(upiIdText, shopNameText) {
        createUpiQrCode(upiIdText, shopNameText)
    }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(BackgroundSlate)
    ) {
        // Top Header
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
                IconButton(onClick = onBackClick, modifier = Modifier.testTag("profile_back_btn")) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Back",
                        tint = TextPrimary
                    )
                }
                Spacer(modifier = Modifier.width(4.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "Merchant Profile & Settings",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Text(
                        text = "Manage business details, QR code, and cloud sync",
                        fontSize = 11.sp,
                        color = TextSecondary
                    )
                }

                IconButton(
                    onClick = { isEditing = !isEditing },
                    modifier = Modifier.testTag("toggle_edit_profile_btn")
                ) {
                    Icon(
                        imageVector = if (isEditing) Icons.Default.Save else Icons.Default.Edit,
                        contentDescription = "Edit Profile",
                        tint = PrimaryBlue
                    )
                }
            }
        }

        // Scrollable Content
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Profile Summary Header Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(20.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Box(
                        modifier = Modifier
                            .size(68.dp)
                            .clip(CircleShape)
                            .background(PrimaryBlueBg),
                        contentAlignment = Alignment.Center
                    ) {
                        if (photoUriText.isNotBlank()) {
                            AsyncImage(
                                model = photoUriText,
                                contentDescription = "Shop photo",
                                modifier = Modifier.fillMaxSize().clip(CircleShape)
                            )
                        } else {
                            Icon(Icons.Default.Business, contentDescription = "Shop photo", tint = PrimaryBlue, modifier = Modifier.size(32.dp))
                        }
                    }

                    Spacer(modifier = Modifier.width(16.dp))

                    Column(modifier = Modifier.weight(1f)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text(
                                text = ownerNameText,
                                style = MaterialTheme.typography.titleMedium,
                                fontWeight = FontWeight.Bold,
                                color = TextPrimary
                            )
                            Spacer(modifier = Modifier.width(6.dp))
                            Icon(
                                Icons.Default.CheckCircle,
                                contentDescription = "Verified Merchant",
                                tint = GreenAdvance,
                                modifier = Modifier.size(16.dp)
                            )
                        }

                        Text(
                            text = shopNameText,
                            fontSize = 13.sp,
                            color = PrimaryBlue,
                            fontWeight = FontWeight.SemiBold
                        )

                        Spacer(modifier = Modifier.height(4.dp))

                        Surface(
                            color = if (currentUser?.isGoogleUser == true) PrimaryBlueBg else GreenBg,
                            shape = RoundedCornerShape(8.dp)
                        ) {
                            Text(
                                text = if (currentUser?.isGoogleUser == true) "Google Auth Account" else "Phone Verified Account",
                                fontSize = 10.sp,
                                fontWeight = FontWeight.Bold,
                                color = if (currentUser?.isGoogleUser == true) PrimaryBlue else GreenAdvance,
                                modifier = Modifier.padding(horizontal = 8.dp, vertical = 2.dp)
                            )
                        }
                    }
                }
            }

            // Editable Shop Information Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Business Details",
                            style = MaterialTheme.typography.titleSmall,
                            fontWeight = FontWeight.Bold,
                            color = TextPrimary
                        )

                        if (!isEditing) {
                            Text(
                                text = "Tap Edit above to change",
                                fontSize = 11.sp,
                                color = TextSecondary
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(14.dp))

                    // Shop Name
                    OutlinedTextField(
                        value = shopNameText,
                        onValueChange = { shopNameText = it },
                        readOnly = !isEditing,
                        label = { Text("Shop Name") },
                        leadingIcon = { Icon(Icons.Default.Business, contentDescription = null, tint = PrimaryBlue) },
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_shop_name_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    // Owner Name
                    OutlinedTextField(
                        value = ownerNameText,
                        onValueChange = { ownerNameText = it },
                        readOnly = !isEditing,
                        label = { Text("Owner / Merchant Name") },
                        leadingIcon = { Icon(Icons.Default.Person, contentDescription = null, tint = PrimaryBlue) },
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_owner_name_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    // Mobile Number
                    OutlinedTextField(
                        value = phoneText,
                        onValueChange = { phoneText = it },
                        readOnly = !isEditing,
                        label = { Text("Business Mobile Number") },
                        leadingIcon = { Icon(Icons.Default.Phone, contentDescription = null, tint = PrimaryBlue) },
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_phone_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    OutlinedTextField(
                        value = emailText,
                        onValueChange = { emailText = it },
                        readOnly = !isEditing,
                        label = { Text("Business Email") },
                        leadingIcon = { Icon(Icons.Default.Email, contentDescription = null, tint = PrimaryBlue) },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth().testTag("profile_email_input")
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    // Address
                    OutlinedTextField(
                        value = addressText,
                        onValueChange = { addressText = it },
                        readOnly = !isEditing,
                        label = { Text("Shop Address") },
                        leadingIcon = { Icon(Icons.Default.LocationOn, contentDescription = null, tint = PrimaryBlue) },
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_address_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    if (isEditing) {
                        TextButton(
                            onClick = { photoPicker.launch(arrayOf("image/*")) },
                            modifier = Modifier.testTag("select_shop_photo_button")
                        ) {
                            Icon(Icons.Default.Business, contentDescription = null)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(if (photoUriText.isBlank()) "Select Shop Photo" else "Change Shop Photo")
                        }
                    }

                    // UPI ID
                    OutlinedTextField(
                        value = upiIdText,
                        onValueChange = { upiIdText = it },
                        readOnly = !isEditing,
                        label = { Text("Merchant UPI ID (For Payments)") },
                        leadingIcon = { Icon(Icons.Default.QrCode2, contentDescription = null, tint = PrimaryBlue) },
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_upi_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    // GSTIN
                    OutlinedTextField(
                        value = gstinText,
                        onValueChange = { gstinText = it },
                        readOnly = !isEditing,
                        label = { Text("GSTIN Number (Optional)") },
                        leadingIcon = { Icon(Icons.Default.Security, contentDescription = null, tint = PrimaryBlue) },
                        singleLine = true,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .fillMaxWidth()
                            .testTag("profile_gstin_input"),
                        colors = OutlinedTextFieldDefaults.colors(
                            focusedBorderColor = PrimaryBlue,
                            unfocusedBorderColor = TextSecondary.copy(alpha = 0.3f)
                        )
                    )

                    if (isEditing) {
                        Spacer(modifier = Modifier.height(14.dp))
                        Button(
                            onClick = {
                                if (shopNameText.isBlank() || phoneText.filter(Char::isDigit).length < 10 ||
                                    !emailText.contains("@") || addressText.isBlank() || photoUriText.isBlank()) {
                                    Toast.makeText(context, "Add shop name, mobile number, email, address, and shop photo", Toast.LENGTH_LONG).show()
                                    return@Button
                                }
                                viewModel.updateShopProfile(
                                    shopName = shopNameText,
                                    ownerName = ownerNameText.ifBlank { shopNameText },
                                    phone = phoneText,
                                    address = addressText,
                                    upiId = upiIdText,
                                    gstin = gstinText,
                                    email = emailText,
                                    photoUri = photoUriText
                                )
                                isEditing = false
                                Toast.makeText(context, "✅ Shop profile updated successfully!", Toast.LENGTH_SHORT).show()
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp)
                                .testTag("save_profile_btn"),
                            shape = RoundedCornerShape(12.dp),
                            colors = ButtonDefaults.buttonColors(containerColor = PrimaryBlue)
                        ) {
                            Icon(Icons.Default.Save, contentDescription = null, tint = Color.White)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Save Changes", fontWeight = FontWeight.Bold, color = Color.White)
                        }
                    }
                }
            }

            // QR Code Payment Acceptor
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface),
                elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = "Accept Payment via UPI QR",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                    Text(
                        text = "Show this QR to customers to receive direct payments",
                        fontSize = 11.sp,
                        color = TextSecondary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Surface(
                        color = BackgroundSlate,
                        shape = RoundedCornerShape(12.dp),
                        modifier = Modifier
                            .size(160.dp)
                            .padding(4.dp)
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            if (upiQrCode != null) {
                                Image(
                                    bitmap = upiQrCode.asImageBitmap(),
                                    contentDescription = "UPI payment QR code",
                                    modifier = Modifier.size(152.dp)
                                )
                            } else {
                                Text(
                                    text = "Add a valid UPI ID to create your payment QR",
                                    fontSize = 12.sp,
                                    color = TextSecondary,
                                    modifier = Modifier.padding(16.dp)
                                )
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = upiIdText.ifBlank { "No default UPI ID saved" },
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )
                }
            }

            // Cloud Sync & App Stats
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CardSurface)
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "Cloud Backup & System Info",
                        style = MaterialTheme.typography.titleSmall,
                        fontWeight = FontWeight.Bold,
                        color = TextPrimary
                    )

                    Spacer(modifier = Modifier.height(12.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.CloudDone, contentDescription = null, tint = GreenAdvance, modifier = Modifier.size(20.dp))
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Firebase Firestore Backup", fontSize = 12.sp, fontWeight = FontWeight.Medium, color = TextPrimary)
                        }
                        Surface(color = GreenBg, shape = RoundedCornerShape(6.dp)) {
                            Text("SYNCED", color = GreenAdvance, fontSize = 10.sp, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 6.dp, vertical = 2.dp))
                        }
                    }

                    Spacer(modifier = Modifier.height(10.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Total Active Customers:", fontSize = 12.sp, color = TextSecondary)
                        Text("${allCustomers.size}", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                    }

                    Spacer(modifier = Modifier.height(6.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Total Orders Recorded:", fontSize = 12.sp, color = TextSecondary)
                        Text("${allOrders.size}", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = TextPrimary)
                    }
                }
            }

            // Logout Button
            Button(
                onClick = { viewModel.logout() },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(48.dp)
                    .testTag("logout_profile_btn"),
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = RedBg)
            ) {
                Icon(Icons.AutoMirrored.Filled.ExitToApp, contentDescription = null, tint = RedUdhar)
                Spacer(modifier = Modifier.width(8.dp))
                Text("Logout / Sign Out Account", fontWeight = FontWeight.Bold, color = RedUdhar)
            }

            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

private fun createUpiQrCode(upiId: String, shopName: String): Bitmap? {
    val normalizedUpiId = upiId.trim()
    if (normalizedUpiId.isEmpty() || !normalizedUpiId.contains("@")) return null

    val paymentUri = "upi://pay?pa=${Uri.encode(normalizedUpiId)}&pn=${Uri.encode(shopName.trim())}&cu=INR"
    val matrix = MultiFormatWriter().encode(paymentUri, BarcodeFormat.QR_CODE, 512, 512)
    return matrix.toBitmap()
}

private fun BitMatrix.toBitmap(): Bitmap {
    val pixels = IntArray(width * height) { index ->
        if (get(index % width, index / width)) android.graphics.Color.BLACK else android.graphics.Color.WHITE
    }
    return Bitmap.createBitmap(pixels, width, height, Bitmap.Config.ARGB_8888)
}
