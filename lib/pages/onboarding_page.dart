import 'package:acesso_mapeado/pages/sign_in_page.dart';
import 'package:acesso_mapeado/pages/sign_up_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 55),
              Image.asset('assets/images/img-accessibility.png', height: 350),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Bem-vindo ao',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Acesso Mapeado.',
                        style: TextStyle(
                          color: AppColors.lightPurple,
                        ),
                      ),
                      TextSpan(
                        text: ' Juntos por um mundo mais inclusivo!',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightPurple),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Esqueceu a senha?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Redefinir senha',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightPurple),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sou uma empresa',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightPurple),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
