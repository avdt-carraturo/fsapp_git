class Biglietto {
  final String id;
  final String utenteId;
  final String trenoId;
  final String validoDal;
  final String validoAl;
  final String carrozza;

  Biglietto({
    required this.id,
    required this.utenteId,
    required this.trenoId,
    required this.validoDal,
    required this.validoAl,
    required this.carrozza,
  });

  Map<String, dynamic> toJson() => {
        'utenteId': utenteId,
        'trenoId': trenoId,
        'validoDal': validoDal,
        'validoAl': validoAl,
        'carrozza': carrozza,
      };

  factory Biglietto.fromJson(String id, Map<String, dynamic> json) =>
      Biglietto(
        id: id,
        utenteId: json['utenteId'],
        trenoId: json['trenoId'],
        validoDal: json['validoDal'],
        validoAl: json['validoAl'],
        carrozza: json['carrozza'],
      );
}
