class UserModel {
  final String uid;
  final String name;
  final String email;
  final String mobileNumber;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.mobileNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'mobileNumber': mobileNumber};
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? mobileNumber,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
