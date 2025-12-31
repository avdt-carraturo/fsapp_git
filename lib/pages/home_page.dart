import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:fsapp/widgets/confirm_button.dart';
import 'package:fsapp/pages/notifications_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'package:fsapp/widgets/app_logo.dart';

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
                  /* Image.asset(
                  'packages/fsapp_shared/assets/app_logo_dark.png',
                  fit: BoxFit.contain,
                ) */ AppLogo(width: MediaQuery.of(context).size.width * 0.3),
                  /* Container(
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
                  ), */
                  /*const SizedBox(height: 12),
                   const Text(
                    'Travel with Security',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ), */
                  const SizedBox(height: 4),
                  const Text(
                    'Ti senti in pericolo? Hai bisogno di assistenza?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  //Bottone 1
                  _AlertButton(
                    //title: 'Emergenza Silenziosa',
                    title: 'Aggressione',
                    //subtitle: 'Aggressione o minaccia',
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
                    //subtitle: 'Malore o pronto soccorso',
                    subtitle: 'Avvia una chiamata al 112',
                    icon: Icons.favorite,
                    color: Colors.pink,
                    serial: treno,
                    carriage: carrozza,
                    validator: _canOpen,
                    currentUser: widget.currentUser,
                  ),

                  //Bottone 3
                  _AlertButton(
                    //title: 'Molestia Personale',
                    title: 'Molestia',
                    //subtitle: 'Comportamenti inappropriati',
                    subtitle: 'Segnala una molestia vissuta o della quale sei testimone',
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

                  //Bottone 5
                  _AlertButton(
                    title: 'Comportamento intemperante',
                    subtitle: 'Segnala la presenza di una persona in stato psicofisico alterato',
                    icon: Icons.people_outlined,
                    color: Colors.grey,
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

class _AlertButton extends StatefulWidget {
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
    required this.currentUser,
  });

  @override
  State<_AlertButton> createState() => _AlertButtonState();
}

class _AlertButtonState extends State<_AlertButton> {
  late TextEditingController _trenoCtrl;
  late TextEditingController _carrozzaCtrl;
  XFile? mediaFile;

  @override
  void initState() {
    super.initState();
    _trenoCtrl = TextEditingController(text: widget.serial ?? '');
    _carrozzaCtrl = TextEditingController(text: widget.carriage ?? '');
  }

  @override
  void dispose() {
    _trenoCtrl.dispose();
    _carrozzaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.color,
          child: Icon(widget.icon, color: Colors.white),
        ),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(widget.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _handleTap(context),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (!widget.validator(widget.title)) return;

    if (widget.title == 'Emergenza Medica') {
      _showMedicalDialog(context);
    } else {
      _showConfirmDialog(context);
    }
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() => mediaFile = file);
    }
  }

  void _showMedicalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Emergenza Medica"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(text: "Puoi chiamare il "),
              const TextSpan(
                text: "112",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " premendo "),
              TextSpan(
                text: "QUI",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _call112,
              ),
              const TextSpan(
                text:
                    "\n\nSe vuoi procedere a segnalare l'evento solo al personale di bordo premi il pulsante in basso.\nTi ricordiamo che questa app non si sostituisce in alcun modo al numero unico di emergenza nazionale.\nRicordiamo inoltre che l'attivazione indebita di un ALERT rappresenta un illecito che sarà sanzionato a norma del D.P.R. 753/80",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showConfirmDialog(context);
            },
            child: const Text("Continua segnalazione"),
          ),
        ],
      ),
    );
  }

  Future<void> _call112() async {
    final uri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Conferma segnalazione"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stai aprendo una segnalazione ${widget.title} per:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Treno
              TextFormField(
                controller: _trenoCtrl,
                decoration: const InputDecoration(
                  labelText: "Treno",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Carrozza
              TextFormField(
                controller: _carrozzaCtrl,
                decoration: const InputDecoration(
                  labelText: "Carrozza",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Media
              OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: Text(
                  mediaFile == null ? "Aggiungi foto / video" : "Media selezionato",
                ),
                onPressed: _pickMedia,
              ),
              const SizedBox(height: 16),
              const Text(
                "Ti ricordiamo che l’attivazione indebita di qualsiasi Alert verrà sanzionata a norma del D.P.R 753\80.\nUna volta confermato, il tuo Alert sarà ricevuto dalle Security Control Room di Fs Security che attiveranno tutti i protocolli necessari.",
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
            ],
          ),
        ),
        actions: [
          ConfirmButtons(
            onConfirm: () {
              Navigator.pop(context);
              _onConfirmSegnalazione(context);
            },
          ),
        ],
      ),
    );
  }




  Future<void> _onConfirmSegnalazione(BuildContext context) async {
  final segnalazioneService = SegnalazioneService();
  final trenoService = TrenoService();

  final trenoAsObj = await trenoService.getSingleTrenoByCodice(_trenoCtrl.text);
  final id = segnalazioneService.generateId();

  String? mediaB64;
  String? mediaFileName;

  if (mediaFile != null) {
    try {
      // Usa XFile.readAsBytes() con await
      final fileBytes = await mediaFile!.readAsBytes();
      if (fileBytes.isNotEmpty) {
        final mediaUrlAfterBlur = await segnalazioneService.blurMedia(
        fileBytes,
        originalFilename: mediaFile!.name,
      );
        /* mediaB64 = base64Encode(fileBytes); */
        mediaB64 = base64Encode(mediaUrlAfterBlur);
        mediaFileName = mediaFile?.name ?? 'allegato_${id}.bin';

      } else {
        print("File selezionato vuoto");
      }
    } catch (e) {
      print("Errore lettura file: $e");
    }
  }


  final segnalazione = Segnalazione(
    idNotifica: id,
    tipo: widget.title,
    treno: trenoAsObj ??
        Treno(
          codice: "FALLBACK_NO_TRAIN_FOUND",
          nCarrozze: "0",
          dataOraPartenza: "MAI",
          dataOraArrivo: "MAI",
          stazioni: ["Stazione1", "Stazione2", "Stazione3"]
        ),
    carrozza: _carrozzaCtrl.text,
    dataOraApertura: DateTime.now().toString().substring(0, 16),
    stato: 'APERTA',
    apertaDa: widget.currentUser,
    mediaUrl: mediaB64 ?? "",
    mediaFileName: mediaFileName ?? ""
  );

  await segnalazioneService.createSegnalazione(segnalazione);
  _showSuccessSnackBar(context);
}


  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.white),
            children: [
              const TextSpan(text: "Segnalazione inviata. Per visualizzarla premi "),
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
                        builder: (_) => NotificationsPage(
                          treno: _trenoCtrl.text,
                          carrozza: _carrozzaCtrl.text,
                          tipoSegnalazione: widget.title,
                          currentUser: widget.currentUser,
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
  }
}


