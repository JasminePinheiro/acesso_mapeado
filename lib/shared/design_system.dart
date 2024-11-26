import 'package:flutter/material.dart';

/// Uma classe que define a paleta de cores do aplicativo.
class AppColors {
  AppColors._(); // Impede a instanciação da classe

  static const MaterialColor purple = MaterialColor(
    _purplePrimaryValue,
    <int, Color>{
      50: Color(0xFFF3E5F5),
      100: Color(0xFFE1BEE7),
      200: Color(0xFFCE93D8),
      300: Color(0xFFBA68C8),
      400: Color(0xFFAB47BC),
      500: Color(_purplePrimaryValue),
      600: Color(0xFF8E24AA),
      700: Color(0xFF7B1FA2),
      800: Color(0xFF6A1B9A),
      900: Color(0xFF4A148C),
    },
  );
  static const int _purplePrimaryValue = 0XFFD268CC;

  /// Um tom suave de roxo claro usado para destaques ou acentos.
  static const Color lightPurple = Color(0XFFD268CC);

  /// Um tom muito claro de roxo usado como fundo ou elementos secundários.
  static const Color veryLightPurple = Color(0XFFFFEDFE);

  /// Um branco puro usado para texto ou fundo.
  static const Color white = Color(0xFFFFFFFF);

  /// Um preto puro usado para texto ou fundos escuros.
  static const Color black = Color(0xFF000000);

  /// Um tom de cinza escuro usado para textos menos proeminentes ou ícones.
  static const Color darkGray = Color(0xFF8E8E8E);

  /// Um cinza claro usado para bordas sutis ou elementos desativados.
  static const Color lightGray = Color(0xFFB7B7B7);

  /// um vermelho brilhante usado para indicadores de erro ou alertas.
  /// Este é o único tom de vermelho disponível.
  static const MaterialColor red = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(_redPrimaryValue),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  static const int _redPrimaryValue = 0xFFE53935;

  /// Um amarelo claro usado para destaques ou ícones.
  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE082),
      300: Color(0xFFFFD54F),
      400: Color(0xFFFFCA28),
      500: Color(_yellowPrimaryValue),
      600: Color(0xFFFFB300),
      700: Color(0xFFFFA000),
      800: Color(0xFFFF8F00),
      900: Color(0xFFFF6F00),
    },
  );
  static const int _yellowPrimaryValue = 0xFFFFC107;

  /// Um verde claro usado para destaques ou ícones.
  static const MaterialColor green = MaterialColor(
    _greenPrimaryValue,
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(_greenPrimaryValue),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );
  static const int _greenPrimaryValue = 0xFF4CAF50;
}

/// Uma classe que define os valores de espaçamento do aplicativo.
class AppSpacing {
  AppSpacing._(); // Impede a instanciação da classe

  /// Valor de espaçamento extra pequeno usado para elementos muito compactos como padding ou margens.
  static const double extraSmall = 4.0;

  /// Valor de espaçamento pequeno usado para elementos compactos como padding ou margens.
  static const double small = 8.0;

  /// Valor de espaçamento médio usado para padding ou margens padrão.
  static const double medium = 16.0;

  /// Valor de espaçamento extra médio usado para seções ou separações maiores.
  static const double extraMedium = 20.0;

  /// Valor de espaçamento grande usado para seções ou separações maiores.
  static const double large = 24.0;

  /// Valor de espaçamento extra grande usado para seções largas ou separações grandes.
  static const double xLarge = 32.0;
}

/// Uma classe que define os valores de tipografia do aplicativo.
class AppTypography {
  AppTypography._(); // Impede a instanciação da classe

  /// Tamanho de fonte pequeno usado para textos menos proeminentes ou rótulos.
  static const double small = 12.0;

  /// Tamanho de fonte médio usado para textos padrão.
  static const double medium = 14.0;

  /// Tamanho de fonte grande usado para títulos ou textos importantes.
  static const double large = 16.0;

  /// Tamanho de fonte extra grande usado para títulos ou cabeçalhos proeminentes.
  static const double xLarge = 18.0;

  /// Tamanho de fonte extra extra grande usado para títulos ou cabeçalhos muito proeminentes.
  /// Este é o maior tamanho de fonte disponível.
  static const double xxLarge = 20.0;
}
