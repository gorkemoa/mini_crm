enum LeadStage {
  newLead,
  contacted,
  proposalSent,
  negotiating,
  won,
  lost;

  String get label {
    switch (this) {
      case LeadStage.newLead:
        return 'Yeni Lead';
      case LeadStage.contacted:
        return 'İletişime Geçildi';
      case LeadStage.proposalSent:
        return 'Teklif Gönderildi';
      case LeadStage.negotiating:
        return 'Görüşmede';
      case LeadStage.won:
        return 'Kazanıldı';
      case LeadStage.lost:
        return 'Kaybedildi';
    }
  }

  static LeadStage fromString(String value) {
    return LeadStage.values.firstWhere(
      (s) => s.name == value,
      orElse: () => LeadStage.newLead,
    );
  }
}

class LeadModel {
  final String id;
  final String name;
  final String? source;
  final LeadStage stage;
  final double? estimatedBudget;
  final String currency;
  final DateTime? nextFollowUpDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LeadModel({
    required this.id,
    required this.name,
    this.source,
    required this.stage,
    this.estimatedBudget,
    required this.currency,
    this.nextFollowUpDate,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  LeadModel copyWith({
    String? id,
    String? name,
    String? source,
    LeadStage? stage,
    double? estimatedBudget,
    String? currency,
    DateTime? nextFollowUpDate,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LeadModel(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      stage: stage ?? this.stage,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      currency: currency ?? this.currency,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'source': source,
      'stage': stage.name,
      'estimated_budget': estimatedBudget,
      'currency': currency,
      'next_follow_up_date': nextFollowUpDate?.toIso8601String(),
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'] as String,
      name: map['name'] as String,
      source: map['source'] as String?,
      stage: LeadStage.fromString(map['stage'] as String),
      estimatedBudget: map['estimated_budget'] != null
          ? (map['estimated_budget'] as num).toDouble()
          : null,
      currency: map['currency'] as String,
      nextFollowUpDate: map['next_follow_up_date'] != null
          ? DateTime.parse(map['next_follow_up_date'] as String)
          : null,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => toMap();
  factory LeadModel.fromJson(Map<String, dynamic> json) =>
      LeadModel.fromMap(json);

  bool get isActive =>
      stage != LeadStage.won && stage != LeadStage.lost;
}
