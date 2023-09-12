import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'asset.dart';
import 'package:prototype_2/assets/api.dart';

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _userid = '';
  String _location = '체인지업 그라운드';
  int _locationid = 2;
  bool _insession = false;

  String get username => _username;
  String get userid => _userid;
  String get location => _location;
  int get locationid => _locationid;
  bool get insession => _insession;

  void nameupdate(String username){
    _username = username;
    notifyListeners();
  }

  void idupdate(String userid){
    _userid = userid;
    notifyListeners();
  }

  void locationupdate(String selected, int id) {
    _locationid = id;
    _location = selected;
    notifyListeners();
  }

  void inupdate(String userid) async{
    var reqbody = {
      "userid": userid,
    };

    var response = await http.post(
      Uri.parse("$server/sessions/check"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqbody)
    );

    if (response.body == "true") {
      _insession = true;
      notifyListeners();
    }
    else {
      _insession = false;
      notifyListeners();
    }   
  }
}

class Menu extends ChangeNotifier {
  List _menu = [];

  List get menu => _menu;

  void menuupdate() async {
    _menu = await loadallmenu();

    notifyListeners();
  }
}

class Spots extends ChangeNotifier {
  List _spots = [];

  List get spots => _spots;

 void spotsupdate() async {
  _spots = await loadspots();

  notifyListeners();
 } 
}