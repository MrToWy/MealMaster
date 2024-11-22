import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/home_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/user_profile/presentation/profile_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ShoppingListScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Hallo User!',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorShape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 2),
        ),
        indicatorColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.format_list_bulleted, size: iconSize),
            selectedIcon: Icon(Icons.format_list_bulleted, size: iconSize),
            label: 'Shopping list',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: iconSize),
            selectedIcon: Icon(Icons.home, color: Colors.white, size: iconSize),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: iconSize),
            selectedIcon: Icon(Icons.person, size: iconSize),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
