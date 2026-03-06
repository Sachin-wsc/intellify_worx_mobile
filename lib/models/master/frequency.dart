class MasterFrequency {
  final String id;
  final double frequencyValue;
  final String unit;
  final bool isActive;

  MasterFrequency({
    required this.id,
    required this.frequencyValue,
    required this.unit,
    required this.isActive,
  });

  factory MasterFrequency.fromJson(Map<String, dynamic> json) {
    return MasterFrequency(
      id: json['id'] as String,
      frequencyValue: double.parse(json['frequencyValue']?.toString() ?? json['frequency_value']?.toString() ?? '0'),
      unit: json['unit'] as String? ?? 'Hz',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }
}
