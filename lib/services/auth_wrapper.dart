import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/register_page.dart';
import '../pages/main_navigation.dart';
import 'package:fsapp_shared/shared.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ⏳ loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ non loggato
        if (!snapshot.hasData) {
          return const RegisterPage();
        }

        // ✅ loggato con Firebase
        final firebaseUser = snapshot.data!;

        // 🔁 mapping Firebase User → Utente
        final utente = Utente(
          id: firebaseUser.uid,
          nominativo: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          password: '',
          tipo: 'P',
          area: null,
          biglietti: [],
        );

        return MainNavigation(currentUser: utente);
      },
    );
  }
}
