// widgets/accessibility_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'info_tile.dart';
import 'custom_button.dart';
import 'comment_widget.dart';
import 'accessibility_section.dart';
import 'package:acesso_mapeado/pages/rate_page.dart';

class AccessibilitySheet extends StatelessWidget {
  final CompanyModel companyModel;

  const AccessibilitySheet({super.key, required this.companyModel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Tamanho inicial (70% da tela)
      minChildSize: 0.3, // Tamanho mínimo ao arrastar para baixo
      maxChildSize: 0.9, // Tamanho máximo ao arrastar para cima
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              // Indicador de arraste
              const SizedBox(
                height: 32.0,
                child: Center(
                  child: Divider(
                    color: AppColors.lightGray,
                    thickness: 2.0,
                    indent: 150.0,
                    endIndent: 150.0,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // Título e Rating
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    // Nome da Empresa
                    Expanded(
                      child: Text(
                        companyModel.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    // Rating
                    Column(
                      children: [
                        Text(
                          companyModel.rating?.toStringAsFixed(1) ?? '0.0',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < (companyModel.rating?.floor() ?? 0)
                                  ? Colors.yellow
                                  : Colors.grey,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              // Imagem da Empresa
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: companyModel.imageUrl != null &&
                          companyModel.imageUrl!.isNotEmpty
                      ? Image.network(
                          companyModel.imageUrl!,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/img-company.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 10.0),
              // Botões de Ação
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      icon: Icons.star,
                      label: 'Avaliar',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatePage(
                              company: companyModel,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                      icon: Icons.message_outlined,
                      label: 'Chat',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Funcionalidade de chat em desenvolvimento!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              // Endereço
              InfoTile(
                icon: Icons.location_on,
                text: companyModel.address,
              ),
              const SizedBox(height: 10.0),
              // Mapa da Localização
              SizedBox(
                width: double.infinity,
                height: 200,
                child: GoogleMap(
                  markers: <Marker>{
                    Marker(
                      markerId: MarkerId(companyModel.name),
                      position:
                          LatLng(companyModel.latitude, companyModel.longitude),
                      infoWindow: InfoWindow(
                        title: companyModel.name,
                        snippet: companyModel.address,
                      ),
                    ),
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(companyModel.latitude, companyModel.longitude),
                    zoom: 15,
                  ),
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                ),
              ),
              const SizedBox(height: 20.0),
              // Telefone e Horário de Funcionamento
              InfoTile(
                icon: Icons.phone,
                text: companyModel.phoneNumber ?? 'Telefone não disponível',
              ),
              InfoTile(
                icon: Icons.access_time,
                text: companyModel.workingHours ??
                    'Horário de funcionamento não disponível',
              ),
              const SizedBox(height: 20.0),
              // Seção de Acessibilidade
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Informações de Acessibilidade',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              // Acessibilidade
              if (companyModel.accessibilityData != null &&
                  companyModel.accessibilityData!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true, // Ajusta o tamanho conforme o conteúdo
                  physics: // Desabilita o scroll interno
                      const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: companyModel.accessibilityData!.length,
                  itemBuilder: (context, index) {
                    String category =
                        companyModel.accessibilityData!.keys.elementAt(index);
                    List<Map<String, dynamic>> items =
                        companyModel.accessibilityData![category]!;
                    return AccessibilitySection(
                      category: category,
                      items: items,
                    );
                  },
                ),
              const SizedBox(height: 20.0),
              // Seção de Comentários
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Comentários',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              if (companyModel.commentsData != null &&
                  companyModel.commentsData!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true, // Ajusta o tamanho conforme o conteúdo
                  physics: // Desabilita o scroll interno
                      const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: companyModel.commentsData!.length,
                  itemBuilder: (context, index) {
                    var comment = companyModel.commentsData![index];
                    return CommentWidget(
                      title: comment["title"] ?? 'Título não disponível',
                      userName: comment["userName"] ??
                          'Nome do usuário não disponível',
                      userImage: comment["userImage"] != null &&
                              comment["userImage"]!.isNotEmpty
                          ? comment["userImage"]!
                          : 'assets/images/placeholder-user.png',
                      text: comment["text"] ?? 'Comentário não disponível',
                      date: comment["date"] ?? 'Data não disponível',
                    );
                  },
                ),
              const SizedBox(height: 20.0),
              // Seção de Desempenho da Empresa
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Desempenho da Empresa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              if (companyModel.performanceData != null &&
                  companyModel.performanceData!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true, // Ajusta o tamanho conforme o conteúdo
                  physics: // Desabilita o scroll interno
                      const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: companyModel.performanceData!.length,
                  itemBuilder: (context, index) {
                    var entry =
                        companyModel.performanceData!.entries.elementAt(index);
                    return ListTile(
                      leading: Icon(
                        switch (entry.key) {
                          'Acessibilidade' => Icons.accessibility,
                          'Atendimento' => Icons.headset_mic,
                          'Estrutura' => Icons.home,
                          'Limpeza' => Icons.cleaning_services,
                          'Qualidade' => Icons.star,
                          'Segurança' => Icons.security,
                          'Crescimento Anual' => Icons.trending_up,
                          'Impacto Ambiental' => Icons.eco,
                          _ => Icons.help_outline,
                        },
                        color: AppColors.lightPurple,
                      ),
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    );
                  },
                ),
              const SizedBox(height: 20.0),
              // Seção Sobre a Empresa
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Sobre',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CNPJ
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'CNPJ: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightPurple,
                            ),
                          ),
                          TextSpan(
                            text: companyModel.cnpj ?? 'CNPJ não disponível',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Data de Cadastro
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Data de Cadastro: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightPurple,
                            ),
                          ),
                          TextSpan(
                            text: companyModel.registrationDate ??
                                'Data de cadastro não disponível',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Descrição Sobre a Empresa
                    Text(
                      companyModel.about ??
                          'Informações sobre a empresa não disponíveis.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}
