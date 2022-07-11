import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/screens/login.dart';
import 'package:firebase_auth_login/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() {
//   runApp(const MyApp());
// }

void main( ) async{
  WidgetsFlutterBinding.ensureInitialized();//플러터에서 firebase 사용하기 위해 메인 메서드에 불러와야하는 최초의 메서드
  await Firebase.initializeApp();                                            // -> firebase.initializeApp()은 비동기 방식의 메서드 이다
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MaterialApp(

    home: ChangeNotifierProvider<JoinOrLogin>.value(
        value: JoinOrLogin(),
        child: AuthPage()),
    );
  }
}

