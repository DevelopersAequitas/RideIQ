import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:rideiq/features/auth/view/screens/permission_screen.dart';
import 'package:rideiq/features/auth/view/widgets/user_type_card.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/theme/app_colors.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class UserSelectionScreen extends ConsumerWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final notifier = ref.read(authViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    // Listen for errors
    ref.listen(authViewModelProvider.select((s) => s.errorMessage), (
      prev,
      next,
    ) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                l10n.what_brings_you_here,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontFamily: 'Figtree',
                ),
              ).animate().fade().slideX(begin: -0.1, end: 0),

              SizedBox(height: 32.h),

              UserTypeCard(
                title: l10n.im_a_passenger,
                subtitle: l10n.find_cheapest_ride_fares,
                imagePath: AppAssets.passengerPng,
                isSelected: state.userType == 'rider',
                onTap: () => notifier.updateUserType('rider'),
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),

              SizedBox(height: 20.h),

              UserTypeCard(
                title: l10n.im_a_driver,
                subtitle: l10n.compare_my_earnings,
                imagePath: AppAssets.driverPng,
                isSelected: state.userType == 'driver',
                onTap: () => notifier.updateUserType('driver'),
              ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),

              const Spacer(),

              PrimaryButton(
                text: l10n.continue_btn,
                isLoading: state.isLoading,
                onPressed: state.userType.isNotEmpty
                    ? () async {
                        await notifier.completeUserSelection();
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PermissionScreen(),
                            ),
                          );
                        }
                      }
                    : null,
              ).animate().fade(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
