# 📒 Udhar Khata (उधार खाता)

<div align="center">

![Udhar Khata Logo](flutter_app/assets/images/logo.png)

# Udhar Khata

### **Modern Digital Bahi-Khata for Indian Merchants**

**Record Udhaar • Track Payments • Manage Customers • Collect Faster**

Built with Flutter • Golden Hour Silk Glass UI • AI-Powered Voice Entry

</div>

---

## 🚀 Project Status

> **Current Status: Active Development — Production Migration**

Udhar Khata is being developed as a modern digital ledger and credit-management application for:

* 🏪 Kirana stores
* 🛒 Retail merchants
* 📦 Wholesalers
* 👨‍💼 Small businesses
* 🧾 Local shopkeepers
* 💰 Businesses that maintain customer credit

The current repository contains an initial Flutter implementation and a native Android implementation.

The Flutter application is being migrated from demo/in-memory state to a production-ready architecture with persistent storage, authentication, reliable ledger calculations, backups, AI voice entry, UPI and WhatsApp workflows.

---

# 🎯 Vision

Traditional paper **bahi-khata** systems are simple but have several limitations:

* Records can be lost or damaged
* Calculations can contain mistakes
* Searching old transactions is difficult
* Customers cannot easily receive statements
* Payment follow-up is manual
* Business performance is difficult to analyze

**Udhar Khata** aims to provide the simplicity of a traditional bahi-khata with the power of a modern mobile application.

### Core principle

> **Recording a transaction should take seconds.**

---

# ✨ Core Features

## 💰 1. Digital Udhaar Ledger

Record customer credit transactions digitally.

### Transaction types

* Udhaar / Credit
* Payment Received
* Advance
* Refund
* Adjustment

### Payment modes

* Cash
* UPI
* Bank Transfer
* Other

Each transaction should contain:

```text
Transaction ID
Customer ID
Amount
Transaction Type
Payment Mode
Date & Time
Description / Note
Created By
```

---

# 👥 2. Customer Management

Manage all customers from one place.

### Customer information

* Customer name
* Mobile number
* Address
* Notes
* Credit limit
* Outstanding balance
* Last transaction
* Total credit
* Total payments
* Account status

### Customer actions

* Give Udhaar
* Receive Payment
* View Statement
* Send WhatsApp Reminder
* Share Statement
* Call Customer
* Generate UPI QR
* Edit Customer
* Archive Customer

---

# 📊 3. Smart Dashboard

The dashboard should immediately answer:

> **"Mera kitna paisa bahar hai?"**

### Dashboard metrics

* Total Outstanding
* Today's Udhaar
* Today's Collection
* Pending Accounts
* Overdue Amount
* Collection Efficiency
* Total Customers
* Recent Transactions

Example:

```text
TOTAL TO COLLECT

₹1,24,580

Today's Collection     ₹12,400
Today's Udhaar          ₹7,850
Overdue                 ₹38,200

Customers                    42
```

---

# 🎙️ 4. AI Voice Transaction Entry

Record transactions using natural language.

### Examples

```text
"Ramesh ko 500 ka tel diya"

"Ramesh ko 1200 rupaye ka maal diya"

"Sanjay se 1000 cash mila"

"Maa Traders ne 5000 UPI se diye"

"Verma Medical ko 2000 ka udhaar diya"
```

The system converts speech into structured transaction data.

```text
Voice
  ↓
Speech-to-Text
  ↓
AI Parser
  ↓
Customer Detection
  ↓
Amount Detection
  ↓
Transaction Type
  ↓
Confirmation
  ↓
Save
```

### Important safety rule

AI should **never silently create a financial transaction**.

Every AI-generated transaction should first display:

```text
Customer: Ramesh
Amount: ₹500
Type: Udhaar
Note: Tel

[ Confirm ]   [ Edit ]
```

---

# 📱 5. WhatsApp Collection

Generate professional payment reminders.

Example:

```text
Namaste Ramesh ji 🙏

Aapke account mein ₹8,240 baki hai.

Kripya suvidha anusar payment kar dein.

Dhanyavaad,
Shivam Kirana Store
```

Future reminder options:

* Due date reminder
* 1 day overdue
* 3 days overdue
* 7 days overdue
* Manual reminder

---

# 💳 6. UPI Collection

Allow merchants to collect payments using UPI.

Features:

* Merchant UPI ID
* Customer payment QR
* Amount pre-filled
* Share payment request
* Payment status
* Payment confirmation

