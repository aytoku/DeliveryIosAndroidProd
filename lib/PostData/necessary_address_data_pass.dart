import 'dart:convert';
import 'package:flutter_app/models/NecessaryAddressModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


Future<NecessaryAddressData> loadNecessaryAddressData(String name) async {
  print('он обещал работать');
  NecessaryAddressData necessaryAddressData = null;
  var json_request = jsonEncode({
    "name": name
  });
  var url = 'https://crm.apis.prod.faem.pro/api/v2/addresses';
  var response = await http.post(url, body: json_request, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body);
    necessaryAddressData = new NecessaryAddressData.fromJson(jsonResponse);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
  print(response.body);
  return necessaryAddressData;
}