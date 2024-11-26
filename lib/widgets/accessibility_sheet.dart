import 'dart:convert';

import 'package:acesso_mapeado/models/accessibility_model.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';

import 'package:acesso_mapeado/shared/logger.dart';
import 'package:acesso_mapeado/shared/map_styles.dart';
import 'package:acesso_mapeado/widgets/color_blind_image.dart';
import 'package:color_blindness/color_blindness_color_scheme.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'info_tile.dart';
import 'custom_button.dart';
import 'comment_widget.dart';
import 'accessibility_section.dart';
import 'package:acesso_mapeado/pages/rate_page.dart';

class AccessibilitySheet extends StatefulWidget {
  final CompanyModel companyModel;

  const AccessibilitySheet({super.key, required this.companyModel});

  @override
  State<AccessibilitySheet> createState() => _AccessibilitySheetState();
}

class _AccessibilitySheetState extends State<AccessibilitySheet> {
  // Constantes para valores frequentemente usados
  static const double _defaultImageSize = 150.0;
  static const double _defaultFontSize = 18.0;
  static const double _titleFontSize = 22.0;

  bool isMapExpanded = false;
  double mapHeight = 200;

  void toggleMapHeight() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(widget.companyModel.fullAddress),
          ),
          body: Stack(
            children: [
              GoogleMap(
                style: MapStyles.getColorBlindStyle(
                    Provider.of<ProviderColorBlindnessType>(context)
                        .getCurrentType()),
                markers: <Marker>{
                  Marker(
                    markerId: MarkerId(widget.companyModel.name),
                    position: LatLng(
                      widget.companyModel.latitude ?? 0.0,
                      widget.companyModel.longitude ?? 0.0,
                    ),
                  ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.companyModel.latitude ?? 0.0,
                    widget.companyModel.longitude ?? 0.0,
                  ),
                  zoom: 15,
                ),
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
              ),
              //button to open googlemaps on directions api
              Positioned(
                bottom: 16,
                right: 16,
                child: CustomButton(
                  label: 'Como chegar',
                  icon: Icons.directions,
                  onPressed: () async {
                    final Uri uri = Uri.parse(
                        'https://www.google.com/maps/dir/?api=1&destination=${widget.companyModel.latitude},${widget.companyModel.longitude}');
                    await launchUrl(uri);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.extraMedium),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragIndicator(),
                  const SizedBox(height: AppSpacing.small),
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.small),
                  _buildCompanyImage(),
                  const SizedBox(height: AppSpacing.medium),
                  _buildActionButtons(),
                  const SizedBox(height: AppSpacing.medium),
                  _buildLocationSection(),
                  const SizedBox(height: AppSpacing.medium),
                  _buildMap(),
                  // ... continue refactoring other sections
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDragIndicator() {
    return const SizedBox(
      height: AppSpacing.xLarge,
      child: Center(
        child: Divider(
          color: AppColors.lightGray,
          thickness: 2.0,
          indent: AppSpacing.xLarge * 4.7,
          endIndent: AppSpacing.xLarge * 4.7,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.companyModel.name,
            style: const TextStyle(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ),
        _buildRating(),
      ],
    );
  }

  Widget _buildCompanyImage() {
    return Center(
      child: widget.companyModel.imageUrl != null &&
              widget.companyModel.imageUrl!.isNotEmpty &&
              widget.companyModel.imageUrl!.contains(',')
          ? SizedBox(
              width: _defaultImageSize,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.xLarge),
                  child: ColorBlindImage(
                    imageProvider: MemoryImage(
                      base64Decode(widget.companyModel.imageUrl!.split(',')[1]),
                    ),
                    width: _defaultImageSize,
                    height: _defaultImageSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : Image.asset(
              'assets/images/img-company.png',
              height: _defaultImageSize,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: _defaultFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Column(
      children: [
        Semantics(
          label:
              'Avaliação da empresa ${widget.companyModel.name} - nota ${widget.companyModel.rating?.toStringAsFixed(1) ?? '0.0'}',
          child: Column(
            children: [
              Text(
                widget.companyModel.rating?.toStringAsFixed(1) ?? '0.0',
                semanticsLabel: '',
                style: const TextStyle(
                  fontSize: AppSpacing.medium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < (widget.companyModel.rating?.ceil() ?? 0)
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    size: 20,
                  );
                }),
              ),
              Text(
                '(${widget.companyModel.ratings?.length ?? 0})',
                semanticsLabel:
                    'foi avaliada ${widget.companyModel.ratings?.length ?? 0} vezes',
                style: const TextStyle(
                  fontSize: AppSpacing.small,
                  color: AppColors.lightGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.extraSmall, horizontal: AppSpacing.large),
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
                    company: widget.companyModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Localização'),
        InkWell(
          onTap: () async {
            Logger.logInfo('Abrindo Google Maps');
            final Uri uri = Uri.parse(
                'https://www.google.com/maps/search/?api=1&query=${widget.companyModel.address}');

            Logger.logInfo('Abrindo Google Maps: $uri');
            await launchUrl(uri);
          },
          child: InfoTile(
            icon: Icons.location_on,
            text: widget.companyModel.fullAddress,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        // Mapa da Localização
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: mapHeight,
              child: GoogleMap(
                style: MapStyles.getColorBlindStyle(
                    Provider.of<ProviderColorBlindnessType>(context)
                        .getCurrentType()),
                markers: <Marker>{
                  Marker(
                    icon: MapStyles.getColorBlindIcon(
                            Provider.of<ProviderColorBlindnessType>(context)
                                .getCurrentType()) ??
                        BitmapDescriptor.defaultMarker,
                    markerId: MarkerId(widget.companyModel.name),
                    position: LatLng(widget.companyModel.latitude ?? 0.0,
                        widget.companyModel.longitude ?? 0.0),
                    infoWindow: InfoWindow(
                      title: widget.companyModel.name,
                      snippet: widget.companyModel.address,
                    ),
                  ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.companyModel.latitude ?? 0.0,
                      widget.companyModel.longitude ?? 0.0),
                  zoom: 15,
                ),
                zoomGesturesEnabled: false,
                scrollGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
            SizedBox(
              height: mapHeight,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: toggleMapHeight,
                child: const Text(''),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Contatos'),
        const SizedBox(height: AppSpacing.extraMedium),

        // Social Media Links
        SocialMediaLinks(companyModel: widget.companyModel),
        const SizedBox(height: AppSpacing.small),
        _buildWorkingHoursSection(),
        const SizedBox(height: AppSpacing.extraMedium),
        // Seção de Acessibilidade
        _buildAccessibilitySection(),
        const SizedBox(height: AppSpacing.extraMedium),
        // Seção de Comentários
        _buildCommentsSection(),
        const SizedBox(height: AppSpacing.extraMedium),
        // Seção de Desempenho da Empresa
        _buildCompanyPerformanceSection(),
        const SizedBox(height: AppSpacing.extraMedium),
        // Seção Sobre a Empresa
        _buildAboutSection(),
        const SizedBox(height: AppSpacing.extraMedium),
      ],
    );
  }

  Widget _buildWorkingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Horário de funcionamento'),
        // Add working hours section
        if (widget.companyModel.workingHours != null &&
            widget.companyModel.workingHours!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.companyModel.workingHours!.length,
            itemBuilder: (context, index) {
              final weekDay = widget.companyModel.workingHours![index];

              // Skip if both open and close are "Fechado"
              if (weekDay.open == "Fechado" && weekDay.close == "Fechado") {
                const workingText = 'Fechado';
                const workingTextColor = AppColors.darkGray;

                return Semantics(
                  label: 'Horário de funcionamento: ',
                  child: ListTile(
                    leading:
                        Text(weekDay.day, style: const TextStyle(fontSize: 16)),
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
                label: 'Horário de funcionamento: ${weekDay.day} $workingText',
                child: ListTile(
                  title: Text(weekDay.day,
                      semanticsLabel: '', style: const TextStyle(fontSize: 16)),
                  trailing: Text(
                    workingText,
                    semanticsLabel: '',
                    style: TextStyle(fontSize: 14, color: workingTextColor),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAccessibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informações de Acessibilidade'),
        // Acessibilidade
        if (widget.companyModel.accessibilityData != null &&
            widget.companyModel.accessibilityData!.accessibilityData.isNotEmpty)
          Column(
            children: widget
                .companyModel.accessibilityData!.accessibilityData.entries
                .map((entry) {
              String category = entry.key;
              List<AccessibilityItem> items = entry.value;

              List<Map<String, dynamic>> itemsAsMap = items.map((item) {
                return {
                  'tipo': item.type,
                  'status': item.status,
                };
              }).toList();

              return AccessibilitySection(
                category: category,
                items: itemsAsMap,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Comentários'),
        if (widget.companyModel.commentsData != null &&
            widget.companyModel.commentsData!.isNotEmpty)
          Column(
            children: widget.companyModel.commentsData!.map((comment) {
              return CommentWidget(
                userName: comment.userName,
                userImage: comment.userImage,
                text: comment.text,
                date: comment.date,
                rate: comment.rate,
                photos: comment.photos,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildCompanyPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Desempenho da Empresa'),
        Column(
          children: List.generate(5, (index) {
            final rating = 5 - index;
            final ratings = widget.companyModel.ratings;
            final count =
                ratings?.where((r) => r.round() == rating).length ?? 0;
            final total = ratings?.length ?? 0;
            final value = total > 0 ? count / total : 0.0;
            final percentage = (value * 100).toStringAsFixed(1);

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium, vertical: AppSpacing.small),
              child: Semantics(
                label:
                    '$rating estrelas: $count avaliações, representando $percentage% do total',
                child: Row(
                  children: [
                    Text('$rating ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.black)),
                    Text('★',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: AppColors.lightGray,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text('$count',
                        style: const TextStyle(color: AppColors.darkGray)),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sobre'),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium, vertical: AppSpacing.small),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CNPJ
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'CNPJ: ',
                      style: TextStyle(
                        fontSize: AppSpacing.medium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: widget.companyModel.cnpj.replaceAllMapped(
                          RegExp(r'(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})'),
                          (Match m) =>
                              '${m[1]}.${m[2]}.${m[3]}/${m[4]}-${m[5]}'),
                      style: const TextStyle(
                        fontSize: AppSpacing.medium,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              // Data de Cadastro
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Data de Cadastro: ',
                      style: TextStyle(
                        fontSize: AppSpacing.medium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: widget.companyModel.registrationDate != null
                          ? formatDate(
                              DateTime.parse(
                                  widget.companyModel.registrationDate!),
                              [dd, '/', mm, '/', yyyy])
                          : 'Data de cadastro não disponível',
                      style: const TextStyle(
                        fontSize: AppSpacing.medium,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              // Descrição Sobre a Empresa
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Descrição: ',
                      style: TextStyle(
                        fontSize: AppSpacing.medium,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    TextSpan(
                      text: widget.companyModel.about ??
                          'Descrição não disponível',
                      style: const TextStyle(
                        fontSize: AppSpacing.medium,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SocialMediaLinks extends StatelessWidget {
  const SocialMediaLinks({super.key, required this.companyModel});

  final CompanyModel companyModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (companyModel.phoneNumber?.isNotEmpty ?? false)
          SocialMediaLink(
            url: 'tel:${companyModel.phoneNumber}',
            title: companyModel.phoneNumber!,
          ),
        if (companyModel.instagramUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.instagramUrl!,
            iconUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/2048px-Instagram_logo_2016.svg.png',
            title: 'Instagram',
          ),
        if (companyModel.facebookUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.facebookUrl!,
            iconUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Facebook_icon_2013.svg/2048px-Facebook_icon_2013.svg.png',
            title: 'Facebook',
          ),
        if (companyModel.twitterUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.twitterUrl!,
            iconUrl:
                'https://freepnglogo.com/images/all_img/1691832581twitter-x-icon-png.png',
            title: 'X (Twitter)',
          ),
        if (companyModel.linkedinUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.linkedinUrl!,
            iconUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/2048px-LinkedIn_logo_initials.png',
            title: 'LinkedIn',
          ),
        if (companyModel.youtubeUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.youtubeUrl!,
            iconUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/2560px-YouTube_full-color_icon_%282017%29.svg.png',
            title: 'YouTube',
          ),
        if (companyModel.tiktokUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.tiktokUrl!,
            iconUrl: 'https://static.cdnlogo.com/logos/t/19/tiktok.png',
            title: 'TikTok',
          ),
        if (companyModel.pinterestUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.pinterestUrl!,
            iconUrl:
                'https://www.logologo.com/freelogos/Pinterest-P-white-rounded-square.png',
            title: 'Pinterest',
          ),
        if (companyModel.websiteUrl?.isNotEmpty ?? false)
          SocialMediaLink(
            url: companyModel.websiteUrl!,
            iconUrl:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Globe_icon.svg/2048px-Globe_icon.svg.png',
            title: 'Website',
          ),
      ],
    );
  }
}

class SocialMediaLink extends StatelessWidget {
  const SocialMediaLink({
    super.key,
    required this.url,
    required this.title,
    this.iconUrl,
  });

  final String url;
  final String title;
  final String? iconUrl;

  static const double _iconSize = 24.0;
  static const double _subtitleFontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        await launchUrl(uri);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        child: Row(
          children: [
            if (iconUrl != null)
              Image.network(
                iconUrl!,
                fit: BoxFit.contain,
                width: _iconSize,
                height: _iconSize,
              )
            else
              Icon(
                Icons.phone,
                color: Theme.of(context).colorScheme.primary,
                size: _iconSize,
              ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                title,
                semanticsLabel: '',
                style: const TextStyle(
                  fontSize: _subtitleFontSize,
                  color: AppColors.darkGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
