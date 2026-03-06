class MasterApplication {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  MasterApplication({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory MasterApplication.fromJson(Map<String, dynamic> json) {
    return MasterApplication(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }
}
