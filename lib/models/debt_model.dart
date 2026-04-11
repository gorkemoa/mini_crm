import 'enums.dart';

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

  const DebtModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.amount,
    this.currency = 'USD',
    this.dueDate,
    this.status = DebtStatus.pending,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
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

  factory DebtModel.fromMap(Map<String, dynamic> map) => DebtModel(
        id: map['id'] as String,
        clientId: map['client_id'] as String,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        currency: map['currency'] as String? ?? 'USD',
        dueDate: map['due_date'] != null ? DateTime.tryParse(map['due_date'] as String) : null,
        status: DebtStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => DebtStatus.pending,
        ),
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => toMap();
  factory DebtModel.fromJson(Map<String, dynamic> json) => DebtModel.fromMap(json);

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
  }) =>
      DebtModel(
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
      );

  bool get isOverdue =>
      dueDate != null &&
      status == DebtStatus.pending &&
      dueDate!.isBefore(DateTime.now());

  @override
  bool operator ==(Object other) => other is DebtModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
