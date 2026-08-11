package com.example.ui

import android.app.Activity
import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.data.AppDatabase
import com.example.data.Customer
import com.example.data.CustomerOrder
import com.example.data.LedgerTransaction
import com.example.data.ShopProfile
import com.example.data.UdharRepository
import com.example.service.AuthRepository
import com.example.service.ParsedTransaction
import com.example.service.UserAuthProfile
import com.example.service.VoiceParserService
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

class UdharViewModel(application: Application) : AndroidViewModel(application) {

    val authRepository = AuthRepository(application)
    val currentUser: StateFlow<UserAuthProfile?> = authRepository.currentUser

    val isAuthLoading = MutableStateFlow(false)
    val authErrorMessage = MutableStateFlow<String?>(null)

    private val db = AppDatabase.getInstance(application)
    val repository = UdharRepository(
        db.shopDao(),
        db.customerDao(),
        db.ledgerDao(),
        db.orderDao(),
        db.chatDao()
    )

    val shopProfile = repository.shopProfile.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = null
    )

    val shopSummary = repository.shopSummary.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = null
    )

    val allCustomers = repository.allCustomers.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )

    val allTransactions = repository.allTransactions.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )

    init {
        viewModelScope.launch {
            currentUser.collect { user ->
                user?.uid?.let { uid ->
                    repository.syncFirestoreEntries(uid)
                }
            }
        }
    }

    val allOrders = repository.allOrders.stateIn(
        scope = viewModelScope,
        started = SharingStarted.WhileSubscribed(5000),
        initialValue = emptyList()
    )

    // UI States
    private val _selectedTab = MutableStateFlow("Home")
    val selectedTab: StateFlow<String> = _selectedTab.asStateFlow()

    private val _selectedCustomerId = MutableStateFlow<Int?>(null)
    val selectedCustomerId: StateFlow<Int?> = _selectedCustomerId.asStateFlow()

    private val _customerSearchQuery = MutableStateFlow("")
    val customerSearchQuery: StateFlow<String> = _customerSearchQuery.asStateFlow()

    private val _customerSortBy = MutableStateFlow("HighToLow") // HighToLow, LowToHigh, Name
    val customerSortBy: StateFlow<String> = _customerSortBy.asStateFlow()

    private val _transactionFilter = MutableStateFlow("ALL") // ALL, UDHAAR, PAYMENT, ADVANCE, REFUND
    val transactionFilter: StateFlow<String> = _transactionFilter.asStateFlow()

    // Dialog & Modal Controls
    val isAddUdharOpen = MutableStateFlow(false)
    val isReceivePaymentOpen = MutableStateFlow(false)
    val isAddAdvanceOpen = MutableStateFlow(false)
    val isVoiceEntryOpen = MutableStateFlow(false)
    val isVoiceConfirmationOpen = MutableStateFlow(false)
    val isAddCustomerOpen = MutableStateFlow(false)
    val isAddOrderOpen = MutableStateFlow(false)
    val isWhatsAppReminderOpen = MutableStateFlow(false)

    // Voice Processing State
    val parsedVoiceTransaction = MutableStateFlow<ParsedTransaction?>(null)
    val isVoiceListening = MutableStateFlow(false)

    fun selectTab(tab: String) {
        _selectedTab.value = tab
    }

    fun selectCustomer(customerId: Int?) {
        _selectedCustomerId.value = customerId
    }

    fun setSearchQuery(query: String) {
        _customerSearchQuery.value = query
    }

    fun setSortBy(sortBy: String) {
        _customerSortBy.value = sortBy
    }

    fun setTransactionFilter(filter: String) {
        _transactionFilter.value = filter
    }

    // Actions
    fun saveUdhar(customerId: Int, amount: Double, note: String, dateMillis: Long) {
        viewModelScope.launch {
            val uid = currentUser.value?.uid
            repository.addTransaction(
                LedgerTransaction(
                    customerId = customerId,
                    type = "UDHAAR",
                    amount = amount,
                    note = note,
                    dateMillis = dateMillis
                ),
                userId = uid
            )
            isAddUdharOpen.value = false
        }
    }

    fun savePayment(customerId: Int, amount: Double, method: String, reference: String) {
        viewModelScope.launch {
            val uid = currentUser.value?.uid
            repository.addTransaction(
                LedgerTransaction(
                    customerId = customerId,
                    type = "PAYMENT",
                    amount = amount,
                    paymentMethod = method,
                    reference = reference,
                    note = "Payment Received"
                ),
                userId = uid
            )
            isReceivePaymentOpen.value = false
        }
    }

    fun saveAdvance(customerId: Int, amount: Double, method: String, note: String) {
        viewModelScope.launch {
            val uid = currentUser.value?.uid
            repository.addTransaction(
                LedgerTransaction(
                    customerId = customerId,
                    type = "ADVANCE",
                    amount = amount,
                    paymentMethod = method,
                    note = if (note.isBlank()) "Advance Balance Received" else note
                ),
                userId = uid
            )
            isAddAdvanceOpen.value = false
        }
    }

    fun updateShopProfile(shopName: String, ownerName: String, phone: String, address: String, upiId: String, gstin: String = "") {
        viewModelScope.launch {
            repository.updateShopProfile(
                ShopProfile(
                    id = 1,
                    shopName = shopName,
                    ownerName = ownerName,
                    phone = phone,
                    location = address,
                    memberSince = "2023",
                    address = address,
                    upiId = upiId,
                    gstin = gstin
                )
            )
        }
    }

    fun saveCustomer(name: String, phone: String, location: String, risk: String) {
        viewModelScope.launch {
            repository.addCustomer(
                Customer(
                    name = name,
                    phone = phone,
                    location = location,
                    riskLevel = risk
                )
            )
            isAddCustomerOpen.value = false
        }
    }

    fun saveOrder(customerId: Int, itemsSummary: String, total: Double, advance: Double) {
        viewModelScope.launch {
            repository.addOrder(
                CustomerOrder(
                    customerId = customerId,
                    itemsSummary = itemsSummary,
                    totalAmount = total,
                    advancePaid = advance,
                    status = "CONFIRMED"
                )
            )
            isAddOrderOpen.value = false
        }
    }

    fun processVoiceText(spokenText: String) {
        viewModelScope.launch {
            isVoiceListening.value = true
            val parsed = VoiceParserService.parseVoiceCommand(spokenText, allCustomers.value)
            parsedVoiceTransaction.value = parsed
            isVoiceListening.value = false
            isVoiceEntryOpen.value = false
            isVoiceConfirmationOpen.value = true
        }
    }

    fun confirmVoiceTransaction(parsed: ParsedTransaction) {
        viewModelScope.launch {
            val customerId = parsed.matchedCustomerId ?: run {
                // If customer not matched, create new or use first customer
                allCustomers.value.firstOrNull()?.id ?: repository.addCustomer(
                    Customer(name = parsed.customerName, phone = "98765 00000", location = "Bhopal, MP")
                ).toInt()
            }

            repository.addTransaction(
                LedgerTransaction(
                    customerId = customerId,
                    type = parsed.transactionType,
                    amount = parsed.amount,
                    note = parsed.note
                )
            )
            isVoiceConfirmationOpen.value = false
        }
    }

    // Auth Actions
    fun loginWithEmail(email: String, password: String) {
        if (email.isBlank() || password.isBlank()) {
            authErrorMessage.value = "Please enter both email and password."
            return
        }
        viewModelScope.launch {
            isAuthLoading.value = true
            authErrorMessage.value = null
            val result = authRepository.loginWithEmail(email, password)
            isAuthLoading.value = false
            if (result.isFailure) {
                authErrorMessage.value = result.exceptionOrNull()?.message ?: "Login failed. Please check credentials."
            }
        }
    }

    fun registerWithEmail(name: String, email: String, password: String) {
        if (name.isBlank() || email.isBlank() || password.isBlank()) {
            authErrorMessage.value = "Please fill in all registration fields."
            return
        }
        if (password.length < 6) {
            authErrorMessage.value = "Password must be at least 6 characters long."
            return
        }
        viewModelScope.launch {
            isAuthLoading.value = true
            authErrorMessage.value = null
            val result = authRepository.registerWithEmail(name, email, password)
            isAuthLoading.value = false
            if (result.isFailure) {
                authErrorMessage.value = result.exceptionOrNull()?.message ?: "Registration failed."
            }
        }
    }

    fun signInWithGoogle(activity: Activity) {
        viewModelScope.launch {
            isAuthLoading.value = true
            authErrorMessage.value = null
            val result = authRepository.signInWithGoogle(activity)
            isAuthLoading.value = false
            if (result.isFailure) {
                authErrorMessage.value = result.exceptionOrNull()?.message ?: "Google Sign-In failed."
            }
        }
    }

    fun loginDemoUser(name: String, email: String, isGoogle: Boolean) {
        authRepository.loginDemoUser(name, email, isGoogle)
    }

    fun logout() {
        authRepository.clearUserLocal()
    }

    fun clearAuthError() {
        authErrorMessage.value = null
    }
}
