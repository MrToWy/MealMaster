import 'package:flutter/material.dart';
import 'package:mealmaster/features/home/presentation/widgets/home_appbar.dart';
import 'package:mealmaster/features/home/presentation/home_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/shopping_list_screen.dart';
import 'package:mealmaster/features/shopping_list/presentation/widget/shopping_list_appbar.dart';
import 'package:mealmaster/features/user_profile/presentation/profile_screen.dart';
import 'package:mealmaster/features/user_profile/presentation/widgets/profile_appbar.dart';

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

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return ShoppingListAppBar();
      case 1:
        return HomeAppBar();
      case 2:
        return ProfileAppBar();
      default:
        return HomeAppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 40;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: Colors.white.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.format_list_bulleted,
                color: Colors.white, size: iconSize),
            selectedIcon: Icon(Icons.format_list_bulleted,
                color: Colors.white, size: iconSize),
            label: 'Shopping list',
          ),
          NavigationDestination(
            icon:
                Icon(Icons.home_outlined, color: Colors.white, size: iconSize),
            selectedIcon: Icon(Icons.home, color: Colors.white, size: iconSize),
            label: 'Home',
          ),
          NavigationDestination(
            icon:
                Icon(Icons.person_outline, color: Colors.white, size: iconSize),
            selectedIcon:
                Icon(Icons.person, color: Colors.white, size: iconSize),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
