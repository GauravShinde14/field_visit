class CommentNotification {
  final String id;
  final String formId;
  final String comment;
  final String commentAt;
  final String commentBy;
  final String name;
  final String talukaId;

  CommentNotification({
    required this.id,
    required this.formId,
    required this.comment,
    required this.commentAt,
    required this.commentBy,
    required this.name,
    required this.talukaId,
  });

  factory CommentNotification.fromJson(Map<String, dynamic> json) {
    return CommentNotification(
      id: json['id'] ?? '',
      formId: json['form_id'] ?? '',
      comment: json['comment'] ?? '',
      commentAt: json['comment_at'] ?? '',
      commentBy: json['comment_by'] ?? '',
      name: json['name'] ?? '',
      talukaId: json['taluka_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_id': formId,
      'comment': comment,
      'comment_at': commentAt,
      'comment_by': commentBy,
      'name': name,
      'taluka_id': talukaId,
    };
  }

  @override
  String toString() {
    return 'CommentNotification(id: $id, formId: $formId, comment: "$comment", commentAt: $commentAt, commentBy: $commentBy, name: "$name", talukaId: $talukaId)';
  }
}
