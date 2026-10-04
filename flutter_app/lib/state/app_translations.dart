enum AppLanguage {
  english,
  hindi,
  hinglish,
}

class AppTranslations {
  static const Map<String, Map<AppLanguage, String>> _localizedValues = {
    'appTitle': {
      AppLanguage.english: 'Udhar Khata',
      AppLanguage.hindi: 'उधार खाता',
      AppLanguage.hinglish: 'Udhar Khata',
    },
    'subTitle': {
      AppLanguage.english: 'Digital Bahi-Khata for Indian Businesses',
      AppLanguage.hindi: 'भारतीय व्यापारियों के लिए डिजिटल बही-खाता',
      AppLanguage.hinglish: 'Digital Bahi-Khata Shopkeeper ke liye',
    },
    'dashboard': {
      AppLanguage.english: 'Dashboard',
      AppLanguage.hindi: 'डैशबोर्ड',
      AppLanguage.hinglish: 'Dashboard',
    },
    'customers': {
      AppLanguage.english: 'Customers',
      AppLanguage.hindi: 'ग्राहक',
      AppLanguage.hinglish: 'Customers',
    },
    'reports': {
      AppLanguage.english: 'Reports',
      AppLanguage.hindi: 'रिपोर्ट्स',
      AppLanguage.hinglish: 'Reports',
    },
    'orders': {
      AppLanguage.english: 'Orders',
      AppLanguage.hindi: 'ऑर्डर',
      AppLanguage.hinglish: 'Orders',
    },
    'profile': {
      AppLanguage.english: 'Profile & Theme',
      AppLanguage.hindi: 'प्रोफ़ाइल और थीम',
      AppLanguage.hinglish: 'Profile & Theme',
    },
    'udhaarGiven': {
      AppLanguage.english: 'You Gave (Udhaar)',
      AppLanguage.hindi: 'आपने दिया (उधार)',
      AppLanguage.hinglish: 'Aapne Diya (Udhaar)',
    },
    'paymentReceived': {
      AppLanguage.english: 'You Got (Payment)',
      AppLanguage.hindi: 'आपको मिला (जमा)',
      AppLanguage.hinglish: 'Aapko Mila (Payment)',
    },
    'netBalance': {
      AppLanguage.english: 'Net Balance Due',
      AppLanguage.hindi: 'कुल बकाया राशि',
      AppLanguage.hinglish: 'Total Net Baki',
    },
    'addCustomer': {
      AppLanguage.english: 'Add Customer',
      AppLanguage.hindi: 'नया ग्राहक जोड़ें',
      AppLanguage.hinglish: 'Naya Customer Add Karein',
    },
    'addTransaction': {
      AppLanguage.english: 'Add Transaction',
      AppLanguage.hindi: 'लेन-देन दर्ज करें',
      AppLanguage.hinglish: 'Transaction Entry Karein',
    },
    'sendReminder': {
      AppLanguage.english: 'Send Reminder',
      AppLanguage.hindi: 'तगादा भेजें (रिमाइंडर)',
      AppLanguage.hinglish: 'Payment Reminder Bhejo',
    },
    'downloadPdf': {
      AppLanguage.english: 'Download PDF Statement',
      AppLanguage.hindi: 'पीडीएफ स्टेटमेंट डाउनलोड करें',
      AppLanguage.hinglish: 'PDF Statement Download Karein',
    },
    'voiceAi': {
      AppLanguage.english: 'Voice AI Entry',
      AppLanguage.hindi: 'आवाज़ से एंट्री दर्ज करें',
      AppLanguage.hinglish: 'Voice AI Entry',
    },
    'languageLabel': {
      AppLanguage.english: 'App Language',
      AppLanguage.hindi: 'ऐप की भाषा',
      AppLanguage.hinglish: 'App Ki Bhasha',
    },
    'themeModeLabel': {
      AppLanguage.english: 'Theme Palette',
      AppLanguage.hindi: 'थीम मोड',
      AppLanguage.hinglish: 'Theme Preference',
    },
  };

  static String getText(String key, AppLanguage lang) {
    if (_localizedValues.containsKey(key)) {
      return _localizedValues[key]![lang] ?? _localizedValues[key]![AppLanguage.english]!;
    }
    return key;
  }
}
