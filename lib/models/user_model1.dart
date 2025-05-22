import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? name;
  String? email;
  String? status;
  String? userType;
  String? frontImageUrl;
  String? backImageUrl;
  String? profilePic;
  String? token;
  String? country;
  String? gender;
  bool? isUserNew;
  bool? isBlocked;
  List<String>? languages;
  int? likeCount;
  String? city;
  String? occupation;
  String? phone;
  int? uniqueId;
  String? voiceRecording;
  DateTime? createdDate;
  String? street;
  String? apartment;
  List<String>? interests;
  List<String>? detailedInterests;
  UserModel({
    this.userId,
    this.name,
    this.email,
    this.status,
    this.userType,
    this.frontImageUrl,
    this.backImageUrl,
    this.profilePic = '',
    this.token,
    this.country,
    this.gender,
    this.isUserNew,
    this.isBlocked,
    this.languages,
    this.likeCount = 0,
    this.city,
    this.occupation,
    this.phone,
    this.uniqueId,
    this.voiceRecording,
    this.createdDate,
    this.street,
    this.apartment,
    this.interests,
    this.detailedInterests,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['regId'] ?? "",
      name: json['firstName'] ?? "",
      email: json['email'] ?? "",
      status: json['status'] ?? "",
      userType: json['userType'] ?? "",
      frontImageUrl: json['frontImageUrl'] ?? "",
      backImageUrl: json['backImageUrl'] ?? "",
      profilePic: json['profilePic'] ?? "",
      token: json['token'] ?? "",
      country: json['country'] ?? "",
      gender: json['gender'] ?? "",
      isUserNew: json['isUserNew'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      languages: List<String>.from(json['languages'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      city: json['city'] ?? "",
      occupation: json['occupation'] ?? "",
      phone: json['phone'] ?? "",
      uniqueId: json['uniqueId'] ?? 0,
      voiceRecording: json['voiceRecording'] ?? "",
      createdDate: json['createdDate'] != null
          ? (json['createdDate'] as Timestamp).toDate()
          : null,
      street: json['street'] ?? "",
      apartment: json['apartment']?.toString() ?? "",
      interests: List<String>.from(json['interests'] ?? []),
      detailedInterests: List<String>.from(json['detailedInterests'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'regId': userId,
      'firstName': name,
      'email': email,
      'status': status,
      'userType': userType,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
      'profilePic': profilePic,
      'token': token,
      'countrys': country,
      'gender': gender,
      'isUserNew': isUserNew,
      'isBlocked': isBlocked,
      'languages': languages,
      'likeCount': likeCount,
      'city': city,
      'occupation': occupation,
      'phone': phone,
      'uniqueId': uniqueId,
      'voiceRecording': voiceRecording,
      'createdDate': createdDate?.toIso8601String(),
      'street': street,
      'apartment': apartment,
      'interests': interests,
      'detailedInterests': detailedInterests,
    };
  }
}
