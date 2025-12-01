import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/utente.dart';
import '../models/biglietto.dart';

class UtenteService {
  final db = FirebaseFirestore.instance;

  Future<void> createUtente(Utente utente) async {
    await db.collection("utenti").doc(utente.id).set(utente.toJson());
  }

  Future<Utente?> getUtente(String id) async {
    final doc = await db.collection("utenti").doc(id).get();
    if (!doc.exists) return null;
    return Utente.fromJson(doc.id, doc.data()!);
  }

  Stream<Utente?> getUtenteStream(String id) {
    return db.collection("utenti").doc(id).snapshots().map((snap) {
      if (!snap.exists) return null;
      return Utente.fromJson(snap.id, snap.data()!);
    });
  }

  Future<void> updateUtente(String id, Map<String, dynamic> data) async {
    await db.collection("utenti").doc(id).update(data);
  }

  /// Aggiunge un biglietto alla lista dell'utente senza sovrascrivere gli altri
  Future<void> aggiungiBiglietto(Utente utente, Biglietto biglietto) async {
    await db.collection("utenti").doc(utente.id).update({
      'biglietti': FieldValue.arrayUnion([biglietto.toJson()]),
    });
  }
}
