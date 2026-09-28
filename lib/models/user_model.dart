class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  factory UserModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
}