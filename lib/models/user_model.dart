class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String username;
  final String password;
  final String userType;
  final String isDeleted;
  final String createdAt;
  final String designation;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.username,
    required this.password,
    required this.userType,
    required this.isDeleted,
    required this.createdAt,
    required this.designation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      userType: json['user_type'] ?? '',
      isDeleted: json['isdeleted'] ?? '',
      createdAt: json['created_at'] ?? '',
      designation: json['designation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'username': username,
      'password': password,
      'user_type': userType,
      'isdeleted': isDeleted,
      'created_at': createdAt,
      'designation': designation,
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, mobile: $mobile, email: $email, username: $username, '
        'password: $password, userType: $userType, isDeleted: $isDeleted, createdAt: $createdAt),designation: $designation)';
  }
}
