import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final _db = FirebaseFirestore.instance;

  Future<void> createReport({
    required String? serial,
    required String? carriage,
    required String? type,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await _db.collection("reports").add({
      "serial": serial,
      "carriage": carriage,
      "type": type,
      "status": "APERTA",
      "openedBy": user?.uid,
      "openedAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getOpenReports() {
    return _db
        .collection("reports")
        .where("status", isEqualTo: "aperta")
        .snapshots();
  }

  Future<void> updateReport(String reportId, String status) async {
    await _db.collection("reports").doc(reportId).update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}
