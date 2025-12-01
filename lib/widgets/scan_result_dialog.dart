import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:fsapp/pages/notifications_page.dart';
import 'package:fsapp/widgets/confirm_button.dart';
import '../main.dart';

class ScanResultDialog {
  static Future<void> show(
    BuildContext context, {
    required String? serial,
    required String? carriage,
    required Utente currentUser
  }) {
    String? selectedTipo; // 🔥 scelta utente

    return showDialog(
      
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Conferma segnalazione"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔥 Dropdown con i tipi di segnalazione
                  const Text(
                    "Seleziona il tipo di segnalazione:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    initialValue: selectedTipo,
                    items: const [
                      DropdownMenuItem(
                          value: "Emergenza medica",
                          child: Text("Emergenza medica")),
                      DropdownMenuItem(
                          value: "Molestia personale",
                          child: Text("Molestia personale")),
                      DropdownMenuItem(
                          value: "Furto",
                          child: Text("Furto")),
                      DropdownMenuItem(
                          value: "Emergenza silenziosa",
                          child: Text("Emergenza silenziosa")),
                    ],
                    onChanged: (value) {
                      setState(() => selectedTipo = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Stai aprendo una segnalazione per:\n\n"
                    "• Treno: $serial\n"
                    "• Carrozza: $carriage\n\n"
                    "L'apertura di segnalazioni false è un reato.",
                  ),
                ],
              ),

              actions: [
                ConfirmButtons(
                  onConfirm: (selectedTipo == null)
                      ? null // 🔥 DISABILITA IL BOTTONE
                      : () async {
                          Navigator.of(dialogContext, rootNavigator: true).pop();
                          final segnalazioneService = SegnalazioneService();
                          final trenoService = TrenoService();
                          print("Fase di salvaraggio");
                          final trenoAsObj = await trenoService.getSingleTrenoByCodice(serial!);
                          //final trenoAsObj = trenoAsList[0];
                          final id = segnalazioneService.generateId();
                          print("Treno da salvare: $trenoAsObj");
      
                          final segnalazione = Segnalazione(
                            idNotifica: id, 
                            tipo: selectedTipo!, 
                            treno: trenoAsObj ?? Treno(codice: "FALLBACK_NO_TRAIN_FOUND", nCarrozze: "0", dataOraPartenza: "MAI", dataOraArrivo: "MAI"), 
                            carrozza: carriage!, 
                            dataOraApertura: DateTime.now().toString().substring(0, 16), 
                            stato: 'APERTA', 
                            apertaDa: currentUser);
                            segnalazioneService.createSegnalazione(segnalazione);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 15),
                              content: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.white),
                                  children: [
                                    const TextSpan(
                                        text:
                                            "Segnalazione inviata. Per visualizzarla premi "),
                                    TextSpan(
                                      text: "QUI",
                                      style: const TextStyle(
                                        color: Colors.yellow,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          rootNavigatorKey.currentState!.push(
                                            MaterialPageRoute(
                                              builder: (_) => NotificationsPage(
                                                treno: serial,
                                                carrozza: carriage,
                                                tipoSegnalazione: selectedTipo,
                                                currentUser: currentUser,
                                              ),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
