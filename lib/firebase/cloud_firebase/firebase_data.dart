
import 'package:cloud_firestore/cloud_firestore.dart';

class SinhVien {
  String? id, ten, que_quan, nam_sinh, lop, anh;

  SinhVien({this.nam_sinh,
    required this.id,
    required this.ten,
    this.lop,
    this.que_quan,
    this.anh});

  factory SinhVien.fromJson(Map<String, dynamic> json){
    return SinhVien(
      id: json['id'] as String,
      ten: json['ten'] as String,
      lop: json['lop'] as String,
      que_quan: json['que_quan'] as String,
      nam_sinh: json['nam_sinh'] as String,
      anh: json['anh']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'ten' : ten,
      'lop' : lop,
      'nam_sinh' : nam_sinh,
      'que_quan' : que_quan,
      'anh' : anh
    };
  }
}

class SinhVienSnapshot{
  SinhVien? sinhVien;
  DocumentReference? docRef;

  SinhVienSnapshot({required this.sinhVien, required this.docRef});

  factory SinhVienSnapshot.fromSnapshot(DocumentSnapshot docSnap){
    return SinhVienSnapshot(
        sinhVien: SinhVien.fromJson(docSnap.data() as Map<String, dynamic>),
        docRef: docSnap.reference,
    );
  }

  Future<void> update(SinhVien sv) async {
    return docRef!.update(sv.toJson());
  }

  Future<void> delete() async {
    return docRef!.delete();
  }

  static Future<DocumentReference> addNew(SinhVien sv) async {
    return FirebaseFirestore.instance.collection('SinhVien').add(sv.toJson());
  }


  static Stream<List<SinhVienSnapshot>> getAllSinhVien(){
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance.collection('SinhVien').snapshots();
    Stream<List<DocumentSnapshot>> listDocSnap = qs.map((qSnap) => qSnap.docs);
    return listDocSnap.map((lds) => lds.map((docSnap) => SinhVienSnapshot.fromSnapshot(docSnap)).toList());
  }
}