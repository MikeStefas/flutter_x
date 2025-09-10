//on history button press
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/link.dart';
import 'package:myapp/requests-funcs/refreshToken.dart';

Future<dynamic> viewDemographicDataRequest() async {
  await refreshToken();
  try {
    final storage = FlutterSecureStorage();
    String token = await storage.read(key: 'access_token') ?? "";

    final response = await http.post(
      Uri.parse('$link/demographics/view-demographic-data'),
      headers: <String, String>{
        'ngrok-skip-browser-warning': 'true', //BRUH MOMENT
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.length == 0) {
        return null;
      }

      return jsonDecode(response.body);
    } else {
      return response.body.split('"')[3]; //to print the message
    }
  } catch (e) {
    print(e);
    return 'Failed to demographic data: $e';
  }
}
