class MasterVoltage {
  final String id;
  final double voltageValue;
  final String unit;
  final bool isActive;

  MasterVoltage({
    required this.id,
    required this.voltageValue,
    required this.unit,
    required this.isActive,
  });

  factory MasterVoltage.fromJson(Map<String, dynamic> json) {
    return MasterVoltage(
      id: json['id'] as String,
      voltageValue: double.parse(json['voltageValue']?.toString() ?? json['voltage_value']?.toString() ?? '0'),
      unit: json['unit'] as String? ?? 'V',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }
}
