class AppUserModel {
  final String id;
  final String? displayName;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUserModel({
    required this.id,
    this.displayName,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  AppUserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'] as String,
      displayName: map['display_name'] as String?,
      email: map['email'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      AppUserModel.fromMap(json);
}
