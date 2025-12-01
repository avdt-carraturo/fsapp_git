import 'package:fsapp_shared/shared.dart';

class Utente {
  final String id;
  final String nominativo;
  final String email;
  final String password;
  final String tipo; // P = passeggero, O = operatore
  final String? area; //Solo per operatore
  final List<Biglietto> biglietti; // Lista di oggetti Biglietto - Solo per Passeggero

  Utente({
    required this.id,
    required this.nominativo,
    required this.email,
    required this.password,
    required this.tipo,
    this.area,
    List<Biglietto>? biglietti,
  }) : biglietti = biglietti ?? [];

  Map<String, dynamic> toJson() => {
        'nominativo': nominativo,
        'email': email,
        'password' : password,
        'tipo': tipo,
        'area': area,
        'biglietti': biglietti.map((b) => b.toJson()).toList(),
      };

  factory Utente.fromJson(String id, Map<String, dynamic> json) => Utente(
        id: id,
        nominativo: json['nominativo'],
        email: json['email'],
        password: json['password'],
        tipo: json['tipo'],
        area: json['area'],
        biglietti: (json['biglietti'] as List<dynamic>? ?? [])
            .map((b) => Biglietto.fromJson(b['id'] ?? '', b))
            .toList(),
      );
}
