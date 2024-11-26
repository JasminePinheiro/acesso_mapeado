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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: AppColors.lightGray,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.onItemTapped,
      ),
    );
  }
}
