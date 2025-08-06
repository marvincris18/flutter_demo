class UserModel {
  final String id;
  final String name;
  final String email;
  final String? pictureUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.pictureUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pictureUrl: map['picture']?['data']?['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'pictureUrl': pictureUrl,
    };
  }
}