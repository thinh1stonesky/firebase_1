

import 'package:firebase_1/firebase/authentication/authentication_methods.dart';
import 'package:flutter/material.dart';

import '../../helpers/checks.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool _isVisible = false;
  String? erorr;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController passCfmCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    label: Text('Your Password'),
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
                TextFormField(
                  obscureText: _isVisible ==true ? false : true,
                  validator: (value) => ValidatePassCfm(value, passCtrl.text),
                  controller: passCfmCtrl,
                  decoration: InputDecoration(
                    label: Text('Retype Your Password'),
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
                  width: size.width * 0.5,
                  child: ElevatedButton(onPressed: (){
                    bool? validate = formState.currentState?.validate();
                    if(validate == true){
                      registerEmailPassword(email: emailCtrl.text, password: passCtrl.text).
                      then((value){
                        setState(() {
                          erorr = "Registered successfully";
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const LoginPage(),)
                            , (route) => false);
                      }).catchError((onError){
                        setState(() {
                          print('--------------------------------------');
                          print(onError);
                          erorr = onError;
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
                          Icon(Icons.vpn_key_rounded),
                          Text('Register',style: TextStyle(color: Colors.white),),
                        ],
                      )
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
}
