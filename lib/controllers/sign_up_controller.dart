import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/models/accessibility_model.dart';
import 'package:acesso_mapeado/models/user_model.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:acesso_mapeado/shared/logger.dart';

class SignUpController {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final MaskedTextController cpfController;
  final MaskedTextController dateOfBirthController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final UserController userController;

  final Map<String, List<Map<String, dynamic>>> accessibilityData = {
    "Acessibilidade Física": [
      {"tipo": "Rampas", "status": false},
      {"tipo": "Elevadores", "status": false},
      {"tipo": "Portas Largas", "status": false},
      {"tipo": "Banheiros Adaptados", "status": false},
      {"tipo": "Pisos Táteis e Superfícies Anti-derrapantes", "status": false},
      {"tipo": "Estacionamento Reservado", "status": false}
    ],
    "Acessibilidade Comunicacional": [
      {"tipo": "Sinalização com Braille e Pictogramas", "status": false},
      {"tipo": "Informações Visuais Claras e Contrastantes", "status": false},
      {"tipo": "Dispositivos Auditivos", "status": false},
      {"tipo": "Documentos e Materiais em Formatos Acessíveis", "status": false}
    ],
    "Acessibilidade Sensorial": [
      {"tipo": "Iluminação Adequada", "status": false},
      {"tipo": "Redução de Ruídos", "status": false}
    ],
    "Acessibilidade Atitudinal": [
      {"tipo": "Treinamento de Funcionários", "status": false},
      {"tipo": "Políticas Inclusivas", "status": false}
    ],
  };

  SignUpController({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.cpfController,
    required this.dateOfBirthController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.userController,
    required this.auth,
    required this.firestore,
  });

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  bool isValidCpf(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    if (cpf.length != 11) return false;

    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    List<int> digits = cpf.split('').map(int.parse).toList();

    int sum1 = 0;
    for (int i = 0; i < 9; i++) {
      sum1 += digits[i] * (10 - i);
    }
    int check1 = (sum1 * 10) % 11;
    if (check1 == 10) check1 = 0;

    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
      sum2 += digits[i] * (11 - i);
    }
    int check2 = (sum2 * 10) % 11;
    if (check2 == 10) check2 = 0;

    return check1 == digits[9] && check2 == digits[10];
  }

  bool isValidDateOfBirth(String date) {
    try {
      final parts = date.split('/');
      if (parts.length != 3) return false;

      if (parts[2].length != 4) return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Validate day/month/year ranges
      if (day < 1 || day > 31) return false;
      if (month < 1 || month > 12) return false;
      if (year < 1900) return false;

      final parsedDate = DateTime(year, month, day);
      final now = DateTime.now();

      // Check if date is valid (e.g. not Feb 31)
      if (parsedDate.day != day ||
          parsedDate.month != month ||
          parsedDate.year != year) {
        return false;
      }

      return parsedDate.isBefore(now);
    } catch (e) {
      return false;
    }
  }

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<bool> _validatePassword(BuildContext context) async {
    if (!isValidPassword(passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A senha deve conter no mínimo 8 caracteres, incluindo:\n'
            '- Uma letra maiúscula\n'
            '- Uma letra minúscula\n'
            '- Um número\n'
            '- Um caractere especial',
          ),
        ),
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não correspondem')),
      );
      return false;
    }

    return true;
  }

  DateTime _parseDateOfBirth() {
    final dateParts = dateOfBirthController.text.split('/');
    return DateTime(
      int.parse(dateParts[2]), // ano
      int.parse(dateParts[1]), // mês
      int.parse(dateParts[0]), // dia
    );
  }

  Future<bool> _validateDateOfBirth(BuildContext context) async {
    if (!isValidDateOfBirth(dateOfBirthController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data de nascimento inválida')),
      );
      return false;
    }
    return true;
  }

  Future<bool> _checkExistingCpf(BuildContext context) async {
    final cpf = cpfController.text.replaceAll(RegExp(r'\D'), '');
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('cpf', isEqualTo: cpf)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: CPF já cadastrado')),
      );
      return false;
    }
    return true;
  }

  Map<String, List<AccessibilityItem>> _getSelectedAccessibility() {
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

    return selectedAccessibility;
  }

  UserModel _createUserModel(
      DateTime parsedDate, AccessibilityModel accessibilityModel) {
    return UserModel(
      name: nameController.text,
      email: emailController.text,
      isCompany: false,
      cpf: cpfController.text.replaceAll(RegExp(r'\D'), ''),
      profilePictureUrl: null,
      dateOfBirth: parsedDate,
      registrationDate: DateTime.now(),
      accessibilityData: accessibilityModel,
    );
  }

  Future<void> _handleSuccessfulSignUp(
      BuildContext context, User user, UserModel newUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson())
        .then((_) {
      Logger.logInfo("Usuário adicionado com sucesso");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso')),
      );
    }).catchError((error) {
      Logger.logInfo('Erro ao adicionar usuário ao Firestore: $error');
    });

    userController
      ..setUser(user)
      ..updateUserModel(newUser);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: e-mail já cadastrado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro ao cadastrar')),
      );
    }
  }

  Future<bool> signUp(BuildContext context) async {
    if (!await validate(context)) {
      return false;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = userCredential.user;
      if (user == null) return false;

      final selectedAccessibility = _getSelectedAccessibility();
      final accessibilityModel = AccessibilityModel(
        accessibilityData: selectedAccessibility,
      );

      final parsedDate = _parseDateOfBirth();
      final newUser = _createUserModel(parsedDate, accessibilityModel);

      await _handleSuccessfulSignUp(context, user, newUser);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e);
      return false;
    }
  }

  Future<bool> validate(BuildContext context) async {
    final currentState = formKey.currentState;

    if (currentState == null || !currentState.validate()) {
      return false;
    }

    if (!await _validatePassword(context)) {
      return false;
    }

    if (!await _validateDateOfBirth(context)) {
      return false;
    }

    if (!await _checkExistingCpf(context)) {
      return false;
    }

    return true;
  }
}
