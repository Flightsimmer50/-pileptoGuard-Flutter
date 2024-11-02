class User {
  final String idUser;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String image;
  final String phoneNumber;
  final String role;
  final DateTime? birthDate;
  final int? resetCode;
  final List<dynamic>? numP;
  final double? weight;
  final double? height;
  final String? doctor;
  bool? isActivated;

  User({
    required this.idUser,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.image,
    required this.phoneNumber,
    required this.role,
    this.birthDate,
    this.resetCode,
    this.numP,
    this.weight,
    this.height,
    this.doctor,
    this.isActivated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        idUser: json['idUser'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
        image: json['image'],
        phoneNumber: json['phoneNumber'],
        role: json['role'],
        birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
        resetCode: json['resetCode'],
        numP: json['numP'] != null ? List<dynamic>.from(json['numP']) : null,
        weight: json['weight']  ? json['weight'].toDouble() : null,
        height: json['height']  ? json['height'].toDouble() : null,
        doctor: json['doctor'],
        isActivated: json['isActivated']
    );
  }

}
