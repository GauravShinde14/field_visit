class VillageModel {
  final String villageId;
  final String villageName;

  VillageModel({
    required this.villageId,
    required this.villageName,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      villageId: json['village_id'].toString(),
      villageName: json['village_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'village_name': villageName,
    };
  }

  factory VillageModel.fromMap(Map<String, dynamic> map) {
    return VillageModel(
      villageId: map['village_id'],
      villageName: map['village_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'village_id': villageId,
      'village_name': villageName,
    };
  }

  @override
  String toString() {
    return 'VillageModel(villageId: $villageId, villageName: $villageName)';
  }
}
