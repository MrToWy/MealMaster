import 'package:flutter/material.dart';
import 'package:mealmaster/common/widgets/custom_app_bar.dart';
import 'package:mealmaster/features/user_profile/data/user_repository.dart';

import '../user_profile/presentation/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    UserRepository().hasUser().then((hasUser) {
      if (!context.mounted) {
        return;
      }
      if (hasUser) {
        Navigator.popAndPushNamed(context, "/navigation");
        return;
      }
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                  appBar: CustomAppBar(title: "MealMe"),
                  body: const ProfileScreen(firstTime: true))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Meal Master",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
