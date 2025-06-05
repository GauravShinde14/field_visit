class FormFieldModel {
  final String id;
  final String officeType;
  final String type;
  final String label;
  final bool required;
  final String dropdownValue;

  FormFieldModel({
    required this.id,
    required this.label,
    required this.officeType,
    required this.type,
    required this.required,
    required this.dropdownValue,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id']?.toString() ?? '',
      label: json['label'] ?? '',
      officeType: json['office_type'] ?? '',
      type: json['type'] ?? 'text',
      required: (json['required']?.toString().toLowerCase() == 'yes'),
      dropdownValue: json['dropdown_value'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FormFieldModel('
        'id: $id, '
        'label: $label, '
        'type: $type, '
        'officeType: $officeType, '
        'required: $required, '
        'dropdownValue: $dropdownValue'
        ')';
  }
}
