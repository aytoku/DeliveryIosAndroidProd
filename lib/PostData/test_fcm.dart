//import 'dart:convert';
//import 'package:food_delivery/data/data.dart';
//import 'package:food_delivery/models/AuthCode.dart';
//import 'package:food_delivery/models/TestFCM.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert' as convert;
//
//Future<TestFCM> loadTestFCM(String token, String action) async {
//
//  TestFCM testFCM = null;
//  var json_request = jsonEncode({
//    "token": authCodeData.token,
//    "action": action
//  });
//  var url = 'https://client.apis.stage.faem.pro/api/v2/testfcm';
//  var response = await http.post(url, body: json_request, headers: <String, String>{
//    'Content-Type': 'application/json; charset=UTF-8',
//    'Accept': 'application/json',
//    'Source':'ios_client_app_1',
//    'Authorization':'Bearer ' + authCodeData.token
//  });
//  if (response.statusCode == 200) {
//    var jsonResponse = convert.jsonDecode(response.body);
//    testFCM = new TestFCM.fromJson(jsonResponse);
//  } else {
//    print('Request failed with status: ${response.statusCode}.');
//  }
//  print('SEIBER TOP  ' + response.body);
//  return testFCM;
//}