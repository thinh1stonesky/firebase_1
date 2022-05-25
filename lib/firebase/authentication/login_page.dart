
import 'package:firebase_1/firebase/authentication/authentication_methods.dart';
import 'package:firebase_1/firebase/authentication/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../cloud_firebase/page_firebase_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Spacer(),
               TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              const SizedBox(height: 10,),
               TextField(
                controller: passCtrl,
                decoration: const InputDecoration(
                  label: Text('Password'),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: size.width * 0.7,
                child: ElevatedButton(onPressed: (){
                  if(emailCtrl.text !="" && passCtrl.text !=""){
                    signWithEmailPassword(email: emailCtrl.text, password: passCtrl.text).
                      then((value){
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const FirebaseApp(),)
                        , (route) => false);
                    }).catchError((onError){
                      setState(() {
                        thongBaoLoi = onError;
                      });
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
    );
  }
}
