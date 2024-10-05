// models/company_model.dart
class CompanyModel {
  // Campos originais (não alterados)
  String name;
  double latitude;
  double longitude;
  String address; // Alterado de 'endereco' para 'address'

  // Campos adicionados (novidades) - agora são nullable
  String? imageUrl;
  double? rating;
  String? phoneNumber;
  String? workingHours;
  Map<String, List<Map<String, dynamic>>>? accessibilityData;
  List<Map<String, dynamic>>? commentsData;
  Map<String, dynamic>? performanceData;
  String? cnpj;
  String? registrationDate;
  String? about;

  CompanyModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl,
    this.rating,
    this.phoneNumber,
    this.workingHours,
    this.accessibilityData,
    this.commentsData,
    this.performanceData,
    this.cnpj,
    this.registrationDate,
    this.about,
  });

  // Método factory para criar instâncias de CompanyModel a partir de um JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        name: json['name'],
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        address: json['address'],
        imageUrl: json['imageUrl'],
        rating:
            json['rating'] != null ? (json['rating'] as num).toDouble() : null,
        phoneNumber: json['phoneNumber'],
        workingHours: json['workingHours'],
        accessibilityData: json['accessibilityData'] != null
            ? Map<String, List<Map<String, dynamic>>>.from(
                json['accessibilityData'].map(
                  (key, value) => MapEntry(
                    key,
                    List<Map<String, dynamic>>.from(value),
                  ),
                ),
              )
            : null,
        commentsData: json['commentsData'] != null
            ? List<Map<String, dynamic>>.from(json['commentsData'])
            : null,
        performanceData: json['performanceData'] != null
            ? Map<String, dynamic>.from(json['performanceData'])
            : null,
        cnpj: json['cnpj'],
        registrationDate: json['registrationDate'],
        about: json['about'],
      );

  // Método para converter instâncias de CompanyModel para JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'imageUrl': imageUrl,
        'rating': rating,
        'phoneNumber': phoneNumber,
        'workingHours': workingHours,
        'accessibilityData': accessibilityData,
        'commentsData': commentsData,
        'performanceData': performanceData,
        'cnpj': cnpj,
        'registrationDate': registrationDate,
        'about': about,
      };
}
