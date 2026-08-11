package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.background
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ExitToApp
import androidx.compose.material.icons.filled.AddCircle
import androidx.compose.material.icons.filled.Assessment
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.People
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.NavigationDrawerItem
import androidx.compose.material3.NavigationDrawerItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.UdharViewModel
import com.example.ui.components.AddCustomerDialog
import com.example.ui.components.AddOrderDialog
import com.example.ui.components.AddUdharDialog
import com.example.ui.components.ReceivePaymentDialog
import com.example.ui.components.VoiceConfirmationModal
import com.example.ui.components.VoiceEntryModal
import com.example.ui.components.WhatsAppReminderDialog
import com.example.ui.screens.AuthScreen
import com.example.ui.screens.CustomerChatScreen
import com.example.ui.screens.CustomerDetailScreen
import com.example.ui.screens.CustomerListScreen
import com.example.ui.screens.CustomerStatementScreen
import com.example.ui.screens.DashboardScreen
import com.example.ui.screens.OrdersScreen
import com.example.ui.screens.ProfileScreen
import com.example.ui.screens.RecordEntryScreen
import com.example.ui.screens.ReportsScreen
import com.example.ui.theme.CardSurface
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.PrimaryBlueBg
import com.example.ui.theme.RedUdhar
import com.example.ui.theme.TextPrimary
import com.example.ui.theme.TextSecondary
import com.example.ui.theme.UdharKhataTheme
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    private val viewModel: UdharViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            UdharKhataTheme {
                UdharKhataApp(viewModel = viewModel)
            }
        }
    }
}

