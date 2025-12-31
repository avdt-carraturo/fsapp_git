/* import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:fsapp/services/auth_wrapper.dart';
import 'package:fsapp/widgets/app_logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // <-- importante
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                /* Image.asset(
                  'packages/fsapp_shared/assets/app_logo.png',
                  width: screenWidth * 0.3,
                  fit: BoxFit.contain,
                ) */
               AppLogo(
                  width: MediaQuery.of(context).size.width * 0.3,
                ),

                const SizedBox(height: 20),

                // Testo
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Benvenuto in Travel with Security, inserisci i tuoi dati o accedi tramite Google per segnalare emergenze di Safety e Security con un click.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Pulsante
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const AuthWrapper()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Vai all'app"),
                ),

                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const AuthWrapper()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text("Scannerizza il QR code sul tuo biglietto"),
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:fsapp/services/auth_wrapper.dart';
import 'package:fsapp/widgets/app_logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              //Material-like
              //Color(0xFFFFF1F1),
              //Color(0xFFF6DADA),
              //Chiaro
              Color(0xFFFFEBEE),
              Color(0xFFFFCDD2),
              //Lit
              //Color(0xFFFFD6D9),
              //Color(0xFFF4A3A8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.6,
                ),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 56,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo
                        AppLogo(
                          width: screenWidth * 0.25,
                        ),

                        const SizedBox(height: 32),

                        // Descrizione
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Inserisci i tuoi dati o accedi tramite Google per segnalare emergenze di Safety e Security con un solo click, ovunque ti trovi.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Primary CTA
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AuthWrapper(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text("Possiedo un account - Prosegui all'app"),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Secondary CTA
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AuthWrapper(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: const BorderSide(width: 0.5),
                            ),
                            child: const Text(
                              "Non possiedo un account e desidero proseguire senza - Scannerizza il QR code sul tuo biglietto",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Secondary CTA
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const AuthWrapper(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: const BorderSide(width: 0.5),
                            ),
                            child: const Text(
                              "Registrati",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
