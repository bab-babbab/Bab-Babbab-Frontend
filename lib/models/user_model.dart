import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _id = '';
  String _name = '';
  String _message = '';
  String _school = '';
  String _grade = ''; 
  String _class = '';

  String get id => _id;
  String get name => _name;
  String get message => _message;
  String get school => _school;
  String get grade => _grade;
  String get class_ => _class; 

  String get gradeClass {
    if (_grade.isNotEmpty && _class.isNotEmpty) {
      return '${_grade}학년/${_class}반';
    } else {
      return '0학년/0반'; 
    }
  }

  void setUser({
    required String id,
    required String name,
    required String message,
    required String school,
    String grade = '', 
    String class_ = '',
  }) {
    _id = id;
    _name = name;
    _message = message;
    _school = school;
    _grade = grade;
    _class = class_; 
    notifyListeners();
  }

  void clearUser() {
    _id = '';
    _name = '';
    _message = '';
    _school = '';
    _grade = ''; 
    _class = '';
    notifyListeners();
  }

  bool get isLoggedIn => _id.isNotEmpty;
}
