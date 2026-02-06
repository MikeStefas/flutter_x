import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> logout() async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
}
