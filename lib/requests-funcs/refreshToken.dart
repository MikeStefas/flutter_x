import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:myapp/link.dart';

Future<dynamic> refreshToken() async {
  final storage = FlutterSecureStorage();
  String accessToken = await storage.read(key: 'access_token') ?? "";
  if (isTokenExpired(accessToken)) {
    String refreshToken = await storage.read(key: 'refresh_token') ?? "";
    try {
      final response = await http.get(
        Uri.parse('$link/auth/refresh'),
        headers: <String, String>{
          'ngrok-skip-browser-warning': 'true', //BRUH MOMENT
          'Authorization': 'Bearer $refreshToken',
        },
      );
      await storage.write(
        key: 'access_token',
        value: response.body.split('"')[3],
      );
    } catch (e) {
      print(e);
      return 'Failed to upload demographic data: $e';
    }
  }
}

isTokenExpired(access_token) {
  return JwtDecoder.isExpired(access_token);
}
