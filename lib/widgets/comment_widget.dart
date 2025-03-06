import 'dart:convert';

import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:acesso_mapeado/widgets/color_blind_image.dart';
import 'package:acesso_mapeado/widgets/image_zoom_widget.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String? userName;
  final String? userImage;
  final String? text;
  final String? date;
  final double? rate;
  final List<String>? photos;

  const CommentWidget({
    super.key,
    this.userName,
    this.userImage,
    this.text,
    this.date,
    this.rate,
    this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: 'Foto do perfil de ${userName ?? 'usuário'}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: ColorBlindImage(
                    imageProvider: userImage != null && userImage!.isNotEmpty
                        ? MemoryImage(base64Decode(userImage!))
                        : const AssetImage('assets/images/placeholder-user.png')
                            as ImageProvider,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Semantics(
                          label: 'Nome do usuário',
                          child: Text(
                            userName ?? 'Nome do usuário não disponível',
                            style: const TextStyle(
                              fontSize: AppTypography.large,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        Semantics(
                          label:
                              'Avaliação: ${rate?.toStringAsFixed(1) ?? '0.0'} estrelas',
                          child: Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: index < (rate ?? 0)
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                size: 20,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    ...[
                      if (text != null && text!.isNotEmpty)
                        Semantics(
                          label: 'Comentário: $text',
                          child: Text(
                            text ?? 'Comentário não disponível',
                            semanticsLabel: '',
                            style:
                                const TextStyle(fontSize: AppTypography.large),
                          ),
                        ),
                      const SizedBox(height: 4.0),
                    ],
                    Semantics(
                      label:
                          'Data do comentário: ${date != null ? formatDate(DateTime.parse(date!), [
                                  HH,
                                  ':',
                                  nn,
                                  ' ',
                                  dd,
                                  '/',
                                  mm,
                                  '/',
                                  yyyy
                                ]) : 'Data não disponível'}',
                      child: Text(
                        date != null
                            ? formatDate(
                                DateTime.parse(date!),
                                [HH, ':', nn, ' ', dd, '/', mm, '/', yyyy],
                              )
                            : 'Data não disponível',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (photos != null && photos!.isNotEmpty)
            Semantics(
              label:
                  'Galeria de fotos do comentário com ${photos!.length} imagens',
              child: SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: photos!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageZoomWidget(
                                  photos: photos!, initialIndex: index),
                            ),
                          );
                        },
                        child: Semantics(
                          label: 'Imagem ${index + 1} do comentário',
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: ColorBlindImage(
                                  imageProvider: MemoryImage(
                                    base64Decode(photos![index].split(',')[1]),
                                  ),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          const Divider(color: AppColors.lightGray),
        ],
      ),
    );
  }
}
