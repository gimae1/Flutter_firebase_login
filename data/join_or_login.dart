import 'package:flutter/material.dart';

class JoinOrLogin extends ChangeNotifier{
  bool _isJoin = false; //_xxxx-> _ 붙이면 private 변수이다.

  bool get isJoin => _isJoin;
  void toggle(){
    _isJoin = !_isJoin;
    notifyListeners();
  }
}