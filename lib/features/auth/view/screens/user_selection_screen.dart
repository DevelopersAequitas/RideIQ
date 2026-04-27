import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/screens/permission_screen.dart';
import 'package:rideiq/features/auth/view/widgets/user_type_card.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserSelectionScreen extends ConsumerWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Match the light background in Figma
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "What brings you here?",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Figtree',
                ),
              ).animate().fade().slideX(begin: -0.1, end: 0),
              
              SizedBox(height: 32.h),
              
              UserTypeCard(
                title: "I'm a Passenger",
                subtitle: "Find cheapest ride fares",
                imagePath: AppAssets.passengerPng,
                isSelected: state.userType == 'passenger',
                onTap: () => notifier.updateUserType('passenger'),
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
              
              SizedBox(height: 20.h),
              
              UserTypeCard(
                title: "I'm a Driver",
                subtitle: "Compare my earnings",
                imagePath: AppAssets.driverPng,
                isSelected: state.userType == 'driver',
                onTap: () => notifier.updateUserType('driver'),
              ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),
              
              const Spacer(),
              
              PrimaryButton(
                text: "Continue",
                onPressed: () {
                  notifier.completeUserSelection(); // Trigger save in background
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PermissionScreen()),
                  );
                },
              ).animate().fade(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
