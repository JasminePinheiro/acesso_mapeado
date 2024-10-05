// pages/home_page.dart
import 'dart:async';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:acesso_mapeado/shared/mock_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/pages/profile_user_page.dart';
import 'package:acesso_mapeado/pages/ranking_page.dart';
import 'package:acesso_mapeado/pages/sign_in_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/shared/app_navbar.dart';
import 'package:acesso_mapeado/widgets/accessibility_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getCompanies();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getCompanies() async {
    try {
      companies = await _companyController.getAllCompanies();
      Logger.logInfo("Empresas carregadas: ${companies.length}");

      if (!mounted) return;

      setState(() {});
    } catch (e) {
      Logger.logError('Erro ao carregar empresas: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar empresas.')),
      );
    }
  }

  // Função para inserir dados de mock
  Future<void> _insertMockData() async {
    try {
      await _companyController.insertMockCompanies();

      if (!mounted) return;

      // Recarregar as empresas após a inserção
      await getCompanies();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados de mock inseridos com sucesso!')),
      );
    } catch (e) {
      Logger.logError('Erro ao inserir dados de mock: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao inserir dados de mock.')),
      );
    }
  }

  // Função para remover todas as empresas (opcional)
  Future<void> _removeAllCompanies() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('companies').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      if (!mounted) return;

      setState(() {
        companies.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todas as empresas foram removidas!')),
      );
    } catch (e) {
      Logger.logError('Erro ao remover empresas: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao remover empresas.')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAccessibilitySheet(CompanyModel companyModel) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AccessibilitySheet(companyModel: companyModel);
      },
    );
  }

  final CompanyController _companyController = CompanyController();

  int _selectedIndex = 0;

  List<CompanyModel> companies = [];

  final indexTitle = [
    'Empresas',
    'Bate-papo',
    'Ranking',
    'Perfil',
  ];

  // Métodos para construir cada página
  Widget _buildHomePage() {
    return ListView.builder(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: company.imageUrl != null
                  ? NetworkImage(company.imageUrl!)
                  : const AssetImage('assets/images/placeholder-company.png')
                      as ImageProvider,
              radius: 29,
            ),
            title: Text(company.name),
            subtitle: Row(
              children: List.generate(5, (starIndex) {
                return Icon(
                  Icons.star,
                  color: starIndex < (company.rating ?? 0)
                      ? Colors.yellow
                      : Colors.grey,
                  size: 20,
                );
              }),
            ),
            trailing: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightPurple),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info,
                        color: AppColors.lightPurple,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Saiba mais',
                        style: TextStyle(color: AppColors.lightPurple),
                      ),
                    ],
                  ),
                )),
            onTap: () {
              _showAccessibilitySheet(company);
            },
          ),
        );
      },
    );
  }

  Widget _buildRankingPage() {
    return const RankingPage(); // Assegure-se de que RankingPage está implementada corretamente
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(),
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          const Text('Bate-papo'),
          _buildRankingPage(),
          const ProfileUserPage(),
        ],
      ),
      drawer: homeDrawer(context),
      bottomNavigationBar: AppNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Drawer homeDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 100),
          ...accessibilityData.entries.map((entry) {
            String category = entry.key;
            List<Map<String, dynamic>> items = entry.value;
            return ExpansionTile(
              title: Text(
                category,
                style: const TextStyle(
                    color: AppColors.black, fontWeight: FontWeight.bold),
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
                  activeColor: AppColors.lightPurple,
                  checkColor: AppColors.white,
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 45),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPurple,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text(
                'Buscar',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar homeAppBar() {
    return AppBar(
      title: Text(
        indexTitle[_selectedIndex],
      ),
      backgroundColor: AppColors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          tooltip: 'Inserir Dados de Mock',
          onPressed: _insertMockData,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Remover Todas as Empresas',
          onPressed: _removeAllCompanies,
        ),
      ],
    );
  }
}
