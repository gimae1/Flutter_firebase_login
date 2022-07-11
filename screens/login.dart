import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/helper/login_background.dart';
import 'package:firebase_auth_login/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String userEmail = '';
  String userPassword = '';

  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children:<Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage(),
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  _authButton(size),
                ],),
              Container(height: size.height*0.01,),
              Consumer<JoinOrLogin>(
                builder: (context, joinOrLogin, child)=>
                    GestureDetector(
                    onTap: (){
                      joinOrLogin.toggle();
                    },
                    child: Text(joinOrLogin.isJoin?"Already Have an Account? Sing in":"Don't Have an Account? Create One",
                        style: TextStyle(color: joinOrLogin.isJoin?Colors.red:Colors.blue),)),
              ),

              Container(height: size.height*0.05,)
            ],
          ),
        ],
      ),
    );
  }

 void _register(BuildContext context) async{
    final UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final User? user = result.user;

    if(user == null){
      final snackBar = SnackBar(content: Text('Please tyr again later.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
 }
  void _login(BuildContext context) async{
    final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final User? user = result.user;

    if(user == null){
      final snackBar = SnackBar(content: Text('Please tyr again later.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  Widget _authButton(Size size){
    return Positioned(
      left: size.width*0.15,
      right: size.width*0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, joinOrLogin, child) => RaisedButton(
              child: Text(
                  joinOrLogin.isJoin?"join":"Login",
                  style:TextStyle(fontSize: 20, color: Colors.white)),
              color: joinOrLogin.isJoin?Colors.red:Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              onPressed: (){
                _tryValidation();
                print(userEmail);
                print(userPassword);
                if(_formKey.currentState!.validate()){
                joinOrLogin.isJoin?_register(context):_login(context);
                }
                if(_emailController.text != null){
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) =>MainPage()

                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget _logoImage() => const Expanded(
    child: Padding(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(
            backgroundImage: NetworkImage("https://i3.wp.com/i.gifer.com/7pv.gif")
        ),
      ),
    ),
  );

  Widget _inputForm(Size size){
    return Padding(
      padding: EdgeInsets.all(size.width*0.05),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right:12, top: 12, bottom: 32 ),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,//email입력 쉬운 타입의 키보드가 올라옴
                    key: ValueKey(1),
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Email",
                    ),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return "Please input correct Email.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      userEmail = value!;
                    },
                    onChanged: (value){
                      userEmail = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey(2),
                    obscureText: true,//비밀번호 노출 막음
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Password",
                    ),
                    validator: (String? value){
                      if(value!.isEmpty){
                        return "Please input correct Password.";
                      }
                      return null;
                    },
                    onSaved: (value){
                      userPassword = value!;
                    },
                    onChanged: (value){
                      userPassword = value;
                    },
                  ),
                  Container(height: 8,),
                  Consumer<JoinOrLogin>(
                    builder:(context,value, child) => Opacity(
                      opacity: value.isJoin?0:1,
                        child: Text("Forgot Password")),
                  ),
                ],
              )),
        ),
      ),
    );
  }

}
