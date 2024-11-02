class PatientsModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  int? phoneNumber;
  DateTime? birthDate;
  int? weight;
  int? height;

  PatientsModel(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.phoneNumber,
    this.birthDate,
    this.weight,
    this.height,
  );

  PatientsModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    image = json['image'];
    phoneNumber = json['phoneNumber'];
    birthDate = json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null;
    weight = json['weight'];
    height = json['height'];
  }

}
