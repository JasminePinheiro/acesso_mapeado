import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightPurple),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.lightPurple),
        label: Text(
          label,
          style: const TextStyle(color: AppColors.lightPurple),
        ),
      ),
    );
  }
}
