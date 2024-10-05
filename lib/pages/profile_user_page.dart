import 'dart:io';

import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  File? imageFile;

  // final ImagePicker _picker = ImagePicker();
  final imagePicker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: imageFile != null
                              ? FileImage(
                                  imageFile!) // Mostrar a imagem selecionada
                              : const AssetImage(
                                      'assets/images/placeholder-user.png')
                                  as ImageProvider, // Imagem padrão
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: AppColors.veryLightPurple,
                                shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: _showOpcoesBottomSheet,
                              icon: const Icon(
                                Icons.camera_alt,
                                color: AppColors.lightPurple,
                                size: 23,
                              ),
                              // onPressed: _pickImage, // Selecionar imagem
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0)),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Data de nascimento',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0)),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'CPF',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0)),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Confirmar senha',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsetsDirectional.symmetric(
                            horizontal: 16.0, vertical: 12.0)),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Atualizações salvas com sucesso')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0)),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 45),
                  Row(
                    children: [
                      const Icon(Icons.lock_clock_outlined,
                          color: AppColors.lightPurple),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Redefinir senha',
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.delete_outline,
                          color: AppColors.lightPurple),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Excluir conta',
                          style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.exit_to_app,
                          color: AppColors.lightPurple),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sair',
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  // child: Center(
                  //   // child: Icon(
                  //   //   // PhosphorIcons.regular.image,
                  //   //   // color: Colors.grey[500],
                  //   // ),
                  // ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Buscar imagem da galeria
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  // child: Center(
                  //   child: Icon(
                  //     // PhosphorIcons.regular.camera,
                  //     // color: Colors.grey[500],
                  //   ),
                  // ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Fazer foto da câmera
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  // child: Center(
                  //   child: Icon(
                  //     // PhosphorIcons.regular.trash,
                  //     // color: Colors.grey[500],
                  //   ),
                  // ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // Tornar a foto null
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
