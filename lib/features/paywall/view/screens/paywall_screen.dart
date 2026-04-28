import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/paywall/view/widgets/benefit_row.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/features/paywall/viewmodel/paywall_viewmodel.dart';
import 'package:rideiq/features/paywall/view/widgets/paywall_header.dart';
import 'package:rideiq/features/paywall/view/widgets/billing_toggle.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:rideiq/features/home/view/screens/main_dashboard_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paywallViewModelProvider);
    final notifier = ref.read(paywallViewModelProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    const double cardHeight = 100.0; // Same base as header for alignment

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Section (Gradient + Wave + Floating Card)
            const PaywallHeader(),

            // 3. Spacing for the overlapping card
            SizedBox(height: (cardHeight.h / 2) + 30.h),

            // 4. Billing Info
            Text(
              l10n.paywall_billed_after_trial,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontFamily: 'Figtree',
              ),
            ),
            SizedBox(height: 20.h),

            // Toggle Selector
            BillingToggle(
              isMonthly: state.isMonthly,
              onToggle: notifier.setMonthly,
            ),

            SizedBox(height: 30.h),

            // Price Section
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: state.isMonthly ? "\$9.99" : "\$79.99",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  TextSpan(
                    text: state.isMonthly ? l10n.paywall_month : l10n.paywall_year,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ],
              ),
            ).animate(key: ValueKey(state.isMonthly)).flipV(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
              child: const Divider(color: Colors.black12),
            ),

            // Benefits Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paywall_benefits,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BenefitRow(text: l10n.paywall_benefit_1),
                  BenefitRow(
                    text: l10n.paywall_benefit_2,
                  ),
                  BenefitRow(
                    text: l10n.paywall_benefit_3,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Start Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: PrimaryButton(
                text: l10n.paywall_start_trial,
                onPressed: () async {
                  await LocalService.setAuthStep(AuthSteps.home);
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainDashboardScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

