import 'dart:convert';
import 'dart:io';

import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/models/user_model.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:acesso_mapeado/pages/sign_up_company_page.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:acesso_mapeado/shared/logger.dart';

import 'package:color_blindness/color_blindness.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserController with ChangeNotifier {
  late final FirebaseAuth auth;
  late final FirebaseFirestore firestore;

  UserController({
    required this.auth,
    required this.firestore,
    required this.providerColorBlindnessType,
  }) {
    _user = auth.currentUser;
    auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
  final ProviderColorBlindnessType providerColorBlindnessType;

  User? _user;
  UserModel? _userModel;
  CompanyModel? _companyModel;
  LatLng? _userPosition;
  bool _isCompanyView = false;

  CompanyModel? get companyModel => _companyModel;

  // getter
  LatLng? get userPosition => _userPosition;

  // setter
  void setUserPosition(LatLng position) {
    _userPosition = position;
    notifyListeners();
  }

  void setColorBlindnessTypeFromRemoteConfig() {
    loadUserProfile().then((userModel) {
      providerColorBlindnessType.setCurrentType(
          userModel?.colorBlindnessType ?? ColorBlindnessType.none);
      notifyListeners();
    });
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateCompanyModel(CompanyModel companyModel) {
    _companyModel = companyModel;
    notifyListeners();
  }

  UserModel? get userModel => _userModel;

  void updateUserModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  void logout() {
    auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  // retorna o usuário logado
  User? get user => _user;

  // verifica se o usuário está logado
  bool get isAuthenticated => _user != null;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      return _user;
    } on FirebaseAuthException catch (e) {
      Logger.logError('Erro ao realizar o login: $e');
      throw Exception('Erro ao realizar o login.');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfilePhoto(File imageFile) async {
    try {
      if (_user != null) {
        final base64Image = await imageFile.readAsBytes();
        final photoUrl = base64Encode(base64Image);

        await firestore.collection('users').doc(_user!.uid).update({
          'profilePictureUrl': photoUrl,
        });

        await loadUserProfile();

        notifyListeners();
      }
    } catch (e) {
      throw Exception('Error updating profile photo - $e');
    }
  }

  //remove profile photo
  Future<void> removeProfilePhoto() async {
    await firestore.collection('users').doc(_user!.uid).update({
      'profilePictureUrl': null,
    });

    await loadUserProfile();

    notifyListeners();
  }

  Future<UserModel?> loadUserProfile() async {
    final userDoc = await firestore.collection('users').doc(_user!.uid).get();
    if (userDoc.exists) {
      _userModel = UserModel.fromJson(userDoc.data()!);
    }

    notifyListeners();
    return _userModel;
  }

  Future<void> loadCompanyProfile() async {
    final companyDoc =
        await firestore.collection('companies').doc(_user!.uid).get();
    _companyModel = CompanyModel.fromJson(companyDoc.data() ?? {});
  }

  // obter a localização do usuário
  Future<bool> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      Logger.logInfo('Permissão de localização: $permission');

      if (permission == LocationPermission.denied) {
        Logger.logInfo('Solicitando permissão de localização...');

        permission = await Geolocator.requestPermission();
        Logger.logInfo('Permissão de localização: $permission');

        if (permission == LocationPermission.denied) {
          Logger.logInfo('Permissão de localização negada');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Logger.logInfo('Permissão de localização negada permanentemente');
        return false;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _userPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();

      return true;
    } catch (e) {
      Logger.logError('Erro ao obter a localização do usuário: $e');

      return false;
    }
  }

  bool get isCompanyView => _isCompanyView;

  Future<bool> toggleUserView(BuildContext context) async {
    if (_isCompanyView) {
      // Switching from company view to user view
      await loadUserProfile();

      if (!context.mounted) return false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      _isCompanyView = false;
      notifyListeners();
      return false;
    } else {
      // Switching from user view to company view
      // Check if user has a company
      final companyDoc =
          await firestore.collection('companies').doc(_user!.uid).get();

      if (!companyDoc.exists) {
        // Show dialog to create company
        if (!context.mounted) return false;
        final shouldCreateCompany = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Criar empresa'),
            content: const Text(
                'Você ainda não possui uma empresa cadastrada. Deseja cadastrar agora?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sim'),
              ),
            ],
          ),
        );

        if (shouldCreateCompany == true) {
          if (!context.mounted) return false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpCompanyPage()),
          );
          return false;
        }
        return false;
      }

      _companyModel = CompanyModel.fromJson(companyDoc.data()!);
      _isCompanyView = true;
      notifyListeners();
      return true;
    }
  }
}
