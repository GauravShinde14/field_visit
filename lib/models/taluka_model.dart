class TalukaModel {
  final String id;
  final String taluka;

  TalukaModel({required this.id, required this.taluka});

  factory TalukaModel.fromJson(Map<String, dynamic> json) {
    return TalukaModel(
      id: json['id'],
      taluka: json['taluka'],
    );
  }
}
