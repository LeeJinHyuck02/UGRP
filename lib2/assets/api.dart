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

Future<List> loadastore(String name) async {
  var reqbody = {
    "name": name,
  };

  var response = await http.post(
    Uri.parse("$server/sessions/astoreload"),
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

  var response = await http.post(
    Uri.parse("$server/sessions/orderload"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

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

void addsession(
    String userid,
    List userorder,
    String selectedgage,
    String category,
    int currentorder,
    int finalorder,
    int finaltime,
    int location_id,
    int tip) async {
  var reqbody = {
    "userid": userid,
    "userorder": jsonEncode(userorder),
    "name": selectedgage,
    "category": category,
    "currentorder": currentorder,
    "finalorder": finalorder,
    "finaltime": finaltime,
    "location_id": location_id,
    "tip": tip,
  };

  var response = await http.post(
    Uri.parse("$server/sessions/add"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );
}

Future<List> loadmysession(String userid) async {
  List a = [];

  var reqbody = {
    "userid": userid,
  };

  var response = await http.post(
    Uri.parse("$server/sessions/check"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

  var jsonResponse = jsonDecode(response.body);

  var response2 = await http.post(
    Uri.parse("$server/sessions/loadmy"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

  if (jsonResponse == false) {
    return a;
  } else {
    List<dynamic> result =
        jsonDecode(response.body) + jsonDecode(response2.body);

    return result;
  }
}

void addmember(
    String userid, int sessionid, int currentorder, List userorder) async {
  var reqbody = {
    "userid": userid,
    "sessionid": sessionid,
    "currentorder": currentorder,
    "userorder": jsonEncode(userorder),
  };

  var response = await http.post(
    Uri.parse("$server/sessions/addmember"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );
}

Future<List> loadbeforechat(int chatID) async {
  var reqbody = {
    "chatID": chatID,
  };

  while (true) {
    final response = await http.post(
      Uri.parse("$server/community/loadchat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqbody),
    );

    List<dynamic> result = json.decode(response.body);

    if (response.statusCode == 200) {
      return result;
    }
  }
}

void sendchat(String userid, String message, int chatID) async {
  var reqbody = {
    'userid': userid,
    'message': message,
    'chatID': chatID,
  };

  var response = await http.post(
    Uri.parse('$server/community/sendchat'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );
}

Future<List> loadrooms() async {
  var reqbody = {};

  var response = await http.post(
    Uri.parse("$server/community/loadrooms"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}

void addtexts(
  String userid,
  String title,
  String usertext,
) async {
  var reqbody = {
    "userid": userid,
    "title": title,
    "usertext": usertext,
  };

  var response = await http.post(
    Uri.parse("$server/community/addtext"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );
}

void addcomments(
  int id,
  String userid,
  String usertext,
) async {
  var reqbody = {
    "textid": id,
    "userid": userid,
    "usertext": usertext,
  };

  var response = await http.post(
    Uri.parse("$server/community/add"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(reqbody),
  );
}

Future<List> loadboard(String name) async {
  var reqbody = {
    "name": name,
  };

  var response = await http.post(Uri.parse("$server/community/board"),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(reqbody));

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}


Future<List> loadcomment(int id) async {
  var reqbody = {
    "textid": id,
  };

  var response = await http.post(Uri.parse("$server/community/comment"),
      headers: {"Content-Type": "application/json"}, body: jsonEncode(reqbody));

  List<dynamic> jsonResponse = json.decode(response.body);

  return jsonResponse;
}