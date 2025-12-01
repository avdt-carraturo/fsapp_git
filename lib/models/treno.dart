class Treno {
  final String codice;
  final String nCarrozze;
  final String dataOraPartenza;
  final String dataOraArrivo;

  String get id => "${codice}_$dataOraPartenza";

  Treno({
    required this.codice,
    required this.nCarrozze,
    required this.dataOraPartenza,
    required this.dataOraArrivo,
  });

  Map<String, dynamic> toJson() => {
        'codice': codice,
        'nCarrozze': nCarrozze,
        'dataOraPartenza': dataOraPartenza,
        'dataOraArrivo': dataOraArrivo,
      };

  factory Treno.fromJson(String id, Map<String, dynamic> json) {
    return Treno(
      codice: json['codice'],
      dataOraPartenza: json['dataOraPartenza'],
      nCarrozze: json['nCarrozze'],
      dataOraArrivo: json['dataOraArrivo'],
    );
  }

  factory Treno.fromJsonNoId(Map<String, dynamic> json) {
    return Treno(
      codice: json['codice'],
      dataOraPartenza: json['dataOraPartenza'],
      nCarrozze: json['nCarrozze'],
      dataOraArrivo: json['dataOraArrivo'],
    );
  }
}
