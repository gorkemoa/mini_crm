enum ClientStatus {
  active,
  inactive,
  lost;

  String get label {
    switch (this) {
      case ClientStatus.active:
        return 'Aktif';
      case ClientStatus.inactive:
        return 'Pasif';
      case ClientStatus.lost:
        return 'Kaybedildi';
    }
  }

  static ClientStatus fromString(String value) {
    return ClientStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ClientStatus.active,
    );
  }
}

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
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

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
  }) {
    return ClientModel(
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
  }

  Map<String, dynamic> toMap() {
    return {
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
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      companyName: map['company_name'] as String?,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      notes: map['notes'] as String?,
      status: ClientStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      ClientModel.fromMap(json);

  String get displayName =>
      companyName != null && companyName!.isNotEmpty
          ? '$fullName · $companyName'
          : fullName;

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}
