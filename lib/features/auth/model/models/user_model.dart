class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.birthDate,
    this.gender,
    this.status,
    this.role,
    this.token,
  });

  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? birthDate;
  final String? gender;
  final String? status;
  final String? role;
  final String? token;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      birthDate: json['birthDate'] as String?,
      gender: json['gender'] as String?,
      status: json['status'] as String?,
      role: json['role'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'birthDate': birthDate,
      'gender': gender,
      'status': status,
      'role': role,
      'token': token,
    };
  }
}
