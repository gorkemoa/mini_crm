import 'enums.dart';

class ReminderModel {
  final String id;
  final String title;
  final ReminderRelatedType? relatedType;
  final String? relatedId;
  final DateTime reminderDate;
  final bool isCompleted;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderModel({
    required this.id,
    required this.title,
    this.relatedType,
    this.relatedId,
    required this.reminderDate,
    this.isCompleted = false,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'related_type': relatedType?.name,
        'related_id': relatedId,
        'reminder_date': reminderDate.toIso8601String(),
        'is_completed': isCompleted ? 1 : 0,
        'note': note,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory ReminderModel.fromMap(Map<String, dynamic> map) => ReminderModel(
        id: map['id'] as String,
        title: map['title'] as String,
        relatedType: map['related_type'] != null
            ? ReminderRelatedType.values.firstWhere(
                (e) => e.name == map['related_type'],
                orElse: () => ReminderRelatedType.general,
              )
            : null,
        relatedId: map['related_id'] as String?,
        reminderDate: DateTime.parse(map['reminder_date'] as String),
        isCompleted: (map['is_completed'] as int?) == 1,
        note: map['note'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        ...toMap(),
        'is_completed': isCompleted,
        'related_type': relatedType?.name,
      };

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel.fromMap({
        ...json,
        'is_completed': (json['is_completed'] == true || json['is_completed'] == 1) ? 1 : 0,
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
  }) =>
      ReminderModel(
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

  bool get isOverdue =>
      !isCompleted && reminderDate.isBefore(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return reminderDate.year == now.year &&
        reminderDate.month == now.month &&
        reminderDate.day == now.day;
  }

  @override
  bool operator ==(Object other) => other is ReminderModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
