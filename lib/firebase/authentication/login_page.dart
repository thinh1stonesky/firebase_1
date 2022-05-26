
import 'package:firebase_1/firebase/authentication/authentication_methods.dart';
import 'package:firebase_1/firebase/authentication/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helpers/checks.dart';
import '../cloud_firebase/page_firebase_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isVisible = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String thongBaoLoi = "";
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Form(
        key: formState,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Spacer(),
                TextFormField(
                  validator: (value) => ValidateString(value),
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    label: Text('Email'),
                  ),
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  obscureText: _isVisible ==true ? false : true,
                  validator: (value) => ValidateString(value),
                  controller: passCtrl,
                  decoration: InputDecoration(
                    label: Text('Password'),
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _isVisible = !_isVisible;
                          });
                        },
                        icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off)
                    )
                  ),

                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: size.width * 0.7,
                  child: ElevatedButton(onPressed: (){
                    bool? validate = formState.currentState?.validate();
                    if(validate == true){
                      thongBaoLoi = "";
                      // showSnackBar(context, "signing in ...", 300);
                      signWithEmailPassword(email: emailCtrl.text, password: passCtrl.text).
                      then((value){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const FirebaseApp(),)
                            , (route) => false);
                        // showSnackBar(context, "Hello ${FirebaseAuth.instance.currentUser?.email?? ""} ", 5);
                      }).catchError((onError){
                        setState(() {
                          thongBaoLoi = onError;
                        });
                        // showSnackBar(context, "Sign in not successfully", 5);
                      });
                    }


                  },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        primary: Colors.blue[800],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.mail),
                          Text('Sign in with Email',style: TextStyle(color: Colors.white),),
                        ],
                      )
                  ),
                ),
                const SizedBox(height: 25,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account',  ),
                      InkWell(
                        child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const RegisterPage(),)
                          );
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25,),
                SizedBox(
                  width: size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () async{
                      var user = await signWithGoogle();
                      if(user!=null){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const FirebaseApp(),)
                            , (route) => false);
                      }else{
                        setState(() {
                          thongBaoLoi = "Login fails";
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        primary: Colors.tealAccent[800]
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.golf_course_outlined),
                        Text('Sign in with Google'),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      )
    );
  }
  void showSnackBar(BuildContext context, String message, int second){
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: second))
    );}

  void _updateVisible() {

  }

}
