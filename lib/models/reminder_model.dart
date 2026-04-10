enum ReminderRelatedType {
  client,
  debt,
  project,
  lead,
  general;

  String get label {
    switch (this) {
      case ReminderRelatedType.client:
        return 'Müşteri';
      case ReminderRelatedType.debt:
        return 'Alacak';
      case ReminderRelatedType.project:
        return 'Proje';
      case ReminderRelatedType.lead:
        return 'Lead';
      case ReminderRelatedType.general:
        return 'Genel';
    }
  }

  static ReminderRelatedType fromString(String value) {
    return ReminderRelatedType.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ReminderRelatedType.general,
    );
  }
}

class ReminderModel {
  final String id;
  final String title;
  final ReminderRelatedType relatedType;
  final String? relatedId;
  final DateTime reminderDate;
  final bool isCompleted;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderModel({
    required this.id,
    required this.title,
    required this.relatedType,
    this.relatedId,
    required this.reminderDate,
    required this.isCompleted,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  ReminderModel copyWith({
    String? id,
    String? title,
    ReminderRelatedType? relatedType,
    String? relatedId,
    DateTime? reminderDate,
    bool? isCompleted,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      relatedType: relatedType ?? this.relatedType,
      relatedId: relatedId ?? this.relatedId,
      reminderDate: reminderDate ?? this.reminderDate,
      isCompleted: isCompleted ?? this.isCompleted,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'related_type': relatedType.name,
      'related_id': relatedId,
      'reminder_date': reminderDate.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'] as String,
      title: map['title'] as String,
      relatedType: ReminderRelatedType.fromString(map['related_type'] as String),
      relatedId: map['related_id'] as String?,
      reminderDate: DateTime.parse(map['reminder_date'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      ReminderModel.fromMap(json);

  bool get isOverdue {
    if (isCompleted) return false;
    return reminderDate.isBefore(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    return reminderDate.year == now.year &&
        reminderDate.month == now.month &&
        reminderDate.day == now.day;
  }
}
