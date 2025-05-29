class OfficeType {
  final String id;
  final String officeType;

  OfficeType({required this.id, required this.officeType});

  factory OfficeType.fromJson(Map<String, dynamic> json) {
    return OfficeType(
      id: json['id'],
      officeType: json['office_type'],
    );
  }
}
