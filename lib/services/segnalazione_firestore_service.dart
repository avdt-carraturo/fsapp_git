import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:intl/intl.dart';

class SegnalazioneService {
  final db = FirebaseFirestore.instance;

  String generateId() {
    return db.collection("segnalazioni").doc().id;
  }

  Future<void> createSegnalazione(Segnalazione segnalazione) async {
    await db.collection("segnalazioni").doc(segnalazione.idNotifica).set(segnalazione.toJson());
  }

  Future<Segnalazione?> getSegnalazione(String id) async {
    final doc = await db.collection("segnalazioni").doc(id).get();
    if (!doc.exists) return null;
    return Segnalazione.fromJson(doc.id, doc.data()!);
  }

  Future<List<Segnalazione>> getSegnalazioniByUserAndDatePeriod(String email) async {
    final nowString = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
    final now = DateTime.now();
    final oneMonthAgo = DateTime(now.year, now.month - 1, now.day, now.hour, now.minute);
    final minorLimitCheckString = DateFormat("yyyy-MM-dd HH:mm").format(oneMonthAgo);
    final querySnapshot = await db
        .collection("segnalazioni")
        .where("apertaDa.email", isEqualTo: email)
        //.where("dataOraApertura", isGreaterThanOrEqualTo: minorLimitCheckString)
        //.where("dataOraApertura", isLessThanOrEqualTo: nowString)
        .get();
    if (querySnapshot.docs.isEmpty) return [];
    return querySnapshot.docs
      .map((doc) => Segnalazione.fromJson(doc.id, doc.data()))
      .toList();
}


  Stream<Segnalazione?> getSegnalazioneStream(String id) {
    return db.collection("segnalazioni").doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      return Segnalazione.fromJson(snap.id, snap.data()!);
    });
  }

  Future<void> updateSegnalazione(String id, Map<String, dynamic> data) async {
    await db.collection("segnalazioni").doc(id).update(data);
  }


}
