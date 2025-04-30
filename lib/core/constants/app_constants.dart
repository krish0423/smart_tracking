class AppConstants {
  // App information
  static const String appName = 'SmartFab Tracker';
  static const String appVersion = '1.0.0';
  
  // Firestore collections
  static const String usersCollection = 'users';
  static const String materialsCollection = 'materials';
  static const String processesCollection = 'processes';
  static const String consumptionLogsCollection = 'consumption_logs';
  static const String productsCollection = 'products';
  static const String alertsCollection = 'alerts';
  
  // User roles
  static const String roleAdmin = 'admin';
  static const String roleOperator = 'operator';
  
  // Hive boxes
  static const String userBox = 'userBox';
  static const String materialsBox = 'materialsBox';
  static const String logsBox = 'logsBox';
  static const String settingsBox = 'settingsBox';
  static const String offlineQueueBox = 'offlineQueueBox';
  
  // Default pagination limits
  static const int defaultPageSize = 20;
  
  // Inventory constants
  static const double lowStockThresholdPercentage = 0.15; // 15% of max stock
  
  // Timing Constants
  static const int splashScreenDuration = 3; // in seconds
  
  // Profit margin defaults
  static const double defaultProfitMargin = 0.30; // 30%
  
  // Material units
  static const List<String> materialUnits = [
    'kg', 'g', 'lb', 'oz', 'L', 'ml', 'pcs', 'm', 'cm', 'sqm', 'cubm', 'rolls'
  ];
} 