# 📒 Udhar Khata (उधार खाता)

<div align="center">

![Udhar Khata Logo](flutter_app/assets/images/logo.png)

### **Next-Generation Digital Ledger & Credit Management for Merchants & Shopkeepers**
*Crafted with Golden Hour Silk Glassmorphism • Powered by Gemini AI • Cross-Platform Android & Flutter*

---

[![License: MIT](https://img.shields.io/badge/License-MIT-amber.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.47.3-02569B?logo=flutter)](https://flutter.dev)
[![Kotlin](https://img.shields.io/badge/Kotlin-2.0.0-7F52FF?logo=kotlin)](https://kotlinlang.org)
[![Android](https://img.shields.io/badge/Android-SDK%2035-3DDC84?logo=android)](https://developer.android.com)
[![Gemini AI](https://img.shields.io/badge/AI-Google%20Gemini-4285F4?logo=google)](https://ai.google.dev)

</div>

---

## 🌟 Overview

**Udhar Khata** is a digital credit ledger application designed specifically for Indian retail merchants, kirana stores, wholesalers, and small businesses. It replaces traditional paper bahi-khata notebooks with an ultra-responsive, secure, and beautiful financial management platform.

Featuring a **Golden Hour Silk Glass** design system, high-contrast readability, voice-driven transaction logging via Google Gemini AI, WhatsApp reminder automation, and instant UPI QR statement settlement.

---

## ✨ Key Features

### 💰 1. Smart Ledger & Balance Tracking
- **Hero Overview**: Live visibility of *Total to Collect*, *Collection Efficiency %*, and *Pending Accounts*.
- **Quick Dual Action**: Prominent tactile buttons for **Give Udhar** (`+`) and **Receive Money** (`↓`).
- **Customer Accounts**: Full transaction histories with credit limits, trust scores, and phonebook integration.

### 🎙️ 2. AI Voice Entry (Hindi / Hinglish / English)
- Record transactions effortlessly using natural speech (e.g., *"Ramesh ko 500 ka tel diya"* or *"Received 1000 from Sanjay"*).
- Instant NLP parsing extracts customer name, transaction type, items, and amount automatically.

### 🛍️ 3. Customer Orders & Advance Deposits
- Manage advance bookings, custom orders, and item pickups with real-time deposit tracking and completion toggles.

### 📲 4. Automated WhatsApp Reminders & UPI QR
- Send polite, professional debt collection reminders with pre-filled payment amounts and merchant UPI QR codes directly via WhatsApp.

### 📊 5. Financial Reports & Analytics
- Monthly turnover charts, recovery rate metrics, top credit accounts, and one-tap PDF statement exports.

---

## 🎨 Design Identity: *Golden Hour Silk Glass*

| Color Token | Hex Code | Purpose |
| :--- | :--- | :--- |
| **Slate Mist Top** | `#4A5A6C` | Calming header atmosphere |
| **Warm Amber Sunset** | `#DF8532` | Primary brand accent & luminous glow |
| **Rich Caramel Espresso** | `#42170A` | Grounded, high-contrast dark foundation |
| **Frosted Milk Glass** | `rgba(255,255,255,0.14)` | Elevated card surfaces with soft backdrop blur |
| **Tactile White CTA** | `#FFFFFF` (`#1E140C` text) | High-contrast instant action pills |

---

## 🏗️ Project Architecture

This repository contains two production-ready implementations:

```
UDhar-Khata/
├── app/                         # Native Android Application
│   ├── src/main/java/com/example/
│   │   ├── data/                # Room DB Entities, DAOs & Repositories
│   │   ├── services/            # Gemini Voice Parser & SMS Integrations
│   │   ├── ui/                  # Jetpack Compose UI (Screens, Theme & Components)
│   │   └── MainActivity.kt      # Main Entry Point
│   └── build.gradle.kts         # Android Gradle configuration
│
├── flutter_app/                 # Cross-Platform Flutter Application (Android / Web / iOS / Desktop)
│   ├── assets/images/           # Brand logos & graphics
│   ├── lib/
│   │   ├── models/              # Immutable Data Models & Serialization
│   │   ├── state/               # Reactive ChangeNotifier State Store
│   │   ├── theme/               # Golden Hour Silk Theme & Glass Card Widgets
│   │   ├── widgets/             # Reusable Modals & Dialogs
│   │   ├── screens/             # Dashboard, Customers, Detail, Chat, Statement, Orders, Reports
│   │   └── main.dart            # Flutter Entry Point & Navigation
│   └── pubspec.yaml             # Flutter dependencies & assets
│
├── LICENSE                      # MIT License
└── README.md                    # Project Documentation
```

---

## 🚀 Getting Started

### Prerequisites
- **Android SDK**: `Platform-Tools 35+`
- **Flutter SDK**: `3.47+` (Dart 3.13+)
- **JDK**: `Java 17+`

---

### 📱 Running the Flutter Application

1. **Navigate to the Flutter directory**:
   ```bash
   cd flutter_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Android Emulator / Connected Phone**:
   ```bash
   flutter run -d emulator-5554
   ```

4. **Run on Web Browser**:
   ```bash
   flutter run -d chrome
   # or
   flutter run -d web-server --web-port=8080 --web-hostname=localhost
   ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```

---

### 🤖 Running the Native Android App (Jetpack Compose)

1. Open the project root in **Android Studio**.
2. Sync Gradle files (`./gradlew build`).
3. Set your Google Gemini API key in `.env`:
   ```properties
   GEMINI_API_KEY=your_gemini_api_key_here
   ```
4. Run on your physical device or emulator via Android Studio run configuration.

---

## 👨‍💻 Author

**Pawan Tiwari**
- 📧 Email: [ptiwari898@gmail.com](mailto:ptiwari898@gmail.com)
- 🐙 GitHub: [@ptiwari898](https://github.com/ptiwari898)

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 **Pawan Tiwari**. All rights reserved.
