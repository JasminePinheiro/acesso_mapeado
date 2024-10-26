import 'package:acesso_mapeado/app.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/firebase_options.dart';
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
            create: (_) => CompanyState()), // Fornecendo o estado das empresas
      ],
      child: const App(),
    ),
  );
}
