package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Assessment
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.Person
import androidx.compose.material.icons.filled.People
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
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
import com.example.ui.screens.ReportsScreen
import com.example.ui.theme.PrimaryBlue
import com.example.ui.theme.UdharKhataTheme

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

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        bottomBar = {
            if (selectedCustomerId == null && !isViewingStatement && !isViewingChat) {
                NavigationBar(
                    containerColor = com.example.ui.theme.CardSurface,
                    tonalElevation = 8.dp
                ) {
                    val navItems = listOf(
                        Triple("Home", Icons.Default.Home, "nav_home"),
                        Triple("Customers", Icons.Default.People, "nav_customers"),
                        Triple("Orders", Icons.Default.ShoppingCart, "nav_orders"),
                        Triple("Reports", Icons.Default.Assessment, "nav_reports"),
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
                                indicatorColor = com.example.ui.theme.PrimaryBlueBg,
                                unselectedIconColor = com.example.ui.theme.TextSecondary,
                                unselectedTextColor = com.example.ui.theme.TextSecondary
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

                    else -> { // Home or Profile
                        DashboardScreen(
                            summary = shopSummary,
                            profile = shopProfile,
                            viewModel = viewModel,
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
