import 'package:acesso_mapeado/pages/company_home_page.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:acesso_mapeado/pages/onboarding_page.dart';
import 'package:acesso_mapeado/pages/profile_user_page.dart';
import 'package:acesso_mapeado/pages/sign_in_page.dart';
import 'package:acesso_mapeado/pages/sign_up_page.dart';
import 'package:acesso_mapeado/pages/splash_page.dart';
import 'package:acesso_mapeado/pages/support_page.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';

import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:color_blindness/color_blindness.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: colorBlindnessColorScheme(
          ColorScheme.fromSwatch(primarySwatch: AppColors.purple),
          Provider.of<ProviderColorBlindnessType>(context).getCurrentType(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: Provider.of<ProviderColorBlindnessType>(context,
                      listen: false)
                  .isFirstTime(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const ColorBlindnessSelectionDialog(),
                    );
                  });
                }
                return const SplashPage();
              },
            ),
        'signUp': (context) => const SignUpPage(),
        'signIn': (context) => const SignInPage(),
        'home': (context) => const HomePage(),
        'profile_user': (context) => const ProfileUserPage(),
        'onboarding': (context) => const OnboardingPage(),
        'company_home': (context) => const CompanyHomePage(),
        'support': (context) => const SupportPage(),
      },
    );
  }
}

class ColorBlindnessSelectionDialog extends StatelessWidget {
  const ColorBlindnessSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tipo de Daltonismo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ColorBlindnessType.values.map((type) {
          return ListTile(
            title: Text(Provider.of<ProviderColorBlindnessType>(context)
                .getTranslation(type)),
            onTap: () {
              final provider = Provider.of<ProviderColorBlindnessType>(
                context,
                listen: false,
              );
              provider.setCurrentType(type);
              provider.saveCurrentTypeToSharedPreferences();
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