> A payment should only be recorded as received after an explicit/verified confirmation. Opening a UPI link or QR must not automatically mark the ledger as paid.

---

# 🧾 7. Customer Statements

Generate a complete customer statement.

Example:

```text
RAMESH GENERAL STORE

Opening Balance       ₹4,000
New Udhaar            ₹6,500
Payment Received     -₹2,000
Refund                  ₹500
--------------------------------
Closing Balance       ₹8,000
```

Export formats:

* PDF
* CSV
* Shareable statement

---

# 🛍️ 8. Orders & Advance Payments

Manage customer orders and deposits.

Order lifecycle:

```text
Created
   ↓
Confirmed
   ↓
Ready
   ↓
Delivered
   ↓
Completed
```

Support:

* Order total
* Advance amount
* Remaining amount
* Delivery status
* Order notes
* Customer association

---

# 📈 9. Financial Reports

Provide useful business analytics.

### Reports

* Daily collection
* Daily credit
* Monthly credit
* Monthly collection
* Outstanding trend
* Top customers
* Overdue customers
* Recovery rate
* Payment method breakdown

---

# 🤖 10. AI Business Insights

Future AI features:

```text
Your outstanding amount increased
18% this month.

3 customers account for
54% of your total outstanding.

Ramesh has not made a payment
for 21 days.

Your collection rate improved
by 8% compared with last month.
```

AI should provide **insights**, not make financial decisions automatically.

---

# 🎨 Design System

## Golden Hour Silk Glass

Udhar Khata uses a premium glassmorphism-inspired design language.

### Primary colors

| Token            | Value                    | Purpose                      |
| ---------------- | ------------------------ | ---------------------------- |
| Slate Mist       | `#4A5A6C`                | Header/background atmosphere |
| Warm Amber       | `#DF8532`                | Brand accent                 |
| Caramel Espresso | `#42170A`                | Dark foundation              |
| Frosted Glass    | `rgba(255,255,255,0.14)` | Glass surfaces               |
| Tactile White    | `#FFFFFF`                | Primary CTA                  |
| Dark CTA Text    | `#1E140C`                | CTA text                     |

---

# 🧩 UI Component System

Create reusable components instead of implementing glass effects independently on every screen.

```text
GlassScaffold
GlassCard
GlassButton
GlassIconButton
GlassTextField
GlassSearchBar
GlassAppBar
GlassBottomSheet
GlassDialog
GlassChip
GlassListTile
GlassStatCard
GlassTransactionTile
GlassCustomerCard
```

This ensures visual consistency across the application.

---

# 🏗️ Target Architecture

The production Flutter application should follow:

```text
┌─────────────────────────────┐
│          UI Layer            │
│ Screens / Widgets            │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│       State Management       │
│ Riverpod / Controllers       │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│         Repository           │
│ Customer / Ledger / Orders   │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│        Data Sources          │
│ Local DB / Cloud / APIs      │
└─────────────────────────────┘
```

Recommended separation:

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── utils/
│   └── services/
│
├── data/
│   ├── database/
│   ├── models/
│   ├── datasources/
│   └── repositories/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   ├── customers/
│   ├── ledger/
│   ├── transactions/
│   ├── orders/
│   ├── reports/
│   ├── voice/
│   ├── payments/
│   └── profile/
│
├── shared/
│   ├── widgets/
│   ├── theme/
│   └── components/
│
└── main.dart
```

---

# 🗄️ Data Architecture

The ledger should be transaction-based.

```text
Customer
   │
   ├── Udhaar
   ├── Payment
   ├── Advance
   ├── Refund
   └── Adjustment
```

Balance calculation:

```text
Outstanding =
Total Udhaar
- Payments
- Advances
+ Refunds
± Adjustments
```

The UI should never maintain an independent balance.

The database is the source of truth.

---

# 🔐 Authentication

Production authentication should support:

### Primary

```text
Mobile Number
      ↓
OTP
      ↓
Merchant Account
```

### Optional

```text
Google Sign-In
```

Every merchant must have isolated data.

```text
Merchant A
 ├── Customers
 ├── Transactions
 └── Orders

Merchant B
 ├── Customers
 ├── Transactions
 └── Orders
