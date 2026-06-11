import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'services/auth_service.dart';
import 'services/post_service.dart';
import 'services/rsvp_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'screens/staff_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AuthService.init();
  await PostService.loadFromPrefs();
  await RsvpService.loadFromPrefs();
  runApp(const NexusApp());
}

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (!AuthService.isLoggedIn) {
      home = const OnboardingScreen();
    } else if (AuthService.currentUser!.isStaff) {
      home = const StaffDashboardScreen();
    } else {
      home = const MainScreen();
    }
    return MaterialApp(
      title: 'NexusALU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: home,
    );
  }
}
