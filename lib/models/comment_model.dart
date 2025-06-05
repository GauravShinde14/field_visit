class CommentModel {
  final String id;
  final String comment;
  final String commentAt;
  final String? remark;
  final String remarkImage;
  final String remarkAt;
  final String commentByName;
  final String role;

  CommentModel({
    required this.id,
    required this.comment,
    required this.commentAt,
    this.remark,
    required this.remarkImage,
    required this.remarkAt,
    required this.commentByName,
    required this.role,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      comment: json['comment'] ?? '',
      commentAt: json['comment_at'] ?? '',
      remark: json['remark'],
      remarkImage: json['remark_image'] ?? '',
      remarkAt: json['remark_at'] ?? '',
      commentByName: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'comment_at': commentAt,
      'remark': remark,
      'remark_image': remarkImage,
      'remark_at': remarkAt,
      'comment_by_name': commentByName,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'CommentModel(comment id : $id,comment: $comment, commentAt: $commentAt, remark: $remark, remarkImage: $remarkImage, remarkAt: $remarkAt, commentByName: $commentByName, role: $role)';
  }
}
