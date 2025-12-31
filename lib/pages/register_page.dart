import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fsapp/pages/main_navigation.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:fsapp/widgets/app_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authService = AuthService();
  final authServiceGoogle = AuthServiceGoogle();
  final utenteFirestoreService = UtenteService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Builder(
              builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                final logoHeight = screenHeight * 0.5;
                final logoWidth = screenWidth * 0.25;
          
                return AppLogo(
                  width: MediaQuery.of(context).size.width * 0.3,
                );
              },
            ),
            const SizedBox(height: 20),

            // 🔹 LOGIN MOCK EMAIL
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : _loginMock,
              child: const Text("Accedi"),
            ),

            const SizedBox(height: 30),

            // SEPARATORE
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("oppure"),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 30),
            GestureDetector(
              onTap: loading ? null : _loginGoogle,
              child: Image.asset(
                'packages/fsapp_shared/assets/google_logo.png',
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // LOGIN MOCK
  // -------------------------
  Future<void> _loginMock() async {
    setState(() => loading = true);

    final utente = await authService.login(
      emailCtrl.text,
      passCtrl.text,
    );

    setState(() => loading = false);

    if (utente == null) {
      _showError("Credenziali errate");
    } else {
      _goToHome(utente);
    }
  }

  // -------------------------
  // LOGIN GOOGLE
  // -------------------------
  Future<void> _loginGoogle() async {
  try {
    setState(() => loading = true);

    final User? firebaseUser = await authServiceGoogle.signInWithGoogle();
    if (firebaseUser == null) return;

    // Mapping Firebase User → Utente
    final utente = utenteFirestoreService.mapFirebaseUserToUtente(firebaseUser);

    // Navigazione verso MainNavigation
    _goToHome(utente);
  } catch (e) {
    _showError("Login Google fallito");
  } finally {
    setState(() => loading = false);
  }
}


  void _goToHome(Utente utente) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => MainNavigation(currentUser: utente),
    ),
  );
}


  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
