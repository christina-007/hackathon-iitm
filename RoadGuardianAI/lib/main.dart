import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/emergency_contacts_screen.dart';
import 'screens/emergency_sos_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RoadGuardianApp());
}

class RoadGuardianApp extends StatelessWidget {
  const RoadGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoadGuardian AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
        EmergencySOSScreen.routeName: (context) => const EmergencySOSScreen(),
        EmergencyContactsScreen.routeName: (context) => const EmergencyContactsScreen(),
      },
    );
  }
}
