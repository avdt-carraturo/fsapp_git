import 'package:flutter/material.dart';

class FooterNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FooterNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFD6001C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Security'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mappa'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifiche'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Registrati'),
      ],
    );
  }
}
