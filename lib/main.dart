import 'package:acesso_mapeado/app.dart';
import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/firebase_options.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderColorBlindnessType(),
        ),
        ChangeNotifierProvider(
            create: (_) => CompanyController(
                  auth: FirebaseAuth.instance,
                  firestore: FirebaseFirestore.instance,
                )), // Fornecendo o estado das empresas
        ChangeNotifierProvider(
          create: (_) => UserController(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            providerColorBlindnessType: ProviderColorBlindnessType(),
          ), // Fornecendo o estado de autenticação
        ),
      ],
      child: const App(),
    ),
  );
}