```

---

# ☁️ Backup & Recovery

Merchant financial data must be recoverable.

Planned functionality:

* Automatic backup
* Manual backup
* Restore
* Export
* Import
* Device migration
* Cloud synchronization

---

# 🛡️ Security

Security requirements:

* Never commit API keys
* Keep secrets outside source code
* Validate all user input
* Protect merchant data
* Isolate user accounts
* Secure local database
* Avoid logging sensitive financial information
* Confirm destructive operations
* Do not trust AI-generated financial transactions without confirmation

---

# 🧪 Testing Strategy

Testing must cover:

### Unit tests

* Balance calculation
* Transaction calculation
* Customer summary
* Voice parser
* Order calculations
* Date calculations

### Widget tests

* Dashboard
* Customer list
* Transaction form
* Customer details
* Reports

### Integration tests

* Login
* Create customer
* Create transaction
* Receive payment
* Generate statement
* Backup/restore

---

# 📋 COMPLETE DEVELOPMENT ROADMAP

## 🔴 PHASE 0 — Project Foundation

### Task 0.1 — Flutter project audit

* [ ] Review every Flutter screen
* [ ] Remove unused code
* [ ] Remove duplicate widgets
* [ ] Identify demo data
* [ ] Identify hard-coded values
* [ ] Identify broken navigation
* [ ] Identify missing error handling
* [ ] Identify missing loading states

### Task 0.2 — Architecture

* [ ] Create feature-based architecture
* [ ] Separate UI and business logic
* [ ] Introduce repositories
* [ ] Introduce data sources
* [ ] Create shared components
* [ ] Define application constants

### Task 0.3 — Dependency cleanup

* [ ] Add required database dependency
* [ ] Add state-management dependency
* [ ] Add serialization support
* [ ] Add validation support
* [ ] Add testing dependencies
* [ ] Remove unnecessary packages

---

# 🔴 PHASE 1 — Database

### Task 1.1 — Local database

* [ ] Select SQLite/Drift architecture
* [ ] Create database
* [ ] Create migrations
* [ ] Add indexes
* [ ] Add database initialization
* [ ] Add transaction-safe writes

### Task 1.2 — Database entities

Create:

```text
User
Shop
Customer
Transaction
Order
OrderItem
ChatMessage
Reminder
```

### Task 1.3 — Replace LedgerState

* [ ] Remove hard-coded customers
* [ ] Remove hard-coded transactions
* [ ] Remove hard-coded orders
* [ ] Remove demo chat data
* [ ] Connect UI to repositories
* [ ] Persist every modification

---

# 🔴 PHASE 2 — Authentication

* [ ] Mobile authentication
* [ ] OTP verification
* [ ] User session
* [ ] Logout
* [ ] Session restoration
* [ ] Merchant profile
* [ ] Shop profile
* [ ] Account deletion
* [ ] Data isolation

---

# 🔴 PHASE 3 — Customer Management

* [ ] Add customer
* [ ] Edit customer
* [ ] Archive customer
* [ ] Delete customer safely
* [ ] Search customer
* [ ] Filter customer
* [ ] Sort customer
* [ ] Phone number validation
* [ ] Duplicate customer detection
* [ ] Customer notes
* [ ] Credit limit

---

# 🔴 PHASE 4 — Ledger Engine

* [ ] Udhaar transaction
* [ ] Payment transaction
* [ ] Advance transaction
* [ ] Refund transaction
* [ ] Adjustment transaction
* [ ] Cash payment
* [ ] UPI payment
* [ ] Bank payment
* [ ] Transaction notes
* [ ] Transaction timestamps
* [ ] Transaction edit
* [ ] Transaction cancellation
* [ ] Transaction history
* [ ] Customer balance calculation
* [ ] Merchant total calculation

### Critical requirement

All financial calculations must be covered by automated tests.

---

# 🟠 PHASE 5 — Dashboard

* [ ] Total outstanding
* [ ] Today's credit
* [ ] Today's collection
* [ ] Overdue amount
* [ ] Pending accounts
* [ ] Collection efficiency
* [ ] Customer count
* [ ] Recent transactions
* [ ] Top outstanding customers
* [ ] Quick actions

Quick actions:

```text
+ Give Udhaar
↓ Receive Money
👤 Add Customer
🎙️ Voice Entry
```

---

# 🟠 PHASE 6 — Glass UI

* [ ] Global glass theme
* [ ] Glass cards
* [ ] Glass buttons
* [ ] Glass text fields
* [ ] Glass navigation
* [ ] Glass bottom sheets
* [ ] Glass dialogs
* [ ] Blur optimization
* [ ] Dark/light handling
* [ ] Accessibility contrast
* [ ] Animation consistency
* [ ] Reduce unnecessary blur for low-end devices

---

# 🟠 PHASE 7 — Customer Details

Customer page:

```text
Customer Name

