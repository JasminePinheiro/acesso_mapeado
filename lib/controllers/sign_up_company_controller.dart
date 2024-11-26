import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/models/accessibility_model.dart';
import 'package:acesso_mapeado/models/company_model.dart';

import 'package:acesso_mapeado/pages/company_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SignUpCompanyController {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final MaskedTextController cnpjController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController numberController;
  final TextEditingController neighborhoodController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;
  final TextEditingController aboutController;
  final TextEditingController workingHoursController;
  final TextEditingController instagramUrlController;
  final TextEditingController facebookUrlController;
  final TextEditingController twitterUrlController;
  final TextEditingController youtubeUrlController;
  final TextEditingController tiktokUrlController;
  final TextEditingController pinterestUrlController;
  final TextEditingController linkedinUrlController;
  final TextEditingController websiteUrlController;

  SignUpCompanyController({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.cnpjController,
    required this.phoneController,
    required this.addressController,
    required this.numberController,
    required this.neighborhoodController,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
    required this.aboutController,
    required this.workingHoursController,
    required this.instagramUrlController,
    required this.facebookUrlController,
    required this.twitterUrlController,
    required this.youtubeUrlController,
    required this.tiktokUrlController,
    required this.pinterestUrlController,
    required this.linkedinUrlController,
    required this.websiteUrlController,
  });

  bool isValidCNPJ(String cnpj) {
    cnpj = cnpj.replaceAll(RegExp(r'\D'), '');

    if (cnpj.length != 14) return false;

    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;

    List<int> numbers = cnpj.split('').map(int.parse).toList();

    int sum = 0;
    int weight = 5;
    for (int i = 0; i < 12; i++) {
      sum += numbers[i] * weight;
      weight = weight == 2 ? 9 : weight - 1;
    }
    int digit1 = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    if (numbers[12] != digit1) return false;

    sum = 0;
    weight = 6;
    for (int i = 0; i < 13; i++) {
      sum += numbers[i] * weight;
      weight = weight == 2 ? 9 : weight - 1;
    }
    int digit2 = sum % 11 < 2 ? 0 : 11 - (sum % 11);
    return numbers[13] == digit2;
  }

  Future<void> signUp(
    BuildContext context,
    Map<String, List<Map<String, dynamic>>> accessibilityData,
    String fullAddress,
    Map<String, Map<String, String>> workingHoursData,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        // Check if CNPJ already exists
        final cnpj = cnpjController.text.replaceAll(RegExp(r'\D'), '');
        final querySnapshot = await FirebaseFirestore.instance
            .collection('companies')
            .where('cnpj', isEqualTo: cnpj)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro: CNPJ já cadastrado')),
          );
          return;
        }

        final user = Provider.of<UserController>(context, listen: false).user;
        String sharedId = user!.uid;

        Map<String, List<AccessibilityItem>> selectedAccessibility = {};

        accessibilityData.forEach((category, items) {
          List<AccessibilityItem> selectedItems = items
              .where((item) => item['status'] == true)
              .map((item) => AccessibilityItem(
                    type: item['tipo'],
                    status: item['status'],
                  ))
              .toList();

          if (selectedItems.isNotEmpty) {
            selectedAccessibility[category] = selectedItems;
          }
        });

        AccessibilityModel accessibilityModel = AccessibilityModel(
          accessibilityData: selectedAccessibility,
        );

        List<WorkingHours> workingHours = [];

        for (String day in [
          'Segunda-feira',
          'Terça-feira',
          'Quarta-feira',
          'Quinta-feira',
          'Sexta-feira',
          'Sábado',
          'Domingo'
        ]) {
          String open = workingHoursData[day]?['open'] ?? 'Fechado';
          String close = workingHoursData[day]?['close'] ?? 'Fechado';

          workingHours.add(WorkingHours(
            day: day,
            open: open,
            close: close,
          ));
        }

        LatLng? latLong = await getLatLong(fullAddress);

        CompanyModel newCompany = CompanyModel(
          uuid: sharedId,
          name: nameController.text,
          email: emailController.text,
          cnpj: cnpjController.text.replaceAll(RegExp(r'\D'), ''),
          phoneNumber: phoneController.text,
          workingHours: workingHours,
          fullAddress: fullAddress,
          address: addressController.text,
          number: numberController.text,
          neighborhood: neighborhoodController.text,
          city: cityController.text,
          state: stateController.text,
          zipCode: zipCodeController.text,
          about: aboutController.text,
          instagramUrl: instagramUrlController.text,
          facebookUrl: facebookUrlController.text,
          twitterUrl: twitterUrlController.text,
          youtubeUrl: youtubeUrlController.text,
          tiktokUrl: tiktokUrlController.text,
          pinterestUrl: pinterestUrlController.text,
          linkedinUrl: linkedinUrlController.text,
          websiteUrl: websiteUrlController.text,
          imageUrl: null,
          registrationDate: DateTime.now().toString(),
          accessibilityData: accessibilityModel,
          rating: 0.0,
          latitude: latLong?.latitude,
          longitude: latLong?.longitude,
          commentsData: [],
          ratings: [],
        );

        await FirebaseFirestore.instance
            .collection('companies')
            .doc(sharedId)
            .set(newCompany.toJson());

        Logger.logInfo("Empresa adicionada com sucesso");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompanyHomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}')),
        );
      }
    }
  }
}

Future<LatLng?> getLatLong(String fullAddress) async {
  final response = await Dio().get(
      'https://nominatim.openstreetmap.org/search?q=$fullAddress&format=json');

  if (response.statusCode == 200 && response.data.isNotEmpty) {
    final data = response.data;
    return LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
  } else {
    return null;
  }
}

// Método de validação de CEP
Future<bool> isValidCEP(String cep) async {
  try {
    final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
    if (response.data.containsKey('erro') && response.data['erro'] == true) {
      return false;
    }
    return true;
  } catch (e) {
    return false;
  }
}
