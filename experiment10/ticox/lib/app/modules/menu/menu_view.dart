import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[300]!, Colors.purple[200]!, Colors.pink[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grid_3x3,
                size: 80,
                color: Colors.white.withOpacity(0.85),
              ),
              SizedBox(height: 16),
              Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              _menuButton(
                context,
                icon: Icons.smart_toy,
                label: 'Player vs AI',
                color: Colors.deepPurpleAccent,
                onTap: () =>
                    Get.toNamed(Routes.GAME, arguments: {'mode': 'ai'}),
              ),
              SizedBox(height: 20),
              _menuButton(
                context,
                icon: Icons.people,
                label: 'Player vs Player',
                color: Colors.pinkAccent,
                onTap: () =>
                    Get.toNamed(Routes.GAME, arguments: {'mode': 'pvp'}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 240,
      height: 60,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: color.withOpacity(0.3),
        ),
        onPressed: onTap,
      ),
    );
  }
}
