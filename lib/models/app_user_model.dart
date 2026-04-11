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

  Map<String, dynamic> toJson() => {
        'id': id,
        'display_name': displayName,
        'email': email,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory AppUserModel.fromJson(Map<String, dynamic> json) => AppUserModel(
        id: json['id'] as String,
        displayName: json['display_name'] as String?,
        email: json['email'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );
}
