import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_links/app_links.dart';

import 'package:fsapp/firebase_options.dart';
import 'package:fsapp/pages/register_page.dart';
import 'package:fsapp/pages/home_page.dart';
import 'package:fsapp/pages/map_page.dart';
import 'package:fsapp/pages/notifications_page.dart';
import 'package:fsapp/widgets/footer_nav.dart';
import 'package:fsapp/widgets/scan_result_dialog.dart';
import 'package:fsapp/theme/app_theme.dart';
import 'package:fsapp/services/auth_wrapper.dart';
import 'package:fsapp_shared/shared.dart';
import 'package:fsapp/pages/personal_area.dart';


class MainNavigation extends StatefulWidget {
  final Utente? currentUser; // Utente loggato
  const MainNavigation({super.key, required this.currentUser});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late final AppLinks _appLinks;
  bool _deepLinksInitialized = false;

  String? qrSerial;
  String? qrCarriage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _setupDeepLinks(); 
  });
  }

  Future<void> _setupDeepLinks() async {
    if (_deepLinksInitialized) return;
    _deepLinksInitialized = true;

    if (kIsWeb) {
      final uri = Uri.base;
      if (_isValidDeepLink(uri)) _processUri(uri);
      return;
    }

    _appLinks = AppLinks();
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _processUri(initialUri);

      _appLinks.uriLinkStream.listen(
        (uri) => _processUri(uri),
        onError: (err) => debugPrint("⚠ Deep link error: $err"),
      );
    } catch (e) {
      debugPrint("❌ Deep link init error: $e");
    }
  }

  bool _isValidDeepLink(Uri uri) {
    return (uri.scheme == "trenilog" && uri.host == "scan") ||
           (uri.fragment.startsWith("trenilog://scan")) ||
           (uri.queryParameters["trenilog"] == "scan");
  }

  void _processUri(Uri uri) {
    String? serial = uri.queryParameters["serial"];
    String? carriage = uri.queryParameters["carriage"];

    if (serial == null || carriage == null) return;
  if (widget.currentUser == null) {
    // Utente non loggato → blocca l'azione o mostra un messaggio
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Devi effettuare il login per aprire una segnalazione."),
        backgroundColor: Colors.red,
      ),
    );
    return; // esci dalla funzione
  }

  // Se siamo qui, currentUser non è null
  final canOpen = TicketValidator.canOpenReport(
    user: widget.currentUser!, // il ! è sicuro perché abbiamo già controllato
    treno: serial,
    carrozza: carriage,
  );

  if (!canOpen) {
  // blocca apertura segnalazione
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Segnalazione non consentita"),
      content: Text(
        "Non puoi aprire una segnalazione per il treno $serial.\n"
        "Verifica di avere un biglietto valido.",
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ],
    ),
  );
  return;
  }

    qrSerial = serial;
    qrCarriage = carriage;

    setState(() => _selectedIndex = 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScanResultDialog.show(
        context,
        serial: serial,
        carriage: carriage,
        currentUser: widget.currentUser!
      );
    });
  }

  List<Widget> get pages => [
        HomePage(
          serial: qrSerial,
          carriage: qrCarriage,
          currentUser: widget.currentUser!, 
        ),
        const MapPage(),
        NotificationsPage(
          treno: qrSerial,
          carrozza: qrCarriage,
          currentUser: widget.currentUser,
        ),
        AreaPersonalePage(utente: widget.currentUser),
      ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: FooterNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}