import 'dart:async';
import 'dart:convert';
import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:acesso_mapeado/shared/mock_data.dart';
import 'package:acesso_mapeado/widgets/color_blind_image.dart';

import 'package:flutter/material.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/pages/profile_user_page.dart';
import 'package:acesso_mapeado/pages/ranking_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/shared/app_navbar.dart';
import 'package:acesso_mapeado/widgets/accessibility_sheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:acesso_mapeado/widgets/companies_map_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<CompanyModel> filteredCompanies = [];
  bool _showMapView = false;

  @override
  void initState() {
    getCompanies();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  String calculateDistance(double? companyLatitude, double? companyLongitude) {
    final userPosition =
        Provider.of<UserController>(context, listen: false).userPosition;
    if (userPosition == null ||
        companyLatitude == null ||
        companyLongitude == null) return "";
    final distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      companyLatitude,
      companyLongitude,
    );

    if (distance < 1000) {
      return "${distance.toStringAsFixed(0)} m";
    } else {
      final distanceInKm = distance / 1000;
      return "${distanceInKm.toStringAsFixed(0)} km";
    }
  }

  Future<void> getCompanies() async {
    try {
      companies = await Provider.of<CompanyController>(context, listen: false)
          .getAllCompanies();
      Logger.logInfo("Empresas carregadas: ${companies.length}");

      if (!mounted) return;

      // Sort companies by distance
      sortCompaniesByDistance();

      Provider.of<CompanyController>(context, listen: false)
          .updateCompanies(companies);
      filteredCompanies = companies;

      setState(() {});
    } catch (e) {
      Logger.logError('Erro ao carregar empresas: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar empresas.')),
      );
    }
  }

  // Add this new method to sort companies by distance
  void sortCompaniesByDistance() {
    final userPosition =
        Provider.of<UserController>(context, listen: false).userPosition;

    if (userPosition != null) {
      companies.sort((a, b) {
        double? distanceA = (a.latitude != null && a.longitude != null)
            ? Geolocator.distanceBetween(
                userPosition.latitude,
                userPosition.longitude,
                a.latitude!,
                a.longitude!,
              )
            : double.infinity;

        double? distanceB = (b.latitude != null && b.longitude != null)
            ? Geolocator.distanceBetween(
                userPosition.latitude,
                userPosition.longitude,
                b.latitude!,
                b.longitude!,
              )
            : double.infinity;

        return distanceA.compareTo(distanceB);
      });
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
      backgroundColor: const Color.fromARGB(0, 185, 33, 33),
      builder: (BuildContext context) {
        return AccessibilitySheet(companyModel: companyModel);
      },
    );
  }

  // Função que filtra os dados na barra de pesquisa
  void _onSearchChanged() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      filteredCompanies = companies
          .where((company) => company.name.toLowerCase().contains(searchTerm))
          .toList();
      sortCompaniesByDistance(); // Keep the sort when filtering
    });
  }

  List<String> getSelectedAccessibilityOptions() {
    List<String> selectedOptions = [];
    accessibilityData.forEach((category, items) {
      for (var item in items) {
        if (item['status'] == true) {
          selectedOptions.add(item['tipo']);
        }
      }
    });
    return selectedOptions;
  }

  // Função para filtrar as empresas por acessibilidade
  void filterCompanies() {
    List<String> selectedOptions = getSelectedAccessibilityOptions();

    setState(() {
      filteredCompanies = companies.where((company) {
        bool hasAllSelectedOptions = true;

        if (company.accessibilityData != null) {
          var accessibilityMap = company.accessibilityData!.accessibilityData;

          for (String option in selectedOptions) {
            bool optionFound = false;

            for (var category in accessibilityMap.entries) {
              for (var item in category.value) {
                if (item.type == option && item.status == true) {
                  optionFound = true;
                  break;
                }
              }
              if (optionFound) break;
            }

            if (!optionFound) {
              hasAllSelectedOptions = false;
              break;
            }
          }
        } else {
          hasAllSelectedOptions = false;
        }

        // Retorna se a empresa atende todas as opções de acessibilidade selecionadas
        return hasAllSelectedOptions;
      }).toList();
    });
  }

  int _selectedIndex = 0;

  List<CompanyModel> companies = [];

  final indexTitle = [
    'Empresas',
    'Ranking',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(indexTitle[_selectedIndex]),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(_showMapView ? Icons.list : Icons.map),
              onPressed: () {
                setState(() {
                  _showMapView = !_showMapView;
                });
              },
            ),
        ],
      ),
      drawer: _selectedIndex == 0 ? homeDrawer(context) : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          const RankingPage(),
          const ProfileUserPage(),
        ],
      ),
      bottomNavigationBar: AppNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        if (!_showMapView) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Pesquisar",
                hintText: "Digite o nome da empresa",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
            ),
          ),
        ],
        Expanded(
          child: _showMapView
              ? CompaniesMapView(companies: filteredCompanies)
              : filteredCompanies.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma empresa encontrada.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 225, 225, 225),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCompanies.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final company = filteredCompanies[index];
                        final distance = calculateDistance(
                            company.latitude, company.longitude);
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: ColorBlindImage(
                                imageProvider: company.imageUrl != null
                                    ? MemoryImage(base64Decode(
                                        company.imageUrl!.split(',')[1]))
                                    : const AssetImage(
                                            'assets/images/img-company.png')
                                        as ImageProvider,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              company.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  Icons.star,
                                  color: starIndex < (company.rating ?? 0)
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[300],
                                  size: AppTypography.xxLarge,
                                );
                              }),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  distance,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppTypography.medium,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              _showAccessibilitySheet(company);
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
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
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 45),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  filterCompanies();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Buscar',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Reset all checkboxes to false
                    for (var entry in accessibilityData.entries) {
                      for (var item in entry.value) {
                        item["status"] = false;
                      }
                    }
                  });
                  filterCompanies();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Limpar filtros'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
