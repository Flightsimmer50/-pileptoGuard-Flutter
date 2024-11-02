class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  int? phoneNumber;
  String? role;


  UserModel(
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.image,
      this.phoneNumber,
      this.role,
      );

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    image = json['image'];
    phoneNumber = json['phoneNumber'];
    role = json['role'];

  }

}
