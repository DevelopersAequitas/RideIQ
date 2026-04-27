import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rideiq/features/onboarding/view/screens/splash_screen.dart';
import 'package:rideiq/features/auth/view/screens/user_selection_screen.dart';
import 'package:rideiq/features/auth/view/screens/permission_screen.dart';
import 'package:rideiq/features/paywall/view/screens/paywall_screen.dart';
import 'package:rideiq/features/home/view/screens/main_dashboard_screen.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final initialStep = await LocalService.getAuthStep();

  runApp(
    ProviderScope(
      child: MyApp(
        initialStep: initialStep,
      ), // Force null to start from Splash Screen for testing
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initialStep;
  const MyApp({super.key, this.initialStep});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideIQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Figtree',
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          SizeConfig.init(context);
          return _getInitialScreen();
        },
      ),
    );
  }

  Widget _getInitialScreen() {
    switch (initialStep) {
      case AuthSteps.userType:
        return const UserSelectionScreen();
      case AuthSteps.permissions:
        return const PermissionScreen();
      case AuthSteps.paywall:
        return const PaywallScreen();
      case AuthSteps.home:
        return const MainDashboardScreen();
      default:
        return const SplashScreen();
    }
  }
}
