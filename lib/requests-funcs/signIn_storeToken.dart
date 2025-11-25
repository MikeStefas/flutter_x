//request to save tokens. returns null if it worked. returns error or strings
// of errors if it didnt
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:myapp/link.dart';

//signin and store the tokens in local storage
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
      //save the tokens in secure storage
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      //CHECK ROLE
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
      return response.body.split('"')[3]; //to print the message
    }
  } catch (e) {
    print(e);
    return 'Failed to send sign-in request: $e';
  }
}
