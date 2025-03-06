import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:acesso_mapeado/shared/logger.dart';
import 'package:color_blindness/color_blindness.dart';
import 'package:flutter/material.dart';
import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:provider/provider.dart';

class AccessibilitySection extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> items;

  const AccessibilitySection({
    super.key,
    required this.category,
    required this.items,
  });

  IconData _getIconForTipo(String tipo) {
    Logger.logInfo('Tipo: $tipo');
    switch (tipo) {
      case 'Acessibilidade Sensorial':
        return Icons.hearing;
      case 'Acessibilidade Física':
        return Icons.accessible;
      case 'Acessibilidade Atitudinal':
        return Icons.handshake_rounded;
      case 'Acessibilidade Comunicacional':
        return Icons.chat;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(_getIconForTipo(category),
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.small),
          Text(
            category,
            style: const TextStyle(
              fontSize: AppTypography.large,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      children: items.map((item) {
        String status =
            item["status"] ? 'O local possui' : 'O local não possui';
        String tipo = item["tipo"] ?? 'Tipo não disponível';
        return ListTile(
          title: Text(
            tipo,
            semanticsLabel: '$status $tipo',
            style: const TextStyle(color: AppColors.darkGray),
          ),
          trailing: item["status"] ?? false
              ? Icon(Icons.check,
                  color: colorBlindnessColorScheme(
                          ColorScheme.fromSeed(seedColor: AppColors.green),
                          Provider.of<ProviderColorBlindnessType>(context,
                                  listen: false)
                              .getCurrentType())
                      .primary)
              : Icon(Icons.close,
                  color: colorBlindnessColorScheme(
                          ColorScheme.fromSeed(seedColor: AppColors.red),
                          Provider.of<ProviderColorBlindnessType>(context,
                                  listen: false)
                              .getCurrentType())
                      .primary),
        );
      }).toList(),
    );
  }
}
