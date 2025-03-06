import 'package:flutter/material.dart';
import 'package:color_blindness/color_blindness.dart';
import 'package:provider/provider.dart';
import 'package:acesso_mapeado/shared/color_blindness_type.dart';

class ColorBlindImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ColorBlindImage({
    super.key,
    required this.imageProvider,
    this.width,
    this.height,
    this.fit,
  });

  List<double> _getColorMatrix(ColorBlindnessType type) {
    switch (type) {
      case ColorBlindnessType.protanopia:
        return [
          0.56667,
          0.43333,
          0,
          0,
          0,
          0.55833,
          0.44167,
          0,
          0,
          0,
          0,
          0.24167,
          0.75833,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.deuteranopia:
        return [
          0.625,
          0.375,
          0,
          0,
          0,
          0.7,
          0.3,
          0,
          0,
          0,
          0,
          0.3,
          0.7,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.tritanopia:
        return [
          0.95,
          0.05,
          0,
          0,
          0,
          0,
          0.43,
          0.56,
          0,
          0,
          0,
          0.4755,
          0.525,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.protanomaly:
        return [
          0.81667,
          0.18333,
          0,
          0,
          0,
          0.33333,
          0.66667,
          0,
          0,
          0,
          0,
          0.125,
          0.875,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.deuteranomaly:
        return [
          0.80,
          0.20,
          0,
          0,
          0,
          0.25833,
          0.74167,
          0,
          0,
          0,
          0,
          0.14167,
          0.85833,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.tritanomaly:
        return [
          0.9667,
          0.033,
          0,
          0,
          0,
          0,
          0.733,
          0.2667,
          0,
          0,
          0,
          0.183,
          0.8167,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.achromatopsia:
        return [
          0.299,
          0.587,
          0.114,
          0,
          0,
          0.299,
          0.587,
          0.114,
          0,
          0,
          0.299,
          0.587,
          0.114,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.achromatomaly:
        return [
          0.618,
          0.32,
          0.062,
          0,
          0,
          0.163,
          0.775,
          0.062,
          0,
          0,
          0.163,
          0.32,
          0.516,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
      case ColorBlindnessType.none:
      default:
        return [
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderColorBlindnessType>(
      builder: (context, provider, child) {
        return ColorFiltered(
          colorFilter:
              ColorFilter.matrix(_getColorMatrix(provider.getCurrentType())),
          child: Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
          ),
        );
      },
    );
  }
}
