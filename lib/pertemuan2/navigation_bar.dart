import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_rounded, color: Colors.white, size: 28),
          Icon(Icons.folder_rounded, color: Colors.white54, size: 28),
          Icon(Icons.chat_bubble_rounded, color: Colors.white54, size: 28),
          Icon(Icons.settings_rounded, color: Colors.white54, size: 28),
        ],
      ),
    );
  }
}