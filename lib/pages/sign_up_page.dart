import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/pages/onboarding_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:acesso_mapeado/controllers/sign_up_controller.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpController _signUpController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _signUpController = SignUpController(
      formKey: GlobalKey<FormState>(),
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      cpfController: MaskedTextController(mask: '000.000.000-00'),
      dateOfBirthController: MaskedTextController(mask: '00/00/0000'),
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      userController: Provider.of<UserController>(context, listen: false),
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    );
  }

  @override
  void dispose() {
    _signUpController.nameController.dispose();
    _signUpController.emailController.dispose();
    _signUpController.cpfController.dispose();
    _signUpController.dateOfBirthController.dispose();
    _signUpController.passwordController.dispose();
    _signUpController.confirmPasswordController.dispose();
    super.dispose();
  }

  void _onStepContinue() {
    if (!_signUpController.formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep == 1) {
      if (!_signUpController
          .isValidPassword(_signUpController.passwordController.text)) {
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
        return;
      }

      if (_signUpController.passwordController.text !=
          _signUpController.confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não correspondem')),
        );
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _onFinish() {
    if (_signUpController.formKey.currentState!.validate()) {
      if (_signUpController.passwordController.text !=
          _signUpController.confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não correspondem')),
        );
        return;
      }
      _signUpController.signUp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: AppColors.white, boxShadow: [
            BoxShadow(
              color: AppColors.darkGray.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ]),
        ),
        leading: IconButton(
            icon: Image.asset('assets/icons/arrow-left.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage()),
              );
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _signUpController.formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepIndicator(0, 'Dados Pessoais'),
                  _buildStepLine(),
                  _buildStepIndicator(1, 'Credenciais'),
                  _buildStepLine(),
                  _buildStepIndicator(2, 'Acessibilidade'),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Cadastre-se',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    if (_currentStep == 0) _buildPersonalInfoStep(),
                    if (_currentStep == 1) _buildAccountDetailsStep(),
                    if (_currentStep == 2) _buildAccessibilityStep(),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: _onStepCancel,
                            child: const Text('Voltar',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        const Spacer(),
                        if (_currentStep == 2)
                          ElevatedButton(
                            onPressed: _onFinish,
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: _onStepContinue,
                            child: const Text(
                              'Próximo',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String stepName) {
    return Column(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: _currentStep == stepIndex
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withOpacity(0.15),
          child: Text(
            (stepIndex + 1).toString(),
            style: TextStyle(
              color:
                  _currentStep == stepIndex ? AppColors.white : AppColors.black,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stepName,
          style: const TextStyle(fontSize: 13, color: AppColors.black),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: AppColors.lightGray,
    );
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildTextField(
          _signUpController.nameController,
          'Nome',
          TextInputType.text,
          'Por favor, insira seu nome',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira seu nome';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _signUpController.emailController,
          'E-mail',
          TextInputType.emailAddress,
          'Por favor, insira seu e-mail',
          isEmail: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _signUpController.cpfController,
          'CPF',
          TextInputType.number,
          'Por favor, insira seu CPF',
          isCpf: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _signUpController.dateOfBirthController,
          'Data de nascimento (dd/MM/yyyy)',
          TextInputType.datetime,
          'Por favor, insira uma data de nascimento válida',
          isDateOfBirth: true,
        ),
      ],
    );
  }

  Widget _buildAccountDetailsStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _buildTextField(
          _signUpController.passwordController,
          'Senha',
          TextInputType.visiblePassword,
          'Por favor, insira uma senha',
          isPassword: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          _signUpController.confirmPasswordController,
          'Confirmar senha',
          TextInputType.visiblePassword,
          'As senhas não correspondem',
          isPassword: true,
          confirmPassword: true,
        ),
      ],
    );
  }

  Widget _buildAccessibilityStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Text(
            textAlign: TextAlign.center,
            "Marque as acessibilidades que deseja encontrar nos estabelecimentos",
            style: TextStyle(
                color: AppColors.black, fontSize: AppTypography.large),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        ..._signUpController.accessibilityData.entries.map((entry) {
          String category = entry.key;
          List<Map<String, dynamic>> items = entry.value;
          return ExpansionTile(
            title: Text(
              category,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: AppSpacing.medium,
                  fontWeight: FontWeight.bold),
            ),
            children: items.map((item) {
              return CheckboxListTile(
                title: Text(
                  item["tipo"],
                  style: const TextStyle(color: AppColors.darkGray),
                ),
                value: item["status"],
                onChanged: (bool? value) {
                  setState(() {
                    item["status"] = value ?? false;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
                checkColor: Theme.of(context).colorScheme.onPrimary,
              );
            }).toList(),
          );
        })
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
    String validationMessage, {
    bool isEmail = false,
    bool isPassword = false,
    bool confirmPassword = false,
    bool isCpf = false,
    bool isDateOfBirth = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Por favor, insira um e-mail válido';
            }
            if (isCpf && !_signUpController.isValidCpf(controller.text)) {
              return 'Por favor, insira um CPF válido';
            }
            if (isDateOfBirth &&
                !_signUpController.isValidDateOfBirth(controller.text)) {
              return 'Insira uma data de nascimento válida';
            }
            if (isPassword && !_signUpController.isValidPassword(value)) {
              return 'A senha deve conter no mínimo 8 caracteres, incluindo: '
                  '\n- Uma letra maiúscula'
                  '\n- Uma letra minúscula'
                  '\n- Um número'
                  '\n- Um caractere especial';
            }
            if (confirmPassword &&
                value != _signUpController.passwordController.text) {
              return 'As senhas não correspondem';
            }
            return null;
          },
    );
  }
}
