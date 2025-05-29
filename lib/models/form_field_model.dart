class FormFieldModel {
  final String id;
  final String officeType;
  final String type;
  final String label;
  final String? attribute;
  final bool required;
  final String dropdownValue;

  FormFieldModel({
    required this.id,
    required this.officeType,
    required this.type,
    required this.label,
    this.attribute,
    required this.required,
    required this.dropdownValue,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'],
      officeType: json['office_type'],
      type: json['type'],
      label: json['label'],
      attribute: json['attribute'],
      required: json['required'] == 'yes',
      dropdownValue: json['dropdown_value'],
    );
  }
}
