class MasterPole {
  final String id;
  final String poleNumber;
  final bool isActive;

  MasterPole({
    required this.id,
    required this.poleNumber,
    required this.isActive,
  });

  factory MasterPole.fromJson(Map<String, dynamic> json) {
    return MasterPole(
      id: json['id'] as String,
      poleNumber: json['poleNumber'] as String? ?? json['pole_number'] as String,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }
}
