import 'dart:convert';
import 'package:flutter_app/data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future sendFCMToken(String token) async {

  var json_request = jsonEncode({
    "token": token,
  });
  var url = 'https://client.apis.prod.faem.pro/api/v2/firebasetoken';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Source':'faem_food',
    'Authorization':'Bearer ' + authCodeData.token
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return authCodeData;
}