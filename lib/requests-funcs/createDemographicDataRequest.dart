import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/link.dart';
import 'package:myapp/requests-funcs/refreshToken.dart';

Future<dynamic> createDemographicDataRequest(yob, gender) async {
  await refreshToken();
  try {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'access_token') ?? "";
    final response = await http.post(
      Uri.parse('$link/demographics/create-demographic-data'),
      headers: <String, String>{
        'ngrok-skip-browser-warning': 'true', //BRUH MOMENT
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'yearOfBirth': yob, 'gender': gender.toString()}),
    );

    if (response.body.split('"')[3] == 'success') {
      return 'success';
    } else {
      return response.body.split('"')[3]; //to print the message
    }
  } catch (e) {
    print(e);
    return 'Failed to upload demographic data: $e';
  }
}
