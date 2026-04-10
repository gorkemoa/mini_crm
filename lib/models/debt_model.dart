enum DebtStatus {
  pending,
  overdue,
  paid,
  partial;

  String get label {
    switch (this) {
      case DebtStatus.pending:
        return 'Bekliyor';
      case DebtStatus.overdue:
        return 'Gecikmiş';
      case DebtStatus.paid:
        return 'Ödendi';
      case DebtStatus.partial:
        return 'Kısmi Ödeme';
    }
  }

  static DebtStatus fromString(String value) {
    return DebtStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => DebtStatus.pending,
    );
  }
}

class DebtModel {
  final String id;
  final String clientId;
  final String title;
  final double amount;
  final String currency;
  final DateTime? dueDate;
  final DebtStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined — not stored in DB
  final String? clientName;

  const DebtModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.amount,
    required this.currency,
    this.dueDate,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.clientName,
  });

  DebtModel copyWith({
    String? id,
    String? clientId,
    String? title,
    double? amount,
    String? currency,
    DateTime? dueDate,
    DebtStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientName,
  }) {
    return DebtModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientName: clientName ?? this.clientName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'title': title,
      'amount': amount,
      'currency': currency,
      'due_date': dueDate?.toIso8601String(),
      'status': status.name,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DebtModel.fromMap(Map<String, dynamic> map, {String? clientName}) {
    return DebtModel(
      id: map['id'] as String,
      clientId: map['client_id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'] as String)
          : null,
      status: DebtStatus.fromString(map['status'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      clientName: clientName ?? map['client_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory DebtModel.fromJson(Map<String, dynamic> json) =>
      DebtModel.fromMap(json);

  bool get isOverdue {
    if (dueDate == null) return false;
    if (status == DebtStatus.paid) return false;
    return dueDate!.isBefore(DateTime.now());
  }
}
