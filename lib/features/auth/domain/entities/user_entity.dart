class UserEntity {
  final String name;
  final String email;
  final String role;

  const UserEntity({
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}

//user entity to json
extension UserEntityToJson on UserEntity {
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role};
  }
}
