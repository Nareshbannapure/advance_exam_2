import 'package:advance_exam_2/model/pro_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper instance = FirestoreHelper._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPro({required ProductModel product}) {
    firestore
        .collection("products")
        .doc(product.id)
        .set(product.toMap(), SetOptions(merge: true));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProducts() {
    return firestore.collection('products').snapshots();
  }

  void updatePro({required ProductModel product}) {
    firestore.collection("products").doc(product.id).update(product.toMap());
  }

  void deletePro({required String id}) {
    firestore.collection("products").doc(id).delete();
  }
}
