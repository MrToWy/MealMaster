import 'package:flutter/material.dart';
import 'package:mealmaster/common/widgets/custom_app_bar.dart';
import 'package:mealmaster/features/user_profile/data/user_repository.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/shopping_list/presentation/shopping_list_screen.dart';
import '../../features/user_profile/presentation/profile_screen.dart';

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
        return CustomAppBar(title: 'MealList');
      case 1:
        return null;
      case 2:
        return CustomAppBar(title: 'MealMe', actions: [
          IconButton(
              onPressed: () {
                editAPIKeyDialog(context);
              },
              icon: Icon(Icons.vpn_key)),
        ]);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 30;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined, size: iconSize),
            label: 'Einkaufsliste',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: iconSize),
            label: 'MealPlan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, size: iconSize),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

Future editAPIKeyDialog(context) async {
  String apiKey = await UserRepository().getAPIKey();
  TextEditingController controller = TextEditingController();
  controller.text = apiKey;

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("API-Key ändern"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [TextField(controller: controller)]),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Abbrechen")),
              TextButton(
                  onPressed: () async {
                    if (!context.mounted) {
                      //add error Message
                      return;
                    }
                    await UserRepository().setAPIKey(controller.value.text);
                    Navigator.of(context).pop();
                  },
                  child: Text("Speichern"))
            ],
          ));
}
