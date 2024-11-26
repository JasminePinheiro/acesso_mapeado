import 'package:acesso_mapeado/models/accessibility_model.dart';
import 'package:acesso_mapeado/models/comment_model.dart';

class CompanyModel {
  String uuid;
  String name;
  String email;
  String? fantasyName;
  String cnpj;
  double? latitude;
  double? longitude;
  String address;
  String fullAddress;
  String? number;
  String? city;
  String? state;
  String? neighborhood;
  String? zipCode;
  String? imageUrl;
  double? rating;
  String? phoneNumber;
  String? instagramUrl;
  String? facebookUrl;
  String? twitterUrl;
  String? websiteUrl;
  String? youtubeUrl;
  String? tiktokUrl;
  String? pinterestUrl;
  String? linkedinUrl;
  List<WorkingHours>? workingHours;
  AccessibilityModel? accessibilityData;
  List<CommentModel>? commentsData;
  List<double>? ratings;
  String? registrationDate;
  String? about;

  CompanyModel({
    required this.uuid,
    required this.name,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.fullAddress,
    this.imageUrl,
    this.rating,
    this.number,
    this.city,
    this.state,
    this.neighborhood,
    this.zipCode,
    this.phoneNumber,
    this.instagramUrl,
    this.facebookUrl,
    this.twitterUrl,
    this.youtubeUrl,
    this.tiktokUrl,
    this.pinterestUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.workingHours,
    this.accessibilityData,
    this.commentsData,
    this.ratings,
    required this.cnpj,
    this.registrationDate,
    this.about,
  });

  // Método factory para criar instâncias de CompanyModel a partir de um JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      uuid: json["uuid"],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      address: json['address'] ?? '',
      fullAddress: json['fullAddress'],
      number: json['number'],
      city: json['city'],
      state: json['state'],
      neighborhood: json['neighborhood'],
      zipCode: json['zipCode'],
      imageUrl: json['imageUrl'],
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      phoneNumber: json['phoneNumber'],
      instagramUrl: json['instagramUrl'],
      facebookUrl: json['facebookUrl'],
      twitterUrl: json['twitterUrl'],
      youtubeUrl: json['youtubeUrl'],
      tiktokUrl: json['tiktokUrl'],
      pinterestUrl: json['pinterestUrl'],
      linkedinUrl: json['linkedinUrl'],
      websiteUrl: json['websiteUrl'],
      workingHours: json['workingHours'] != null && json['workingHours'] is List
          ? (json['workingHours'] as List)
              .map((item) => WorkingHours.fromJson(item))
              .toList()
          : null,
      accessibilityData: AccessibilityModel.fromJson(json['accessibilityData']),
      commentsData: json['commentsData'] != null && json['commentsData'] is List
          ? (json['commentsData'] as List)
              .map((item) => CommentModel.fromJson(item))
              .toList()
          : null,
      ratings: json['ratings'] != null && json['ratings'] is List
          ? (json['ratings'] as List)
              .map((item) => (item as num).toDouble())
              .toList()
          : [],
      cnpj: json['cnpj'] ?? '',
      registrationDate: json['registrationDate'],
      about: json['about'],
    );
  }

  // Método para converter instâncias de CompanyModel para JSON
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'fullAddress': fullAddress,
        'number': number,
        'city': city,
        'state': state,
        'neighborhood': neighborhood,
        'zipCode': zipCode,
        'imageUrl': imageUrl,
        'rating': rating,
        'phoneNumber': phoneNumber,
        'instagramUrl': instagramUrl,
        'facebookUrl': facebookUrl,
        'twitterUrl': twitterUrl,
        'youtubeUrl': youtubeUrl,
        'tiktokUrl': tiktokUrl,
        'pinterestUrl': pinterestUrl,
        'linkedinUrl': linkedinUrl,
        'websiteUrl': websiteUrl,
        'workingHours': workingHours?.map((item) => item.toJson()).toList(),
        'accessibilityData': accessibilityData?.toJson(),
        'commentsData':
            commentsData?.map((comment) => comment.toJson()).toList(),
        'ratings': ratings,
        'cnpj': cnpj,
        'registrationDate': registrationDate,
        'about': about,
      };
}

class WorkingHours {
  final String day;
  final String? open;
  final String? close;

  WorkingHours({required this.day, required this.open, required this.close});

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      day: json['day'],
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'open': open,
        'close': close,
      };
}