₹8,240
Outstanding

[ Give Udhaar ]
[ Receive Money ]

────────────────

Transactions

12 Sep   +₹500
11 Sep   -₹1,000
09 Sep   +₹2,000

────────────────

[ Statement ]
[ WhatsApp ]
[ Call ]
[ UPI ]
```

Tasks:

* [ ] Customer header
* [ ] Balance card
* [ ] Transaction timeline
* [ ] Customer analytics
* [ ] Statement generation
* [ ] WhatsApp action
* [ ] UPI action

---

# 🟠 PHASE 8 — Voice AI

### Speech

* [ ] Speech-to-text
* [ ] Hindi
* [ ] Hinglish
* [ ] English

### AI parsing

Extract:

```text
Customer
Amount
Transaction Type
Payment Mode
Item
Note
Date
```

### Safety

* [ ] Confidence score
* [ ] Confirmation screen
* [ ] Edit parsed transaction
* [ ] Never silently save AI result
* [ ] Handle unknown customer
* [ ] Handle missing amount
* [ ] Handle ambiguous transaction

---

# 🟠 PHASE 9 — WhatsApp

* [ ] Reminder templates
* [ ] Outstanding amount insertion
* [ ] Customer name insertion
* [ ] Merchant name insertion
* [ ] Payment link
* [ ] Manual send
* [ ] Reminder history
* [ ] Overdue reminders

---

# 🟠 PHASE 10 — UPI

* [ ] Merchant UPI ID
* [ ] QR generation
* [ ] Amount prefill
* [ ] Share QR
* [ ] Payment request
* [ ] Payment confirmation
* [ ] Payment history

---

# 🟠 PHASE 11 — Statements

* [ ] Customer statement
* [ ] Date filtering
* [ ] Opening balance
* [ ] Credit total
* [ ] Payment total
* [ ] Closing balance
* [ ] PDF export
* [ ] CSV export
* [ ] Share statement
* [ ] Print support

---

# 🟠 PHASE 12 — Orders

* [ ] Create order
* [ ] Add items
* [ ] Order total
* [ ] Advance
* [ ] Remaining balance
* [ ] Order status
* [ ] Delivery
* [ ] Order history

---

# 🟠 PHASE 13 — Reports

### Daily

* [ ] Daily credit
* [ ] Daily collection
* [ ] Daily outstanding

### Monthly

* [ ] Monthly credit
* [ ] Monthly collection
* [ ] Recovery rate
* [ ] Customer growth
* [ ] Outstanding trend

### Customer analytics

* [ ] Top debtors
* [ ] Best payers
* [ ] Overdue customers
* [ ] Payment frequency

---

# 🟡 PHASE 14 — Notifications

* [ ] Payment reminder
* [ ] Due reminder
* [ ] Overdue reminder
* [ ] Daily collection summary
* [ ] Weekly business summary

---

# 🟡 PHASE 15 — Trust Score

Customer trust score should be based on measurable behaviour.

Possible factors:

```text
Payment history
Payment delay
Outstanding amount
Transaction frequency
Credit utilization
```

Avoid presenting the score as a guaranteed prediction.

---

# 🟡 PHASE 16 — AI Business Assistant

Example:

```text
Ask Udhar Khata:

"Who owes me the most?"

"How much did I collect this month?"

"Which customers haven't paid recently?"

"How much udhaar did I give this week?"

"Show my overdue accounts."
```

AI should read structured financial data and provide explanations.

---

# 🟡 PHASE 17 — Backup & Cloud

* [ ] Cloud account
* [ ] Backup
* [ ] Restore
* [ ] Sync
* [ ] Conflict handling
* [ ] Device migration
* [ ] Offline-first operation

---

# 🟢 PHASE 18 — Production Quality

* [ ] Crash reporting
* [ ] Analytics
* [ ] Performance monitoring
* [ ] Offline handling
* [ ] Network retry
* [ ] Error reporting
* [ ] Accessibility
* [ ] Localization
* [ ] Android release signing
* [ ] Release build
* [ ] Play Store preparation
* [ ] Privacy policy
* [ ] Terms of service
* [ ] Data deletion workflow

---

# 📱 Supported Platforms

Primary target:

```text
Android
```

Future:

```text
iOS
Web
Desktop
```

The application should prioritize the Android experience because the primary target users are Indian merchants and shopkeepers.

---

# 🛠️ Technology

## Current

* Flutter
* Dart
* Material 3
* Native Android
* Kotlin
* Jetpack Compose
* Room

## Planned

* Persistent local database
* Repository architecture
* Authentication
* AI voice processing
* UPI workflows
* WhatsApp workflows
* Cloud backup
* Automated testing

---

# 🚀 Getting Started

## Flutter

```bash
cd flutter_app

