import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/pages/home_page.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatePage extends StatefulWidget {
  const RatePage({super.key, required this.company});

  final CompanyModel company;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
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
        leading: IconButton(
          icon: Image.asset('assets/icons/arrow-left.png'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.company.imageUrl ?? ''),
              radius: 25,
            ),
            const SizedBox(width: 14),
            Text(
              'Avaliar ${widget.company.name}',
              style:
                  const TextStyle(color: AppColors.lightPurple, fontSize: 18),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Row(
              children: [
                Image(
                  image: AssetImage('assets/images/placeholder-user.png'),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome do Usuário',
                      style:
                          TextStyle(fontSize: 18, color: AppColors.lightPurple),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Sua postagem será pública.',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.darkGray),
                        ),
                        Icon(Icons.warning_rounded,
                            color: AppColors.lightPurple),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                if (kDebugMode) {
                  print(rating);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Conte como foi sua experiência neste lugar',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_a_photo, color: AppColors.lightPurple),
              label: const Text(
                'Adicionar foto',
                style: TextStyle(color: AppColors.lightPurple),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: AppColors.lightPurple,
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
