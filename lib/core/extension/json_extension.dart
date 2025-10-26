extension JsonExtensionX on Map<String, dynamic> {
  /// Get String Value of Key from json
  String getStringFromJson(String key, {String defaultString = ""}) {
    try {
      return this[key];
    } catch (error) {
      return "";
    }
  }

  /// Get String or Null value of key from json
  String? getStringOrNullFromJson(String key, {String? defaultString}) {
    try {
      return this[key];
    } catch (error) {
      return defaultString;
    }
  }

  /// Get int or null value of key from json
  int? getIntOrNullFromJson(String key, {int? defaultInt}) {
    try {
      return this[key];
    } catch (error) {
      return defaultInt;
    }
  }

  /// Get int  value of key from json
  int getIntFromJson(String key, {int defaultInt = 0}) {
    try {
      return this[key];
    } catch (error) {
      return defaultInt;
    }
  }

  /// Get list of int of key from json
  List<int> getIntegersFromJson(
    String key, {
    List<int> defaultIntegers = const [],
  }) {
    try {
      return List<int>.from(this[key]);
    } catch (error) {
      return defaultIntegers;
    }
  }

  /// Get int  value of key from json
  double getDoubleFromJson(String key, {double defaultDouble = 0}) {
    try {
      return this[key];
    } catch (error) {
      return defaultDouble;
    }
  }

  /// Get int  value of key from json
  double? getDoubleOrNullFromJson(String key) {
    try {
      return this[key];
    } catch (error) {
      return null;
    }
  }

  /// Get list of int of key from json
  List<double> getDoublesFromJson(
    String key, {
    List<double> defaultDoubles = const [],
  }) {
    try {
      return List<double>.from(this[key]);
    } catch (error) {
      return defaultDoubles;
    }
  }

  /// Get bool  value of key from json
  bool getBooleanFromJson(String key, {bool defaultBoolean = false}) {
    try {
      return this[key];
    } catch (error) {
      return defaultBoolean;
    }
  }

  /// get list of map
  List<Map<String, dynamic>> getMapListFromJson(String key) {
    try {
      return List<Map<String, dynamic>>.from(this[key]);
    } catch (error) {
      return [];
    }
  }

  /// get map/json from json
  Map<String, dynamic> getMapFromJson(String key) {
    try {
      return Map<String, dynamic>.from(this[key]);
    } catch (error) {
      return {};
    }
  }

  /// get map/json or null from json
  Map<String, dynamic>? getMapOrNullFromJson(String key) {
    try {
      return Map<String, dynamic>.from(this[key]);
    } catch (error) {
      return null;
    }
  }

  DateTime? getDateTimeOrNull(String key) {
    try {
      return this[key];
    } catch (error) {
      return null;
    }
  }
}
