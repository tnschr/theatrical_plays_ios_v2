import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthorizationStore {
  static final storage = new FlutterSecureStorage();

  //Write a key-value pair in storage
  static void writeToStore(key, value) {
    storage.write(key: key, value: value);
  }

  //Get a value from store
  static Future<String?> getStoreValue(key) async {
    return await storage.read(key: key);
  }

  //Get all values from store
  static Future<Map<String, String>> getAllStoreValues() async {
    Map<String, String> values = await storage.readAll();
    return values;
  }

  //delete all values from storage
  static void deleteAllValuesFromStore() async {
    await storage.deleteAll();
  }

  //delete a value using key from storage
  static void deleteValueFromStore(key) async {
    await storage.delete(key: key);
  }
}
