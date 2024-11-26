import 'package:acesso_mapeado/models/accessibility_model.dart';
import 'package:acesso_mapeado/models/comment_model.dart';
import 'package:color_blindness/color_blindness.dart';

class UserModel {
  final String name;
  final String email;
  final bool isCompany;
  final String cpf;
  final String? profilePictureUrl;
  final AccessibilityModel? accessibilityData;
  final List<CommentModel>? commentsData;
  final DateTime dateOfBirth;
  final DateTime registrationDate;
  final ColorBlindnessType? colorBlindnessType;

  UserModel({
    required this.name,
    required this.email,
    required this.isCompany,
    required this.cpf,
    this.profilePictureUrl,
    this.accessibilityData,
    this.commentsData,
    required this.dateOfBirth,
    required this.registrationDate,
    this.colorBlindnessType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        email: json['email'],
        isCompany: json['isCompany'],
        cpf: json['cpf'],
        profilePictureUrl: json['profilePictureUrl'],
        accessibilityData: json['accessibilityData'] != null
            ? AccessibilityModel.fromJson(json['accessibilityData'])
            : null,
        commentsData:
            json['commentsData'] != null && json['commentsData'] is List
                ? (json['commentsData'] as List)
                    .map((item) => CommentModel.fromJson(item))
                    .toList()
                : null,
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        registrationDate: DateTime.parse(json['registrationDate']),
        colorBlindnessType: json['colorBlindnessType'] != null
            ? ColorBlindnessType.values.byName(json['colorBlindnessType'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isCompany': isCompany,
      'cpf': cpf,
      'profilePictureUrl': profilePictureUrl,
      'accessibilityData': accessibilityData?.toJson(),
      'commentsData': commentsData?.map((item) => item.toJson()).toList(),
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'registrationDate': registrationDate.toIso8601String(),
      'colorBlindnessType': colorBlindnessType?.name,
    };
  }
}
