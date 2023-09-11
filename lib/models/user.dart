// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.token,
    required this.lat,
    required this.long,
    required this.address,
  });

  String firstName;
  String lastName;
  String email;
  String phone;
  String token;
  double lat;
  double long;
  String address;

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        token: json["token"],
        long: json["lat"],
        lat: json["long"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "lat": lat,
        "long": long,
        "address": address,
      };

  @override
  String toString() {
    return "first_name: $firstName\n"
        "last_name: $lastName\n"
        "email: $email\n"
        "phone: $phone\n"
        "lat: $lat\n"
        "long: $long\n"
        "address: $address\n";
  }
}
