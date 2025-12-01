import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/treno.dart';

class TrenoService {
  final db = FirebaseFirestore.instance;

  Future<void> createTreno(Treno treno) async {
    await db.collection("treni").doc(treno.id).set(treno.toJson());
  }

  Future<Treno?> getTreno(String id) async {
    final doc = await db.collection("treni").doc(id).get();
    if (!doc.exists) return null;
    return Treno.fromJson(doc.id, doc.data()!);
  }

  Future<List<Treno>> getTrenoByCodice(String codice) async {
    final now = DateTime.now();
    final doc = await db.collection("treni")
    .where("codice", isEqualTo: codice)
    .where("dataOraPartenza", isLessThanOrEqualTo: now)
    .where("dataOraArrivo", isNull: true)
    .get();
    if (doc.docs.isEmpty) return [];
    return doc.docs
      .map((d) => Treno.fromJsonNoId(d.data()))
      .toList();
  }

  Future<Treno?> getSingleTrenoByCodice(String codice) async {
  final now = DateTime.now();
  final query = await db.collection("treni")
      .where("codice", isEqualTo: codice)
      //.where("dataOraPartenza", isLessThanOrEqualTo: now)
      .where("dataOraArrivo", isEqualTo: "")
      .limit(1)
      .get();
  if (query.docs.isEmpty) {
    return null;
  }else{
    print("Treno trovato: ${query.docs.map((e) => print(e))}");
  }
  final data = query.docs.first.data(); 
  return Treno.fromJsonNoId(data);
}


  Future<List<Treno>> getTreni() async {
    final query = await db.collection("treni").get();
    return query.docs
        .map((d) => Treno.fromJson(d.id, d.data()))
        .toList();
  }

  Future<void> updateTreno(String id, Map<String, dynamic> data) async {
    await db.collection("treni").doc(id).update(data);
  }

  Future<void> deleteTreno(String id) async {
    await db.collection("treni").doc(id).delete();
  }
}
