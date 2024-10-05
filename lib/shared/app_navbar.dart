import 'package:acesso_mapeado/shared/design_system.dart';
import 'package:flutter/material.dart';

class AppNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.lightPurple,
      unselectedItemColor: AppColors.lightGray,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          backgroundColor: AppColors.white,
          icon: Icon(Icons.map_outlined),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.white,
          icon: Icon(Icons.chat_outlined),
          label: 'Bate-Papo',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.white,
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Ranking',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.white,
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
      currentIndex: widget.selectedIndex,
      onTap: widget.onItemTapped,
    );
  }
}
