import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/biglietto.dart';

class BigliettoService {
  final db = FirebaseFirestore.instance;

  /// Crea un biglietto
  Future<void> createBiglietto(Biglietto b) async {
    await db.collection("biglietti").doc(b.id).set(b.toJson());
  }

  /// Recupera un biglietto tramite ID
  Future<Biglietto?> getBiglietto(String id) async {
    final doc = await db.collection("biglietti").doc(id).get();
    if (!doc.exists) return null;
    return Biglietto.fromJson(doc.id, doc.data()!);
  }

  /// Recupera tutti i biglietti di un utente
  Future<List<Biglietto>> getBigliettiByUtente(String utenteId) async {
    final q = await db
        .collection("biglietti")
        .where("utenteId", isEqualTo: utenteId)
        .get();

    return q.docs.map((d) => Biglietto.fromJson(d.id, d.data())).toList();
  }

  /// Metodo helper: un utente "compra" un biglietto
  Future<void> compraBiglietto(String utenteId, Biglietto b) async {
    // Assicurati che il biglietto punti all'utente
    final biglietto = Biglietto(
      id: b.id,
      utenteId: utenteId,
      trenoId: b.trenoId,
      validoDal: b.validoDal,
      validoAl: b.validoAl,
      carrozza: b.carrozza,
    );

    await createBiglietto(biglietto);
  }
}
