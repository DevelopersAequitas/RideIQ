import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/shared/widgets/app_text_field.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/features/profile/view/screens/link_verification_screen.dart';
import 'package:rideiq/features/profile/viewmodel/link_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:country_picker/country_picker.dart';

class LinkPlatformScreen extends ConsumerWidget {
  final String platformName;
  final bool isDriverMode;

  const LinkPlatformScreen({
    super.key,
    required this.platformName,
    required this.isDriverMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(linkViewModelProvider);
    final notifier = ref.read(linkViewModelProvider.notifier);

    final isUber = platformName.toLowerCase() == "uber";
    final logoAsset = isUber ? AppAssets.uberLogoPng : AppAssets.lyftLogoPng;

    final isValid = isDriverMode
        ? state.isDriverPlatformValid
        : state.isPlatformValid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Link Platform",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),

            // Platform Branding
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.sp),
                  child: Container(
                    height: 54.w,
                    width: 54.w,
                    color: isUber ? Colors.black : const Color(0xFFFF00BF),
                    child: Image.asset(logoAsset, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(width: 20.w),
                Text(
                  platformName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    fontFamily: 'Figtree',
                  ),
                ),
              ],
            ).animate().fade().slideX(begin: -0.1),

            SizedBox(height: 40.h),

            // Input Fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Country Code Picker
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        notifier.updateCountryCode("+${country.phoneCode}");
                      },
                      countryListTheme: CountryListThemeData(
                        borderRadius: BorderRadius.circular(20.w),
                        inputDecoration: InputDecoration(
                          hintText: 'Search country',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.w),
                            borderSide: const BorderSide(
                              color: Color(0xFFF2F2F2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16.w),
                      border: Border.all(color: const Color(0xFFF2F2F2)),
                    ),
                    child: Center(
                      child: Text(
                        state.countryCode,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Figtree',
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Phone Input
                Expanded(
                  child: AppTextField(
                    label: "Phone",
                    onChanged: notifier.updatePhone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ).animate().fade(delay: 100.ms).slideY(begin: 0.1),

            if (isDriverMode) ...[
              SizedBox(height: 20.h),
              AppTextField(
                label: "Driver's license number",
                onChanged: notifier.updateLicense,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
            ],

            SizedBox(height: 40.h),

            // Continue Button
            PrimaryButton(
              text: "Continue",
              isLoading: state.isLoading,
              onPressed: isValid
                  ? () {
                      notifier.handleContinue().then((success) {
                        if (success && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LinkVerificationScreen(
                                platformName: platformName,
                                phoneNumber: state.fullPhone,
                                isDriverMode: isDriverMode,
                              ),
                            ),
                          );
                        }
                      });
                    }
                  : null,
            ).animate().fade(delay: 300.ms).scale(),
          ],
        ),
      ),
    );
  }
}
