import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _id = '';
  String _name = '';
  String _message = '';
  String _school = '';

  String get id => _id;
  String get name => _name;
  String get message => _message;
  String get school => _school;

  void setUser({
    required String id,
    required String name,
    required String message,
    required String school,
  }) {
    _id = id;
    _name = name;
    _message = message;
    _school = school;
    notifyListeners();
  }

  void clearUser() {
    _id = '';
    _name = '';
    _message = '';
    _school = '';
    notifyListeners();
  }
}
