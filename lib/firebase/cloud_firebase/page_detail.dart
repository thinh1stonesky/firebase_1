

import 'dart:io';
import 'package:firebase_1/firebase/cloud_firebase/firebase_data.dart';
import 'package:firebase_1/helpers/dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PageDetail extends StatefulWidget {
  bool? xem;
  SinhVienSnapshot? svSnapshot;
  PageDetail({Key? key,required this.xem, this.svSnapshot}) : super(key: key);

  @override
  State<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  bool? xem;
  SinhVienSnapshot? svSnapshot;

  bool _imageChange = false;
  XFile? _xImage; // lưu thông tin đường dẫn ảnh

  String label = "Thêm sinh viên";
  String buttonLabel = "Thêm";
  TextEditingController idCtrl = TextEditingController();
  TextEditingController tenCtrl = TextEditingController();
  TextEditingController lopCtrl = TextEditingController();
  TextEditingController namSinhCtrl = TextEditingController();
  TextEditingController queQuanCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    xem = widget.xem;
    svSnapshot = widget.svSnapshot;
    if(svSnapshot != null) {
      idCtrl.text = svSnapshot!.sinhVien!.id ?? "";
      tenCtrl.text = svSnapshot!.sinhVien!.ten ?? "";
      lopCtrl.text = svSnapshot!.sinhVien!.lop ?? "";
      namSinhCtrl.text = svSnapshot!.sinhVien!.nam_sinh ?? "";
      queQuanCtrl.text = svSnapshot!.sinhVien!.que_quan ?? "";
      if(xem! == false){
        label = "Cập nhật sinh viên ${svSnapshot!.sinhVien!.ten}";
        buttonLabel = "Cập nhật";
      }
      else{
        label = "Thông tin sinh viên ${svSnapshot!.sinhVien!.ten}";
        buttonLabel = "Đóng";
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: _imageChange ?
            Image.file(File(_xImage!.path))
                : svSnapshot?.sinhVien!.anh != null ?
            Image.network(svSnapshot!.sinhVien!.anh!)
                : null
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: xem != true?()=>
              _chonAnh(context)
                  : null,
                  child: const Icon(Icons.image))
            ],
          ),
          TextField(
            controller: idCtrl,
            decoration: const InputDecoration(label: Text("Id")),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: tenCtrl,
            decoration: const InputDecoration(label: Text("Tên")),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: lopCtrl,
            decoration: const InputDecoration(label: Text("Lớp")),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: namSinhCtrl,
            decoration: const InputDecoration(label: Text("Năm sinh")),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: queQuanCtrl,
            decoration: const InputDecoration(label: Text("Quê quán")),
            keyboardType: TextInputType.text,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  child: Text(buttonLabel),
                onPressed: () async{
                    if(xem == true){
                      Navigator.of(context).pop();
                    }
                    else{
                      _capNhat(context);
                      // SinhVien sv = SinhVien(
                      //     id: idCtrl.text,
                      //     ten: tenCtrl.text,
                      //     lop: lopCtrl.text,
                      //   nam_sinh: namSinhCtrl.text,
                      //   que_quan: queQuanCtrl.text
                      // );
                      // if(svSnapshot != null){
                      //   await svSnapshot!.update(sv);
                      // }else{
                      //   SinhVienSnapshot.addNew(sv);
                      // }
                      // Navigator.of(context).pop();
                    }
                },
              ),
              const SizedBox(width: 10,),
              xem != false ?
              const SizedBox(width: 1,)
                  : ElevatedButton(onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Đóng")),
              const SizedBox(width: 10,)
            ],
          )
        ],
      ),
    );
  }

  _chonAnh(BuildContext context) async {
    _xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(_xImage != null){
      setState(() {
        _imageChange = true;
      });
    }
  }

  _capNhat(BuildContext context) async {
    // showSnackBar(context, "Đang cập nhật dữ liệu...", 300);
    SinhVien sv = SinhVien(
            id: idCtrl.text,
            ten: tenCtrl.text,
            lop: lopCtrl.text,
          nam_sinh: namSinhCtrl.text,
          que_quan: queQuanCtrl.text,
          anh: null
        );
    if(_imageChange){
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference reference = _storage.ref().child("images").child("anh_${sv.id}.jpg");

      UploadTask uploadTask = await _uploadTask2(reference, _xImage!);
      uploadTask.whenComplete(() async{
        sv.anh = await reference.getDownloadURL();
        if(svSnapshot != null){
          _capNhatSV(svSnapshot!, sv);
        }
        else{
          _themSV(sv);
        }
      }).onError((error, stackTrace) => Future.error("Có lỗi xảy ra!"));
    }else{
      if(svSnapshot != null){
        sv.anh = svSnapshot!.sinhVien!.anh;
        _capNhatSV(svSnapshot!, sv);
      }else{
        sv.anh = "";
        _themSV(sv);
      }
    }
  }

  Future<UploadTask> _uploadTask(Reference reference, XFile xImage) async {
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': xImage.path});
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = reference.putData(await xImage.readAsBytes(), metadata);
    } else {
      uploadTask = reference.putFile(File(xImage.path), metadata);
    }
    return Future.value(uploadTask);
  }
  Future<UploadTask> _uploadTask2(Reference reference, XFile xImage) async {
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path' : xImage.path});
    UploadTask uploadTask;
    if(kIsWeb){
      uploadTask = reference.putData(await xImage.readAsBytes(), metadata);
    }else{
      uploadTask = reference.putFile(File(xImage.path), metadata);
    }
    return Future.value(uploadTask);
  }

 _capNhatSV(SinhVienSnapshot? svSnapshot, SinhVien sv) async {
    svSnapshot!.update(sv).whenComplete(() =>
    showSnackBar(context, "Cập nhật thành công", 3)).onError((error, stackTrace) =>
    showSnackBar(context, "Cập nhật không thành công", 3));
  }

  _themSV(SinhVien sv) async{
    SinhVienSnapshot.addNew(sv).whenComplete(() =>
        showSnackBar(context, "Cập nhật thành công", 3))
        .onError((error, stackTrace) {
       showSnackBar(context, "Thêm không thành công", 3);
       return Future.error("Lỗi khi thêm");
    });
  }
}
