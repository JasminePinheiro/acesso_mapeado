import 'dart:convert';

import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/controllers/company_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:acesso_mapeado/widgets/color_blind_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RatePage extends StatefulWidget {
  const RatePage({super.key, required this.company});
  final CompanyModel company;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  final TextEditingController _comment = TextEditingController();

  double _rating = 0;
  List<CompanyModel> companies = [];
  final List<String> _selectedPhotos = [];

  bool sending = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedPhotos.clear();
    super.dispose();
  }

  Future<void> pickImages() async {
    final imagePicker = ImagePicker();
    List<XFile> images = await imagePicker.pickMultiImage(
        maxHeight: 500.0, maxWidth: 500.0, imageQuality: 85);

    if (images.isEmpty) return;
    for (var image in images) {
      final bytesImage = await image.readAsBytes();
      final imageBase64 = base64Encode(bytesImage);
      setState(() {
        _selectedPhotos.add('data:image/jpeg;base64,$imageBase64');
      });
    }
  }

  // Função para adicionar comentário e avaliação
  addCommentAndRating() async {
    if (sending) return;

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação não pode ser 0.')),
      );
      return;
    }
    setState(() {
      sending = true;
    });

    bool result = await Provider.of<CompanyController>(context, listen: false)
        .addUserComment(widget.company.uuid, _comment.text, _rating, context,
            _selectedPhotos);
    bool ratingResult =
        await Provider.of<CompanyController>(context, listen: false)
            .addCompanyUserRating(widget.company.uuid, _rating);
    await getCompanies();

    if (!mounted) return;

    if (result && ratingResult) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avaliação enviada com sucesso!'),
          duration: Duration(seconds: 1),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          sending = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      setState(() {
        sending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar avaliação.')),
      );
    }
  }

  Future<void> getCompanies() async {
    try {
      companies = await Provider.of<CompanyController>(context, listen: false)
          .getAllCompanies();
      Logger.logInfo("Empresas carregadas: ${companies.length}");

      if (!mounted) return;
      Provider.of<CompanyController>(context, listen: false)
          .updateCompanies(companies);
      setState(() {});
    } catch (e) {
      Logger.logError('Erro ao carregar empresas: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar empresas.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                  color: AppColors.darkGray.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2))
            ],
          ),
        ),
        leading: Semantics(
          label: 'Botão voltar',
          child: IconButton(
            icon: Image.asset('assets/icons/arrow-left.png'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Row(
          children: [
            Semantics(
              child: Text(
                'Avaliar ${widget.company.name}',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            label: 'Nome do usuário',
                            child: Text(
                              Provider.of<UserController>(context)
                                  .userModel!
                                  .name,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Semantics(
                            label: 'Aviso de postagem pública',
                            child: Row(
                              children: [
                                const Text(
                                  'Sua postagem será pública.',
                                  style: TextStyle(
                                      fontSize: 14, color: AppColors.darkGray),
                                ),
                                Icon(Icons.warning_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label:
                      'Barra de avaliação com estrelas. Avaliação atual: $_rating estrelas',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) => Semantics(
                        label:
                            'Estrela de avaliação para nota ${(index + 1).toString()}',
                        child: Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Semantics(
                    label: 'Campo de texto para comentário',
                    hint: 'Digite sua experiência neste lugar',
                    child: TextField(
                      maxLines: 4,
                      controller: _comment,
                      decoration: InputDecoration(
                        hintText: 'Conte como foi sua experiência neste lugar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Semantics(
                        label: 'Botão para adicionar fotos',
                        child: TextButton.icon(
                          onPressed: pickImages,
                          icon: Icon(Icons.add_a_photo,
                              color: Theme.of(context).colorScheme.primary),
                          label: Text(
                            'Adicionar foto',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      if (_selectedPhotos.isNotEmpty)
                        Semantics(
                          label: 'Galeria de fotos selecionadas',
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedPhotos.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Semantics(
                                            label:
                                                'Foto ${index + 1} selecionada',
                                            child: ColorBlindImage(
                                              imageProvider: MemoryImage(
                                                base64Decode(
                                                    _selectedPhotos[index]
                                                        .split(',')[1]),
                                              ),
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Semantics(
                                          label: 'Remover foto ${index + 1}',
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedPhotos.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .error,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.white,
                                                  size: 18,
                                                  weight: 800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Semantics(
                    label: sending
                        ? 'Enviando avaliação...'
                        : 'Botão enviar avaliação',
                    child: ElevatedButton(
                      onPressed: sending
                          ? null
                          : () {
                              addCommentAndRating();
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: sending
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : Theme.of(context).colorScheme.primary,
                      ),
                      child: sending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                              'Enviar avaliação',
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
