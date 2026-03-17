class UserModel {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String institutionName;
  final String passwordHash;

  UserModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.institutionName,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'institutionName': institutionName,
        'passwordHash': passwordHash,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        institutionName: json['institutionName'] as String,
        passwordHash: json['passwordHash'] as String,
      );

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? institutionName,
    String? passwordHash,
  }) =>
      UserModel(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        institutionName: institutionName ?? this.institutionName,
        passwordHash: passwordHash ?? this.passwordHash,
      );
}
