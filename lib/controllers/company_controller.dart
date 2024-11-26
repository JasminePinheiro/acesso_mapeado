import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CompanyController with ChangeNotifier {
  CompanyController({
    required this.auth,
    required this.firestore,
  }) {
    _companiesCollection = firestore.collection('companies');
  }

  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> _companiesCollection;

  CompanyModel? _companyData;
  bool _isLoading = true;

  CompanyModel? get companyData => _companyData;
  bool get isLoading => _isLoading;

  Future<CompanyModel?> loadCompanyData() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      final doc = await _companiesCollection.doc(user.uid).get();
      if (!doc.exists) throw Exception('Empresa não encontrada');

      _companyData = CompanyModel.fromJson(doc.data() as Map<String, dynamic>);
      _isLoading = false;
      notifyListeners();
      return _companyData;
    } catch (e) {
      Logger.logError('Erro ao carregar dados da empresa: $e');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateCompanyProfile({
    required String name,
    required String phoneNumber,
    required String address,
    required String number,
    required String neighborhood,
    required String city,
    required String state,
    required String zipCode,
    required String about,
    String? imageBase64,
    required Map<String, dynamic> accessibilityData,
    required Map<String, dynamic> workingHours,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('Usuário não autenticado');

      await _companiesCollection.doc(user.uid).update({
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'fullAddress':
            '$address, $number $neighborhood $city - $state $zipCode',
        'number': number,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'about': about,
        if (imageBase64 != null) 'imageUrl': imageBase64,
        'accessibilityData': accessibilityData,
        'workingHours': workingHours,
      });

      await loadCompanyData();
      notifyListeners();
      return true;
    } catch (e) {
      Logger.logError('Erro ao atualizar perfil da empresa: $e');
      return false;
    }
  }

  List<CompanyModel> _companies = [];

  List<CompanyModel> get companies => _companies;

  void updateCompanies(List<CompanyModel> newCompanies) {
    _companies = newCompanies;
    notifyListeners(); // Notifica as mudanças para os widgets
  }

  // Função para obter todas as empresas
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final response = await _companiesCollection.get();

      List<CompanyModel> companies = response.docs.map((doc) {
        Logger.logInfo('Lista de empresas');
        return CompanyModel.fromJson(doc.data());
      }).toList();

      return companies;
    } catch (e) {
      Logger.logInfo('Erro ao obter empresas: $e');
      return [];
    }
  }

  // Função para buscar empresas pelo nome
  Future<List<CompanyModel>> searchCompaniesByName(String searchTerm) async {
    try {
      final querySnapshot = await _companiesCollection
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: '$searchTerm\uf8ff')
          .get();

      List<CompanyModel> companies = querySnapshot.docs
          .map((doc) => CompanyModel.fromJson(doc.data()))
          .toList();
      return companies;
    } catch (e) {
      Logger.logInfo('Erro ao buscar empresas: $e');
      return [];
    }
  }

  // Função para inserir dados de mock no Firestore
  Future<void> insertMockCompanies() async {
    try {
      for (var company in []) {
        await _companiesCollection.add(company.toJson());
      }
      Logger.logInfo('Dados de mock inseridos com sucesso!');
    } catch (e) {
      Logger.logInfo('Erro ao inserir dados de mock: $e');
    }
  }

  // Função para obter todas as empresas ordenadas por rating decrescente
  Future<List<CompanyModel>> getAllCompaniesOrderByRating() async {
    try {
      final response =
          await _companiesCollection.orderBy('rating', descending: true).get();

      List<CompanyModel> companies = response.docs
          .map((doc) => CompanyModel.fromJson(doc.data()))
          .toList();
      return companies;
    } catch (e) {
      Logger.logInfo('Erro ao obter empresas ordenadas por rating: $e');
      return [];
    }
  }

  // Função que cria a empresa
  Future<bool> createCompany(CompanyModel company) async {
    try {
      await _companiesCollection.add(company.toJson());
      return true;
    } catch (error) {
      Logger.logInfo('Error adding document: $error');
      return false;
    }
  }

  // Função para editar a empresa atualizando o rating baseado na média dos ratings
  Future<bool> updateCompanyRating(String companyUUID) async {
    try {
      QuerySnapshot querySnapshot = await _companiesCollection
          .where('uuid', isEqualTo: companyUUID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Logger.logInfo('Empresa com UUID não encontrada.');
        return false;
      }

      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      CompanyModel company = CompanyModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );

      if (company.ratings!.isEmpty) {
        Logger.logInfo('Empresa não possui ratings.');
        return false;
      }
      double averageRating =
          company.ratings!.reduce((a, b) => a + b) / company.ratings!.length;

      await docSnapshot.reference.update({
        'rating': averageRating,
      });

      Logger.logInfo('Rating atualizado com sucesso para $averageRating.');
      return true;
    } catch (e) {
      Logger.logInfo('Erro ao atualizar o rating da empresa: $e');
      return false;
    }
  }

  // Função para adicionar o rating de um usuário à empresa
  Future<bool> addCompanyUserRating(
      String companyUUID, double userRating) async {
    try {
      QuerySnapshot querySnapshot = await _companiesCollection
          .where('uuid', isEqualTo: companyUUID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Logger.logInfo('Empresa com UUID não encontrada.');
        return false;
      }

      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      List<double> ratings = List<double>.from(data['ratings'] ?? []);

      ratings.add(userRating);

      await docSnapshot.reference.update({
        'ratings': ratings,
      });

      await updateCompanyRating(companyUUID);

      Logger.logInfo('Rating do usuário adicionado com sucesso.');
      return true;
    } catch (e) {
      Logger.logInfo('Erro ao adicionar rating do usuário: $e');
      return false;
    }
  }

  // Função para adição de um rating
  Future<void> addUserRating(String companyUUID, double userRating) async {
    bool result = await addCompanyUserRating(companyUUID, userRating);

    if (result) {
      Logger.logInfo('Rating adicionado com sucesso.');
    } else {
      Logger.logInfo('Falha ao adicionar o rating.');
    }

    final docSnapshot = await _companiesCollection.doc(companyUUID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      Logger.logInfo('Ratings atuais: ${data['ratings']}');
    }
  }

  // Função que adiciona o comentário do usuario à empresa
  Future<bool> addUserComment(String companyUUID, String comment,
      double userRating, BuildContext context, List<String> photos) async {
    try {
      // Obtém o email do usuário logado
      final userEmail =
          Provider.of<UserController>(context, listen: false).user?.email;

      String userName = 'Nome não encontrado';

      if (userEmail != null) {
        try {
          final userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .limit(1)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            userName = userSnapshot.docs.first['name'] ?? 'Nome não encontrado';
          }
        } catch (e) {
          Logger.logError('Erro ao buscar nome do usuário: $e');
        }
      }
      QuerySnapshot querySnapshot = await _companiesCollection
          .where('uuid', isEqualTo: companyUUID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        Logger.logInfo('Empresa com UUID não encontrada.');
        return false;
      }

      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> commentsData =
          List<Map<String, dynamic>>.from(data['commentsData'] ?? []);

      var commentData = {
        'userName': userName,
        'userImage': Provider.of<UserController>(context, listen: false)
            .userModel
            ?.profilePictureUrl,
        'text': comment,
        'date': DateTime.now().toString(),
        'rate': userRating,
        'photos': photos,
      };

      commentsData.add(commentData);

      await docSnapshot.reference.update({
        'commentsData': commentsData,
      });

      Logger.logInfo('Comentário do usuário adicionado com sucesso.');
      return true;
    } catch (e) {
      Logger.logInfo('Erro ao adicionar comentário do usuário: $e');
      return false;
    }
  }
}
