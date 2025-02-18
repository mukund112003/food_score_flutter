class UserModel {
  String? sId;
  String? fullName;
  String? email;
  String? phoneNumber; 
  String? image;// Keep nullable if not always present

  UserModel({this.sId, this.fullName, this.email, this.phoneNumber, this.image});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? ''; // Provide default value to avoid null issues
    fullName = json['fullName'] ?? ''; // Ensure key matches API response
    email = json['email'] ?? '';
    phoneNumber = json['phoneNumber']; 
    image  = json['image']; // If missing, it remains null
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'image' : image
    };
  }
}
