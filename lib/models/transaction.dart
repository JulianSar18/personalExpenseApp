class Transaction {
  final String id;
  final String titulo;
  final double monto;
  final DateTime fecha;

  Transaction(
      {required this.id,
      required this.titulo,
      required this.monto,
      required this.fecha});

}
