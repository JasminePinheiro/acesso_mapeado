import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/pages/company_home_page.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:acesso_mapeado/pages/onboarding_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await checkUserAndRedirect();
  }

  Future<void> checkUserAndRedirect() async {
    final userController = Provider.of<UserController>(context, listen: false);
    final user = userController.user;

    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
      return;
    }

    final userProfile = await userController.loadUserProfile();

    // Check if user is in company view
    if (userController.isCompanyView) {
      await userController.loadCompanyProfile();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CompanyHomePage()),
      );
      return;
    }

    if (userProfile != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo-acesso-mapeado.png'),
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Acesso Mapeado',
              style: TextStyle(
                  color: AppColors.lightPurple,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
