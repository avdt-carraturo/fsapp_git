import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:fsapp/widgets/confirm_button.dart';
import 'package:fsapp/pages/notifications_page.dart';

class HomePage extends StatefulWidget {
  final String? serial;
  final String? carriage;
  final Utente currentUser;

  const HomePage({super.key, this.serial, this.carriage, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? treno;
  String? carrozza;
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadTrainData();
  }

  /// Recupera: prima QR → altrimenti biglietto valido
  void _loadTrainData() {
    // QR ha la precedenza
    if (widget.serial != null && widget.serial!.isNotEmpty) {
      treno = widget.serial;
      carrozza = widget.carriage;
      return;
    }
    
    // Nessun QR → recupera biglietto valido
    final ticket = TicketValidator.getCurrentValidTicket(widget.currentUser);

    if (ticket != null) {
      treno = ticket.trenoId ?? "N/D";
      carrozza = ticket.carrozza ?? "N/D";
    }
  }

  ///Validazione biglietto → blocca alert se non valido
  bool _canOpen(String tipo) {
    final ok = TicketValidator.canOpenReport(
      user: widget.currentUser,
      treno: treno,
      carrozza: carrozza,
    );

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Non si è in possesso di un titolo di viaggio valido."),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    }

    return ok;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel with Security')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.train,
                          size: 50, color: Color(0xFFD6001C)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Travel with Security',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Ti senti in pericolo? Hai bisogno di assistenza?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  //Bottone 1
                  _AlertButton(
                    title: 'Aggressione',
                    subtitle: 'Segnala una minaccia verbale o fisica',
                    icon: Icons.warning_amber,
                    color: Colors.red,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),

                  //Bottone 2
                  _AlertButton(
                    title: 'Emergenza Medica',
                    subtitle: 'Segnala e avvia una chiamata 112',
                    icon: Icons.favorite,
                    color: Colors.pink,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),

                  //Bottone 3
                  _AlertButton(
                    title: 'Molestia',
                    subtitle: 'Segnala una molestia sessuale vissuta o testimoniata',
                    icon: Icons.people,
                    color: Colors.orange,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),

                  //Bottone 4
                  _AlertButton(
                    title: 'Furto',
                    subtitle: 'Borseggi o furti',
                    icon: Icons.lock,
                    color: Colors.blueGrey,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),

                  //Bottone 5 - NUOVO
                  _AlertButton(
                    title: 'Comportamento intemperante',
                    subtitle: 'Segnala persona in stato psicofisico alterato',
                    icon: Icons.report_problem,
                    color: Colors.amber.shade700,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? serial;
  final String? carriage;
  final bool Function(String tipo) validator;
  final Utente currentUser;

  const _AlertButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.serial,
    required this.carriage,
    required this.validator,
    required this.currentUser
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (!validator(title)) return;
          

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Conferma segnalazione"),
              content: Text(
                (serial != null && serial!.isNotEmpty)
                    ? "Stai aprendo una segnalazione $title per:\n\n"
                        "• Treno: $serial\n"
                        "• Carrozza: $carriage\n\n"
                        "Sei sicuro?\nL'apertura di una segnalazione fasulla è un crimine."
                    : "Aprire la segnalazione?",
              ),
              actions: [
                ConfirmButtons(
                  onConfirm: () async {
                    Navigator.pop(context);
                    final segnalazioneService = SegnalazioneService();
                    final trenoService = TrenoService();
                    print("Fase di salvaraggio");
                    final trenoAsObj = await trenoService.getSingleTrenoByCodice(serial!);
                    //final trenoAsObj = trenoAsList[0];
                    final id = segnalazioneService.generateId();
                    print("Treno da salvare: $trenoAsObj");
                    

                    final segnalazione = Segnalazione(
                      idNotifica: id, 
                      tipo: title, 
                      treno: trenoAsObj ?? Treno(codice: "FALLBACK_NO_TRAIN_FOUND", nCarrozze: "0", dataOraPartenza: "MAI", dataOraArrivo: "MAI"), 
                      carrozza: carriage!, 
                      dataOraApertura: DateTime.now().toString().substring(0, 16), 
                      stato: 'APERTA', 
                      apertaDa: currentUser);
                    segnalazioneService.createSegnalazione(segnalazione);

                    String testoPriorita = "";
                    if (["Aggressione", "Emergenza Medica", "Molestia"].contains(title)) {
                      testoPriorita = " Al tuo alert è stata applicata una priorità di primo livello.";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green.shade700,
                        content: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            children: [
                              const TextSpan(
                                  text:
                                      "Il tuo alert è stato inoltrato alle Security Control Room, che si metteranno in contatto con il personale di bordo e di stazione.$testoPriorita Gli operatori saranno alla tua posizione per darti supporto entro 5 minuti.\n\nPer visualizzarla premi "),
                              TextSpan(
                                text: "QUI",
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationsPage(
                                              treno: serial,
                                              carrozza: carriage,
                                              tipoSegnalazione: title,
                                              currentUser: currentUser,
                                        ),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        duration: const Duration(seconds: 10),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
