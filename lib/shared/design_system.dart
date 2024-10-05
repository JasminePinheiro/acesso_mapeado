import 'dart:ui';

/// Uma classe que define a paleta de cores do aplicativo.
class AppColors {
  AppColors._(); // Impede a instanciação da classe

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
  static const Color red = Color(0xFFE53935);
}

/// Uma classe que define os valores de espaçamento do aplicativo.
class AppSpacing {
  AppSpacing._(); // Impede a instanciação da classe

  /// Valor de espaçamento pequeno usado para elementos compactos como padding ou margens.
  static const double small = 8.0;

  /// Valor de espaçamento médio usado para padding ou margens padrão.
  static const double medium = 16.0;

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
