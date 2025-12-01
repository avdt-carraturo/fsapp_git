import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fsapp/models/utente.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

   Future<Utente?> login(String email, String password) async {
    final query = await _db
        .collection('utenti')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    return Utente.fromJson(doc.id, doc.data());
  }
  Future<User?> register(String email, String password, String role) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Salva i dati dell’utente nel DB
    await _db.collection("users").doc(cred.user!.uid).set({
      "email": email,
      "role": role,
      "createdAt": DateTime.now(),
    });

    return cred.user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Stream<User?> get userStream => _auth.authStateChanges();
}
