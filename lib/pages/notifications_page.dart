import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  final String? treno;
  final String? carrozza;
  final String? tipoSegnalazione;
  final Utente? currentUser;

  const NotificationsPage({
    super.key,
    required this.treno,
    required this.carrozza,
    this.tipoSegnalazione,
    this.currentUser

  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<dynamic, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
  final segnalazioneService = SegnalazioneService();
  
  
  final segnalazioni = await segnalazioneService
      .getSegnalazioniByUserAndDatePeriod(widget.currentUser!.email);

  if (segnalazioni.isNotEmpty) {
    notifications = segnalazioni.map((s) {
      return {
        "idNotifica": s.idNotifica,
        "dataOra": s.dataOraApertura,
        "treno": s.treno,
        "carrozza": s.carrozza,
        "tipo": s.tipo,
        "stato": s.stato,
        "note": s.note ?? "",
        "canUpdate": (s.stato == "APERTA").toString()
      };
    }).toList();

    setState(() {});
    return;
  }else{
notifications = [
    
  ];

  }
  
  setState(() {});
}


  void _openEditForm(int index) {
    final item = notifications[index];
    
    final trenoCtrl = TextEditingController(text: (item["treno"] as Treno).codice);
    final carrozzaCtrl = TextEditingController(text: item["carrozza"] ?? "");
    final tipoCtrl = TextEditingController(text: item["tipo"] ?? "");
    final noteCtrl = TextEditingController(text: item['note'] ?? "");

    final bool trenoLocked = item["treno"] != null;
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifica Segnalazione"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: !trenoLocked,
                controller: trenoCtrl,
                decoration: const InputDecoration(labelText: "Treno"),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9 \-]")),
                ],
              ),
              TextField(
                controller: carrozzaCtrl,
                decoration: const InputDecoration(labelText: "Carrozza"),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9 \-]")),
                ],
              ),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: "Note aggiuntive"),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9 \-]")),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Annulla"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Salva"),
              onPressed: () async {
                setState(() {
                  if(!trenoLocked){ item["treno"].codice = trenoCtrl.text; }
                  item["carrozza"] = carrozzaCtrl.text;
                  item["tipo"] = tipoCtrl.text;
                  item['note'] = noteCtrl.text;
                });
                final id = item["idNotifica"];
                final canUpdate = item["canUpdate"];
                final dataToUpdate = {
                "treno": (item["treno"] as Treno).toJson(),
                "carrozza": item["carrozza"],
                "tipo": item["tipo"],
                "note": item["note"],
                "dataOraAggiornamento": DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())
                };

                final segnalazioneService = SegnalazioneService();
                if(canUpdate == "true"){
                    await segnalazioneService.updateSegnalazione(id!, dataToUpdate);
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Segnalazione aggiornata, puoi continuare a modificare finché questa non viene avanzata dal responsabile che l'ha presa in carico")),
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;

  return Scaffold(
    appBar: AppBar(title: const Text('Notifiche')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isMobile 
          ? _buildMobileList()
          : _buildDesktopTable(),
    ),
  );
}

///   VERSIONE TABELLA MOBILE
Widget _buildMobileList() {
  return ListView.builder(
    itemCount: notifications.length,
    itemBuilder: (context, index) {
      final n = notifications[index];

      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row("Data/Ora", n["dataOra"]),
              _row("Treno", (n["treno"] as Treno).codice),
              _row("Carrozza", n["carrozza"]),
              _row("Tipo", n["tipo"]),
              _row("Stato", n["stato"], valueColor: Colors.orange),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openEditForm(index),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget _row(String label, String? value, {Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Flexible(
          child: Text(
            value ?? "",
            textAlign: TextAlign.right,
            style: TextStyle(color: valueColor),
          ),
        )
      ],
    ),
  );
}

///   VERSIONE TABELLA DESKTOP
Widget _buildDesktopTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.blueGrey.shade100),
      columns: const [
        DataColumn(label: Text("DATA/ORA")),
        DataColumn(label: Text("TRENO")),
        DataColumn(label: Text("CARROZZA")),
        DataColumn(label: Text("TIPO SEGNALAZIONE")),
        DataColumn(label: Text("STATO")),
        DataColumn(label: Text("AZIONI")),
      ],
      rows: List.generate(
        notifications.length,
        (index) {
          final n = notifications[index];
          return DataRow(
            cells: [
              DataCell(Text(n["dataOra"] ?? "")),
              DataCell(Text((n["treno"] as Treno).codice)),
              DataCell(Text(n["carrozza"] ?? "")),
              DataCell(Text(n["tipo"] ?? "")),
              DataCell(
                Text(
                  n["stato"] ?? "",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openEditForm(index),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
}
