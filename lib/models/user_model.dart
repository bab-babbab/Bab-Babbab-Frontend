import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _id = '';
  String _name = '';
  String _message = '';
  String _school = '';
  String _grade = ''; // 🔥 학년 추가
  String _class = ''; // 🔥 반 추가

  String get id => _id;
  String get name => _name;
  String get message => _message;
  String get school => _school;
  String get grade => _grade; // 🔥 학년 getter
  String get class_ => _class; // 🔥 반 getter

  // 🔥 학년/반 조합해서 반환하는 getter
  String get gradeClass {
    if (_grade.isNotEmpty && _class.isNotEmpty) {
      return '${_grade}학년/${_class}반';
    } else {
      return '0학년/0반'; // 🔥 기본값
    }
  }

  void setUser({
    required String id,
    required String name,
    required String message,
    required String school,
    String grade = '', // 🔥 학년 추가 (선택사항)
    String class_ = '', // 🔥 반 추가 (선택사항)
  }) {
    _id = id;
    _name = name;
    _message = message;
    _school = school;
    _grade = grade; // 🔥 학년 설정
    _class = class_; // 🔥 반 설정
    notifyListeners();
  }

  void clearUser() {
    _id = '';
    _name = '';
    _message = '';
    _school = '';
    _grade = ''; // 🔥 학년 초기화
    _class = ''; // 🔥 반 초기화
    notifyListeners();
  }

  // 🔥 로그인 상태 확인
  bool get isLoggedIn => _id.isNotEmpty;
}
