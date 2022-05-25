

import 'package:firebase_1/firebase/cloud_firebase/firebase_data.dart';
import 'package:firebase_1/firebase/cloud_firebase/page_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_1/helpers/dialog.dart';

import '../authentication/login_page.dart';

class PageHomeFirebase extends StatefulWidget {
  const PageHomeFirebase({Key? key}) : super(key: key);

  @override
  State<PageHomeFirebase> createState() => _PageHomeFirebaseState();
}

class _PageHomeFirebaseState extends State<PageHomeFirebase> {
  BuildContext? _dialogContext;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase App'),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PageDetail(xem: false,),)
          ),
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: StreamBuilder<List<SinhVienSnapshot>>(
        stream: SinhVienSnapshot.getAllSinhVien(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return const Center(
              child: Text('Lỗi'),
            );
          }else{
            if(!snapshot.hasData){
              return const Center(child: Text('Đang tải dữ liệu...'),) ;
            }else{
              snapshot.data!.sort((a, b) => a.sinhVien!.id!.compareTo(b.sinhVien!.id!));
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(thickness: 1,),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    _dialogContext = context;
                    return Slidable(
                      child: ListTile(
                        leading: Text('${snapshot.data![index].sinhVien!.id}'),
                        title: Text('${snapshot.data![index].sinhVien!.ten}'),
                        subtitle: Text('${snapshot.data![index].sinhVien!.lop}'),
                      ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                            icon: Icons.description,
                            foregroundColor: Colors.yellow,
                            onPressed: (context) => Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                                  PageDetail(xem: true, svSnapshot: snapshot.data![index]))
                            ),
                        ),
                        SlidableAction(
                            icon: Icons.edit,
                            foregroundColor: Colors.blue,
                            onPressed: (context) => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    PageDetail(xem: false, svSnapshot: snapshot.data![index]))
                            ),
                        ),
                        SlidableAction(
                          icon: Icons.delete_forever,
                          foregroundColor: Colors.red,
                          onPressed:(context)=> _xoa(_dialogContext!, snapshot.data![index])
                        ),
                      ],
                    ),
                  );}
              );
            }
          }
        },
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Text('My firebase app'),
              ElevatedButton(onPressed: (){
                FirebaseAuth.instance.signOut().whenComplete((){
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage(),)
                  , (route) => false);
                });
              },
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      Text('Sign out')
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

void _xoa(BuildContext context, SinhVienSnapshot svs) async {
  String? confirm;
  confirm = await showConfirmDialog(context, "Bạn muốn xóa ${svs.sinhVien!.ten} ư");
  if(confirm == "ok"){
    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference reference = _storage.ref().child("images").child("anh_${svs.sinhVien!.id}.jpg");
    reference.delete();
    svs.delete().whenComplete(() => showSnackBar(context, "Xóa thành công", 3))
    .onError((error, stackTrace) {
      showSnackBar(context, "Xóa không thành công", 3);
      return Future.error("Xóa dữ liệu không thành công");
    });

  }
}
