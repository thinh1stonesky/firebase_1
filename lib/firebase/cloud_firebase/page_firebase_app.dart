
import 'package:firebase_1/firebase/cloud_firebase/pagehome_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseApp extends StatefulWidget {
  const FirebaseApp({Key? key}) : super(key: key);

  @override
  State<FirebaseApp> createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  bool loi = false;
  bool ketNoi = false;


  @override
  Widget build(BuildContext context) {
    if(loi) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text('Đã có lỗi xảy ra!', style: TextStyle(fontSize: 18),
          ),
        )
      );
    } else
      if(!ketNoi) {
        return Container(
            color: Colors.white,
            child: const Center(
              child: Text('Đang kết nối', style: TextStyle(fontSize: 18),
              ),
            )
        );
      }else{
        return const MaterialApp(
          title: 'Firebase App',
          home: PageHomeFirebase(),
        );
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _khoiTaoFirebase();
  }
  _khoiTaoFirebase() async{
    try{
      await Firebase.initializeApp();
      setState(() {
        ketNoi = true;
      });
    }catch(e){
      setState(() {
         loi = true;
      });
    }
  }
}
