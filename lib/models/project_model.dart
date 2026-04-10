enum ProjectStatus {
  planned,
  startingSoon,
  active,
  paused,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case ProjectStatus.planned:
        return 'Planlandı';
      case ProjectStatus.startingSoon:
        return 'Yakında Başlıyor';
      case ProjectStatus.active:
        return 'Aktif';
      case ProjectStatus.paused:
        return 'Duraklatıldı';
      case ProjectStatus.completed:
        return 'Tamamlandı';
      case ProjectStatus.cancelled:
        return 'İptal Edildi';
    }
  }

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ProjectStatus.planned,
    );
  }
}

class ProjectModel {
  final String id;
  final String clientId;
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

  // Joined
  final String? clientName;

  const ProjectModel({
    required this.id,
    required this.clientId,
    required this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.budget,
    required this.currency,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
    this.clientName,
  });

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
    String? clientName,
  }) {
    return ProjectModel(
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
      clientName: clientName ?? this.clientName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, {String? clientName}) {
    return ProjectModel(
      id: map['id'] as String,
      clientId: map['client_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      startDate: map['start_date'] != null
          ? DateTime.parse(map['start_date'] as String)
          : null,
      endDate: map['end_date'] != null
          ? DateTime.parse(map['end_date'] as String)
          : null,
      budget: map['budget'] != null ? (map['budget'] as num).toDouble() : null,
      currency: map['currency'] as String,
      status: ProjectStatus.fromString(map['status'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      clientName: clientName ?? map['client_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      ProjectModel.fromMap(json);
}
