import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:myapp/link.dart';

Future<dynamic> signInRequest(String email, String password) async {
  final storage = FlutterSecureStorage();
  try {
    final response = await http.post(
      Uri.parse('$link/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      var role = JwtDecoder.decode(responseData['access_token'])['role'];
      if (role != 'PATIENT') {
        return 'You are not a patient';
      }

      await storage.write(
        key: 'access_token',
        value: responseData['access_token'],
      );
      await storage.write(
        key: 'refresh_token',
        value: responseData['refresh_token'],
      );
      return null;
    } else {
      return response.body.split('"')[3];
    }
  } catch (e) {
    print(e);
    return 'Failed to send sign-in request: $e';
  }
}
