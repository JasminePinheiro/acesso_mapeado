import 'dart:convert';

import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:acesso_mapeado/widgets/color_blind_image.dart';
import 'package:color_blindness/color_blindness.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acesso_mapeado/pages/edit_company_profile_page.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  CompanyModel? companyData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCompanyData();
  }

  Future<void> loadCompanyData() async {
    companyData = await Provider.of<CompanyController>(context, listen: false)
        .loadCompanyData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accessibilityData = Provider.of<CompanyController>(context)
        .companyData
        ?.accessibilityData
        ?.accessibilityData;
    Logger.logInfo('accessibilityData: $accessibilityData');
    if (isLoading) {
      return Semantics(
        label: 'Carregando dados da empresa',
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (companyData == null) {
      return Semantics(
        label: 'Erro ao carregar dados da empresa',
        child: const Scaffold(
          body: Center(
            child: Text('Erro ao carregar dados da empresa'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel da Empresa'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Semantics(
            label: 'Botão de sair',
            button: true,
            onTapHint: 'Sair da conta',
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await Provider.of<UserController>(context, listen: false)
                    .signOut();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('onboarding');
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadCompanyData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com informações principais
              Semantics(
                label: 'Informações principais da empresa',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Foto da empresa',
                        image: true,
                        child: ClipOval(
                          child: ColorBlindImage(
                            imageProvider: companyData!.imageUrl != null
                                ? MemoryImage(base64Decode(
                                    companyData!.imageUrl!.substring(
                                        companyData!.imageUrl!.indexOf(',') +
                                            1)))
                                : const AssetImage(
                                    'assets/images/img-company.png',
                                  ),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Nome da empresa',
                        child: Text(
                          companyData!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: 'Avaliação da empresa',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.primary),
                            Text(
                              ' ${companyData!.rating?.toStringAsFixed(1) ?? '0.0'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              ' (${companyData!.ratings?.length ?? 0} avaliações)',
                              style: const TextStyle(color: AppColors.darkGray),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // mudar para a visao de usuario
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                      'Alternar para visão de usuário', Icons.person, () {
                    Provider.of<UserController>(context, listen: false)
                        .toggleUserView(context);
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // Botões de Ação
              Semantics(
                label: 'Ações disponíveis',
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        'Editar Perfil',
                        Icons.edit,
                        () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCompanyProfilePage(
                                company: companyData!,
                              ),
                            ),
                          );

                          loadCompanyData();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Informações de Contato
              _buildSection(
                'Informações de Contato',
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.location_on, 'Endereço',
                            companyData!.fullAddress),
                        const Divider(),
                        _buildInfoRow(Icons.phone, 'Telefone',
                            companyData!.phoneNumber ?? 'Não informado'),
                        const Divider(),
                        _buildWorkingHoursRow(companyData!.workingHours ?? []),
                      ],
                    ),
                  ),
                ),
              ),

              // Dashboard de Acessibilidade
              accessibilityData?.isNotEmpty ?? false
                  ? Semantics(
                      child: _buildSection(
                        'Desempenho de acessibilidade',
                        _buildAccessibilityDashboard(),
                      ),
                    )
                  : const SizedBox.shrink(),

              // Estatísticas expandidas
              Semantics(
                label: 'Estatísticas da empresa',
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Comentários',
                        '${companyData!.commentsData?.length ?? 0}',
                        Icons.comment,
                      ),
                      _buildStatCard(
                        'Acessibilidade',
                        '${_calculateAccessibilityScore()}%',
                        Icons.accessibility_new,
                      ),
                    ],
                  ),
                ),
              ),

              // Seção de Comentários Recentes
              Semantics(
                label: 'Comentários recentes',
                child: _buildSection(
                  'Comentários Recentes',
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: companyData!.commentsData?.take(3).length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = companyData!.commentsData![index];
                      return Semantics(
                        label: 'Comentário de ${comment.userName}',
                        child: Card(
                          child: ListTile(
                            leading: ClipOval(
                              child: ColorBlindImage(
                                imageProvider: comment.userImage != null
                                    ? MemoryImage(base64Decode(
                                        comment.userImage!.substring(
                                            comment.userImage!.indexOf(',') +
                                                1)))
                                    : const AssetImage(
                                        'assets/images/placeholder-user.png',
                                      ),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(comment.userName),
                            subtitle: Text(comment.text),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                Text(comment.rate.toString()),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Semantics(
      label: '$title: $value',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon,
                  size: 30, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: AppColors.darkGray),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Semantics(
      label: 'Seção: $title',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              semanticsLabel: '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return Semantics(
      label: 'Botão: $label',
      button: true,
      onTapHint: label,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  int _calculateAccessibilityScore() {
    if (companyData?.accessibilityData?.accessibilityData == null) {
      return 0;
    }

    int totalItems = 14;
    int selectedItems = 0;

    companyData!.accessibilityData!.accessibilityData.forEach((_, items) {
      selectedItems += items.where((item) => item.status).length;
    });

    return ((selectedItems / totalItems) * 100).round();
  }

  Widget _buildWorkingHoursRow(List<WorkingHours> workingHours) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: workingHours.length,
      itemBuilder: (context, index) {
        final weekDay = workingHours[index];

        // Skip if both open and close are "Fechado"
        if (weekDay.open == "Fechado" && weekDay.close == "Fechado") {
          const workingText = 'Fechado';
          const workingTextColor = AppColors.darkGray;

          return Semantics(
            label: 'Horário de funcionamento: ',
            child: ListTile(
              leading: Text(weekDay.day, style: const TextStyle(fontSize: 16)),
              trailing: const Text(
                workingText,
                style: TextStyle(fontSize: 14, color: workingTextColor),
              ),
            ),
          );
        }

        final workingText = '${weekDay.open} até ${weekDay.close}';
        final workingTextColor = weekDay.open != weekDay.close
            ? colorBlindnessColorScheme(
                    ColorScheme.fromSeed(seedColor: AppColors.green),
                    Provider.of<ProviderColorBlindnessType>(context)
                        .getCurrentType())
                .primary
            : AppColors.darkGray;

        return Semantics(
          label: 'Horário de funcionamento: ',
          child: ListTile(
            leading: Text(weekDay.day, style: const TextStyle(fontSize: 16)),
            trailing: Text(
              workingText,
              style: TextStyle(fontSize: 14, color: workingTextColor),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Semantics(
      label: '$label: $value',
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          label,
          semanticsLabel: '',
          style: const TextStyle(
            color: AppColors.darkGray,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          value,
          semanticsLabel: '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilityDashboard() {
    final accessibilityData = companyData?.accessibilityData?.accessibilityData;
    final defaultAccessibilityData = {
      "Acessibilidade Física": [
        {"tipo": "Rampas", "status": false},
        {"tipo": "Elevadores", "status": false},
        {"tipo": "Portas Largas", "status": false},
        {"tipo": "Banheiros Adaptados", "status": false},
        {
          "tipo": "Pisos Táteis e Superfícies Anti-derrapantes",
          "status": false
        },
        {"tipo": "Estacionamento Reservado", "status": false}
      ],
      "Acessibilidade Comunicacional": [
        {"tipo": "Sinalização com Braille e Pictogramas", "status": false},
        {"tipo": "Informações Visuais Claras e Contrastantes", "status": false},
        {"tipo": "Dispositivos Auditivos", "status": false},
        {
          "tipo": "Documentos e Materiais em Formatos Acessíveis",
          "status": false
        }
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
    if (accessibilityData == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: defaultAccessibilityData.entries.map((entry) {
            final category = entry.key;
            final items = entry.value;
            final completedItems = accessibilityData[category]
                ?.where((item) => item.status)
                .length;

            return Semantics(
              label: 'Categoria: $category',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(category, semanticsLabel: ''),
                      Text(
                        '${completedItems ?? 0}/${items.length}',
                        semanticsLabel: '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Semantics(
                    child: LinearProgressIndicator(
                      value: items.isEmpty
                          ? 0
                          : completedItems != null
                              ? completedItems / items.length
                              : 0,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
