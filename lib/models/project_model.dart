import 'enums.dart';

class ProjectModel {
  final String id;
  final String? clientId;
  final String title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budget;
  final String currency;
  final ProjectStatus status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectModel({
    required this.id,
    this.clientId,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.budget,
    this.currency = 'USD',
    this.status = ProjectStatus.planned,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'client_id': clientId,
        'title': title,
        'description': description,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'budget': budget,
        'currency': currency,
        'status': status.name,
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ProjectModel.fromMap(Map<String, dynamic> map) => ProjectModel(
        id: map['id'] as String,
        clientId: map['client_id'] as String?,
        title: map['title'] as String,
        description: map['description'] as String?,
        startDate: map['start_date'] != null ? DateTime.tryParse(map['start_date'] as String) : null,
        endDate: map['end_date'] != null ? DateTime.tryParse(map['end_date'] as String) : null,
        budget: map['budget'] != null ? (map['budget'] as num).toDouble() : null,
        currency: map['currency'] as String? ?? 'USD',
        status: ProjectStatus.values.firstWhere(
          (e) => e.name == map['status'],
          orElse: () => ProjectStatus.planned,
        ),
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => toMap();
  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel.fromMap(json);

  ProjectModel copyWith({
    String? id,
    String? clientId,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    String? currency,
    ProjectStatus? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ProjectModel(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        budget: budget ?? this.budget,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) => other is ProjectModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