@Composable
fun UdharKhataApp(viewModel: UdharViewModel) {
    val currentUser by viewModel.currentUser.collectAsState()

    if (currentUser == null) {
        AuthScreen(viewModel = viewModel)
        return
    }

    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val coroutineScope = rememberCoroutineScope()

    val selectedTab by viewModel.selectedTab.collectAsState()
    val selectedCustomerId by viewModel.selectedCustomerId.collectAsState()
    val shopSummary by viewModel.shopSummary.collectAsState()
    val shopProfile by viewModel.shopProfile.collectAsState()
    val allCustomers by viewModel.allCustomers.collectAsState()
    val allTransactions by viewModel.allTransactions.collectAsState()
    val searchQuery by viewModel.customerSearchQuery.collectAsState()
    val sortBy by viewModel.customerSortBy.collectAsState()

    // Screen States
    var isViewingStatement by remember { mutableStateOf(false) }
    var isViewingChat by remember { mutableStateOf(false) }

    // Dialog States
    val showAddUdhar by viewModel.isAddUdharOpen.collectAsState()
    val showReceivePayment by viewModel.isReceivePaymentOpen.collectAsState()
    val showAddAdvance by viewModel.isAddAdvanceOpen.collectAsState()
    val showVoiceEntry by viewModel.isVoiceEntryOpen.collectAsState()
    val showVoiceConfirm by viewModel.isVoiceConfirmationOpen.collectAsState()
    val showAddCustomer by viewModel.isAddCustomerOpen.collectAsState()
    val showAddOrder by viewModel.isAddOrderOpen.collectAsState()
    val showWhatsAppReminder by viewModel.isWhatsAppReminderOpen.collectAsState()
    val parsedVoice by viewModel.parsedVoiceTransaction.collectAsState()

    val currentCustomer = allCustomers.find { it.id == selectedCustomerId }

    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet(
                drawerContainerColor = CardSurface,
                modifier = Modifier.width(300.dp)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(PrimaryBlue)
                        .padding(20.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(
                            modifier = Modifier
                                .size(50.dp)
                                .clip(CircleShape)
                                .background(Color.White),
                            contentAlignment = Alignment.Center
                        ) {
                            Text("🏪", fontSize = 24.sp)
                        }
                        Spacer(modifier = Modifier.width(12.dp))
                        Column {
                            Text(
                                text = shopProfile?.shopName ?: "Shivam Kirana Store",
                                color = Color.White,
                                fontWeight = FontWeight.Bold,
                                fontSize = 16.sp
                            )
                            Text(
                                text = currentUser?.name ?: shopProfile?.ownerName ?: "Merchant",
                                color = Color.White.copy(alpha = 0.8f),
                                fontSize = 12.sp
                            )
                        }
                    }
                    Spacer(modifier = Modifier.height(10.dp))
                    Surface(
                        color = Color.White.copy(alpha = 0.2f),
                        shape = RoundedCornerShape(8.dp)
                    ) {
                        Text(
                            text = currentUser?.email ?: "merchant@udharkhata.com",
                            color = Color.White,
                            fontSize = 11.sp,
                            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                        )
                    }
                }

                Spacer(modifier = Modifier.height(12.dp))

                val drawerMenuItems = listOf(
                    Triple("Home", Icons.Default.Home, "drawer_home"),
                    Triple("Record Entry", Icons.Default.AddCircle, "drawer_record"),
                    Triple("Customers", Icons.Default.People, "drawer_customers"),
                    Triple("Orders", Icons.Default.ShoppingCart, "drawer_orders"),
                    Triple("Reports", Icons.Default.Assessment, "drawer_reports"),
                    Triple("Profile", Icons.Default.Person, "drawer_profile")
                )

                drawerMenuItems.forEach { (title, icon, tag) ->
                    val isSelected = selectedTab == title
                    NavigationDrawerItem(
                        icon = { Icon(icon, contentDescription = title, tint = if (isSelected) PrimaryBlue else TextSecondary) },
                        label = { Text(title, fontWeight = if (isSelected) FontWeight.Bold else FontWeight.Medium, color = if (isSelected) PrimaryBlue else TextPrimary) },
                        selected = isSelected,
                        onClick = {
                            viewModel.selectTab(title)
                            coroutineScope.launch { drawerState.close() }
                        },
                        colors = NavigationDrawerItemDefaults.colors(
                            selectedContainerColor = PrimaryBlueBg,
                            unselectedContainerColor = Color.Transparent
                        ),
                        modifier = Modifier
                            .padding(horizontal = 12.dp, vertical = 2.dp)
                            .testTag(tag)
                    )
                }

                HorizontalDivider(modifier = Modifier.padding(vertical = 12.dp), color = TextSecondary.copy(alpha = 0.2f))

                NavigationDrawerItem(
                    icon = { Icon(Icons.AutoMirrored.Filled.ExitToApp, contentDescription = "Logout", tint = RedUdhar) },
                    label = { Text("Logout Account", color = RedUdhar, fontWeight = FontWeight.Bold) },
                    selected = false,
                    onClick = {
                        coroutineScope.launch { drawerState.close() }
                        viewModel.logout()
                    },
                    modifier = Modifier
                        .padding(horizontal = 12.dp)
                        .testTag("drawer_logout")
                )
            }
        }
    ) {
        Scaffold(
            modifier = Modifier.fillMaxSize(),
            bottomBar = {
                if (selectedCustomerId == null && !isViewingStatement && !isViewingChat) {
                    NavigationBar(
                        containerColor = CardSurface,
                        tonalElevation = 8.dp
                    ) {
                        val navItems = listOf(
                            Triple("Home", Icons.Default.Home, "nav_home"),
                            Triple("Record Entry", Icons.Default.AddCircle, "nav_entry"),
                            Triple("Customers", Icons.Default.People, "nav_customers"),
                            Triple("Orders", Icons.Default.ShoppingCart, "nav_orders"),
                            Triple("Profile", Icons.Default.Person, "nav_profile")
                        )

                        navItems.forEach { (title, icon, tag) ->
                            val isSelected = selectedTab == title
                            NavigationBarItem(
                                selected = isSelected,
                                onClick = { viewModel.selectTab(title) },
                                icon = { Icon(icon, contentDescription = title) },
                                label = { Text(title, fontSize = 10.sp) },
                                colors = NavigationBarItemDefaults.colors(
                                    selectedIconColor = PrimaryBlue,
                                    selectedTextColor = PrimaryBlue,
                                    indicatorColor = PrimaryBlueBg,
                                    unselectedIconColor = TextSecondary,
                                    unselectedTextColor = TextSecondary
                                ),
                                modifier = Modifier.testTag(tag)
                            )
                        }
                    }
                }
            }
        ) { innerPadding ->
            when {
                // 1. Customer Statement Screen
                isViewingStatement && currentCustomer != null -> {
                    val custTxns = allTransactions.filter { it.customerId == currentCustomer.id }
                    CustomerStatementScreen(
                        customer = currentCustomer,
                        transactions = custTxns,
                        onBackClick = { isViewingStatement = false },
                        modifier = Modifier.padding(innerPadding)
                    )
                }

                // 2. Customer Chat Screen
                isViewingChat && currentCustomer != null -> {
                    CustomerChatScreen(
                        customer = currentCustomer,
                        viewModel = viewModel,
                        onBackClick = { isViewingChat = false },
                        modifier = Modifier.padding(innerPadding)
                    )
                }

                // 3. Customer Detail Screen (Overview / Ledger)
                selectedCustomerId != null && currentCustomer != null -> {
                    val custTxns = allTransactions.filter { it.customerId == currentCustomer.id }
                    CustomerDetailScreen(
                        customer = currentCustomer,
                        transactions = custTxns,
                        viewModel = viewModel,
                        onBackClick = { viewModel.selectCustomer(null) },
                        onChatClick = { isViewingChat = true },
                        onStatementClick = { isViewingStatement = true },
                        modifier = Modifier.padding(innerPadding)
                    )
                }

                // 4. Main Tab Navigation Screens
                else -> {
                    when (selectedTab) {
                        "Profile" -> {
                            ProfileScreen(
                                profile = shopProfile,
                                viewModel = viewModel,
                                onBackClick = { viewModel.selectTab("Home") },
                                modifier = Modifier.padding(innerPadding)
                            )
                        }

                        "Record Entry" -> {
                            RecordEntryScreen(
                                viewModel = viewModel,
                                initialCustomerId = selectedCustomerId,
                                onBackClick = { viewModel.selectTab("Home") },
                                modifier = Modifier.padding(innerPadding)
                            )
                        }

                        "Customers" -> {
                            CustomerListScreen(
                                summary = shopSummary,
                                searchQuery = searchQuery,
                                sortBy = sortBy,
                                viewModel = viewModel,
                                onCustomerClick = { id -> viewModel.selectCustomer(id) },
                                modifier = Modifier.padding(innerPadding)
                            )
                        }

                        "Orders" -> {
                            OrdersScreen(
                                viewModel = viewModel,
                                modifier = Modifier.padding(innerPadding)
                            )
                        }

                        "Reports" -> {
                            ReportsScreen(
                                summary = shopSummary,
                                viewModel = viewModel,
                                modifier = Modifier.padding(innerPadding)
                            )
                        }

                        else -> { // Home / Dashboard
                            DashboardScreen(
                                summary = shopSummary,
                                profile = shopProfile,
                                viewModel = viewModel,
                                onOpenDrawer = { coroutineScope.launch { drawerState.open() } },
                                modifier = Modifier.padding(innerPadding)
                            )
                        }
                    }
                }
            }

            // --- Dialog Overlays ---
            if (showAddUdhar) {
                AddUdharDialog(
                    customers = allCustomers,
                    initialCustomerId = selectedCustomerId,
                    onDismiss = { viewModel.isAddUdharOpen.value = false },
                    onSave = { custId, amt, note, dateMillis ->
                        viewModel.saveUdhar(custId, amt, note, dateMillis)
                    }
                )
            }

            if (showReceivePayment) {
                ReceivePaymentDialog(
                    customers = allCustomers,
                    initialCustomerId = selectedCustomerId,
                    onDismiss = { viewModel.isReceivePaymentOpen.value = false },
                    onSave = { custId, amt, method, ref ->
                        viewModel.savePayment(custId, amt, method, ref)
                    }
                )
            }

            if (showAddAdvance) {
                AddUdharDialog(
                    customers = allCustomers,
                    initialCustomerId = selectedCustomerId,
                    onDismiss = { viewModel.isAddAdvanceOpen.value = false },
                    onSave = { custId, amt, note, _ ->
                        viewModel.saveAdvance(custId, amt, "Cash", note)
                    }
                )
            }

            if (showVoiceEntry) {
                VoiceEntryModal(
                    onDismiss = { viewModel.isVoiceEntryOpen.value = false },
                    onProcessVoice = { text -> viewModel.processVoiceText(text) }
                )
            }

            if (showVoiceConfirm && parsedVoice != null) {
                VoiceConfirmationModal(
                    parsed = parsedVoice!!,
                    onDismiss = { viewModel.isVoiceConfirmationOpen.value = false },
                    onConfirm = { parsed -> viewModel.confirmVoiceTransaction(parsed) }
                )
            }

            if (showAddCustomer) {
                AddCustomerDialog(
                    onDismiss = { viewModel.isAddCustomerOpen.value = false },
                    onSave = { name, phone, loc, risk -> viewModel.saveCustomer(name, phone, loc, risk) }
                )
            }

            if (showAddOrder) {
                AddOrderDialog(
                    customers = allCustomers,
                    onDismiss = { viewModel.isAddOrderOpen.value = false },
                    onSave = { custId, items, total, adv -> viewModel.saveOrder(custId, items, total, adv) }
                )
            }

            if (showWhatsAppReminder) {
                WhatsAppReminderDialog(
                    customer = currentCustomer,
                    onDismiss = { viewModel.isWhatsAppReminderOpen.value = false }
                )
            }
        }
    }
}

