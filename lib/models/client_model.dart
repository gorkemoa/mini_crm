import 'enums.dart';

class ClientModel {
  final String id;
  final String fullName;
  final String? companyName;
  final String? email;
  final String? phone;
  final String? notes;
  final ClientStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientModel({
    required this.id,
    required this.fullName,
    this.companyName,
    this.email,
    this.phone,
    this.notes,
    this.status = ClientStatus.active,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'company_name': companyName,
        'email': email,
        'phone': phone,
        'notes': notes,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ClientModel.fromMap(Map<String, dynamic> map) => ClientModel(
        id: map['id'] as String,
        fullName: map['full_name'] as String,
        companyName: map['company_name'] as String?,
        email: map['email'] as String?,
        phone: map['phone'] as String?,
        notes: map['notes'] as String?,
        status: ClientStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => ClientStatus.active,
        ),
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => toMap();
  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel.fromMap(json);

  ClientModel copyWith({
    String? id,
    String? fullName,
    String? companyName,
    String? email,
    String? phone,
    String? notes,
    ClientStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ClientModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        companyName: companyName ?? this.companyName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        notes: notes ?? this.notes,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) => other is ClientModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
