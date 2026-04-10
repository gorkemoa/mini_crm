class IncomeModel {
  final String id;
  final String? sourcePlatform;
  final String? clientId;
  final double amount;
  final String currency;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined
  final String? clientName;

  const IncomeModel({
    required this.id,
    this.sourcePlatform,
    this.clientId,
    required this.amount,
    required this.currency,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.clientName,
  });

  IncomeModel copyWith({
    String? id,
    String? sourcePlatform,
    String? clientId,
    double? amount,
    String? currency,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientName,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      sourcePlatform: sourcePlatform ?? this.sourcePlatform,
      clientId: clientId ?? this.clientId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientName: clientName ?? this.clientName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'source_platform': sourcePlatform,
      'client_id': clientId,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map, {String? clientName}) {
    return IncomeModel(
      id: map['id'] as String,
      sourcePlatform: map['source_platform'] as String?,
      clientId: map['client_id'] as String?,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      clientName: clientName ?? map['client_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      IncomeModel.fromMap(json);
}
