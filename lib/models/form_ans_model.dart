class FormAnsModel {
  final String id;
  final String createdAt;
  final String officeType;
  final String taluka;
  final String village;
  final List<FormAnswer> formAnswers;

  FormAnsModel({
    required this.id,
    required this.createdAt,
    required this.officeType,
    required this.taluka,
    required this.village,
    required this.formAnswers,
  });

  factory FormAnsModel.fromJson(Map<String, dynamic> json) {
    return FormAnsModel(
      id: json['id'],
      createdAt: json['created_at'],
      officeType: json['office_type'],
      taluka: json['taluka'],
      village: json['village'],
      formAnswers: (json['form_answers'] as List)
          .map((e) => FormAnswer.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'FormAnsModel(id: $id, createdAt: $createdAt, officeType: $officeType, '
        'taluka: $taluka, village: $village, formAnswers: $formAnswers)';
  }
}

class FormAnswer {
  final String label;
  final String answer;
  final String type;

  FormAnswer({
    required this.label,
    required this.answer,
    required this.type,
  });

  factory FormAnswer.fromJson(Map<String, dynamic> json) {
    return FormAnswer(
      label: json['label'],
      answer: json['answer'],
      type: json['type'],
    );
  }

  @override
  String toString() {
    return '{label: $label, answer: $answer, type: $type}';
  }
}
