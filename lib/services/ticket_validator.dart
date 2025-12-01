import 'package:fsapp_shared/shared.dart';
import 'package:intl/intl.dart';

class TicketValidator {
  final authService = AuthService();

  /// Restituisce il biglietto valido per un utente già loggato
  static Biglietto? getCurrentValidTicket(Utente user) {
    final now = DateTime.now();

    final biglietti = user.biglietti;
    if (biglietti == null || biglietti.isEmpty) return null;

    for (final t in biglietti) {
      String startWithT = t.validoDal.substring(0, 8) + 'T' + t.validoDal.substring(8);
      String endWithT = t.validoAl.substring(0, 8) + 'T' + t.validoAl.substring(8);
      final dal = DateTime.parse(startWithT.toString().trim());
      final al = DateTime.parse(endWithT.toString().trim());

      if (now.isAfter(dal) && now.isBefore(al)) {
        return t; // Trovato biglietto valido
      }
    }

    return null;
  }

  /// Restituisce true se l’utente può aprire una segnalazione
  static bool canOpenReport({
    required Utente user,
    required String? treno,
    String? carrozza, // opzionale
  }) {
    if (treno == null || treno.isEmpty) return false;

    if (user.tipo != "P") return true; // ruoli operatori possono sempre aprire segnalazioni

    final currentTicket = getCurrentValidTicket(user);
    if (currentTicket == null) return false;

    return currentTicket.trenoId == treno;
  }

  /// Metodo async per login con email/password
  Future<Utente?> login(String email, String password) async {
    return await authService.login(email, password);
  }
}