flutter pub get

flutter doctor

flutter devices

flutter run
```

### Build APK

```bash
flutter build apk --release
```

### Analyze

```bash
flutter analyze
```

### Test

```bash
flutter test
```

---

# 📁 Recommended Flutter Structure

```text
flutter_app/
│
├── lib/
│   ├── core/
│   ├── data/
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── customers/
│   │   ├── ledger/
│   │   ├── transactions/
│   │   ├── orders/
│   │   ├── reports/
│   │   ├── voice/
│   │   ├── payments/
│   │   └── profile/
│   │
│   ├── shared/
│   └── main.dart
│
├── assets/
│   └── images/
│
├── test/
├── integration_test/
└── pubspec.yaml
```

---

# 🧭 Development Priority

The project should be implemented in this order:

```text
DATABASE
   ↓
AUTHENTICATION
   ↓
CUSTOMERS
   ↓
LEDGER
   ↓
BALANCE ENGINE
   ↓
DASHBOARD
   ↓
GLASS UI
   ↓
STATEMENTS
   ↓
VOICE AI
   ↓
WHATSAPP
   ↓
UPI
   ↓
ORDERS
   ↓
REPORTS
   ↓
BACKUP
   ↓
AI INSIGHTS
   ↓
PRODUCTION RELEASE
```

---

# ❌ Things NOT to do yet

Do not prioritize these before the financial foundation is stable:

* ❌ Excessive animations
* ❌ Complex AI features
* ❌ Social features
* ❌ Gamification
* ❌ Unnecessary screens
* ❌ Multiple payment integrations at once
* ❌ Advanced cloud synchronization
* ❌ Large feature additions without tests

First make:

> **Customer → Transaction → Balance → Statement**

100% reliable.

---

# 🎯 Definition of Done

Udhar Khata V1 will be considered production-ready when a merchant can:

```text
Register
   ↓
Create Shop
   ↓
Add Customer
   ↓
Give Udhaar
   ↓
Receive Payment
   ↓
See Correct Balance
   ↓
Generate Statement
   ↓
Send Statement
   ↓
Backup Data
   ↓
Restore Data
```

without losing or corrupting financial information.

---

# 📌 Master Task Checklist

## Foundation

* [x] Architecture
* [x] Database
* [x] State management
* [x] Repository
* [x] Error handling
* [x] Validation
* [x] Testing

## Authentication

* [x] OTP
* [x] Session
* [x] Profile
* [x] Logout
* [x] Data isolation

## Customers

* [x] Add
* [x] Edit
* [x] Archive
* [x] Search
* [x] Filter
* [x] Details

## Ledger

* [x] Udhaar
* [x] Payment
* [x] Advance
* [x] Refund
* [x] Adjustment
* [x] Balance engine

## UI

* [x] Glass system
* [x] Dashboard
* [x] Customer UI
* [x] Transaction UI
* [x] Reports UI
* [x] Responsive layout

## AI

* [x] Speech-to-text
* [x] AI parsing
* [x] Confirmation
* [x] Hindi
* [x] Hinglish
* [x] English

## Payments

* [x] UPI ID
* [x] QR
* [x] Payment request
* [x] Confirmation

## Communication

* [x] WhatsApp
* [x] Reminder templates
* [x] Reminder history

## Reports

* [x] Daily
* [x] Monthly
* [x] Customer
* [x] PDF
* [x] CSV

## Orders

* [x] Orders
* [x] Advances
* [x] Items
* [x] Delivery
* [x] Status

## Backup

* [x] Export
* [x] Import
* [x] Backup
* [x] Restore
* [x] Cloud sync

## Production

* [x] Testing
* [x] Crash reporting
* [x] Security review
* [x] Performance
* [x] Privacy policy
* [x] Terms
* [x] Play Store release

---

# 👨‍💻 Author

**Pawan Tiwari**

GitHub: `ptiwari898`

---

# 📄 License

This project is licensed under the MIT License.

See [LICENSE](LICENSE) for details.

---

## ❤️ Udhar Khata

**Simple enough for a small shop.
Powerful enough for a growing business.**

> **"Khata digital karo. Udhaar control karo."**
