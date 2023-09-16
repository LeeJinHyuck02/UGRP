import 'dart:convert';
import 'package:http/http.dart' as http;

import 'asset.dart';

Future<List> loadsessions(String userid) async {
  var reqbody = {
    "userid": userid,
  };

  var response = await http.post(
    Uri.parse("$server/sessions/load"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}

Future<List> loadstore() async {
  var reqbody = {};

  var response = await http.post(
    Uri.parse("$server/sessions/storeload"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

  List jsonResponse = json.decode(response.body);

  return jsonResponse;
}

Future<List> loadmenu(String name) async {
  var reqbody = {
    "name": name,
  };

  var response = await http.post(Uri.parse("$server/sessions/orderload"),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(reqbody));

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}

Future<List> loadallmenu() async {
  var reqbody = {};

  var response = await http.post(Uri.parse("$server/before/loadallmenu"),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(reqbody));

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}

Future<List> loadspots() async {
  var response = await http.get(Uri.parse("$server/before/loadspots"));

  List<dynamic> jsonResponse = jsonDecode(response.body);

  return jsonResponse;
}

void addsession (String userid, List userorder, String selectedgage, String category, int currentorder, int finalorder, int finaltime, int location_id) async{
    var reqbody = {
      "userid": userid,
      "userorder": jsonEncode(userorder),
      "name": selectedgage,
      "category": category,
      "currentorder": currentorder,
      "finalorder": finalorder,
      "finaltime": finaltime,
      "location_id": location_id,
    };

    var response = await http.post(
      Uri.parse("http://192.168.123.182:3000/sessions/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqbody),
    );
  }