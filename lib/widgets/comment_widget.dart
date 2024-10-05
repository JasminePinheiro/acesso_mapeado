import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String title;
  final String userName;
  final String userImage;
  final String text;
  final String date;

  const CommentWidget({
    super.key,
    required this.title,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(userImage),
                radius: 20.0,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.lightGray),
        ],
      ),
    );
  }
}
