import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RescureStorage {
  static Future<void> saveData(Map responseData) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: responseData['token']);
    await storage.write(key: "id", value: responseData['id']);
    await storage.write(key: "email", value: responseData['email']);
    await storage.write(key: "image", value: responseData['image']);
    await storage.write(key: "firstName", value: responseData['firstName']);
    await storage.write(key: "lastName", value: responseData['lastName']);
    await storage.write(key: "phoneNumber", value: responseData['phoneNumber'].toString());
    await storage.write(key: "role", value: responseData['role']);
    await storage.write(key: "birthDate", value: responseData['birthDate']);
    await storage.write(key: "weight", value: responseData['weight'].toString());
    await storage.write(key: "height", value: responseData['height'].toString());
    await storage.write(key: "numP", value: responseData['numP'].toString());
  }

  
}
