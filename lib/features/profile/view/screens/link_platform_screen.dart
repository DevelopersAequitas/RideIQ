import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/services/local_service.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/shared/widgets/app_text_field.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';
import 'package:rideiq/features/profile/view/screens/link_verification_screen.dart';
import 'package:rideiq/features/profile/viewmodel/link_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rideiq/l10n/app_localizations.dart';
import 'package:rideiq/features/truv/view/screens/driver_verification_screen.dart';
import 'package:rideiq/features/truv/viewmodel/truv_viewmodel.dart'; 



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
    final l10n = AppLocalizations.of(context)!;

    final String logoAsset;
    if (platformName.toLowerCase() == "uber") {
      logoAsset = AppAssets.uberLogoPng;
    } else if (platformName.toLowerCase() == "lyft") {
      logoAsset = AppAssets.lyftLogoPng;
    } else {
      logoAsset = AppAssets.ayroLogoPng;
    }
    final isUber = platformName.toLowerCase() == "uber" || platformName.toLowerCase() == "ayro";

    final isUberFlow = platformName.toLowerCase() == "uber";
    final isValid = isUberFlow 
        ? state.isUberValid 
        : (isDriverMode ? state.isDriverPlatformValid : state.isPlatformValid);

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
          l10n.link_platform,
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
            if (platformName.toLowerCase() == "uber") ...[
              AppTextField(
                label: l10n.email_or_phone, // Need to make sure this exists in L10N
                onChanged: notifier.updateEmail,
                keyboardType: TextInputType.emailAddress,
              ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
              SizedBox(height: 16.h),
              AppTextField(
                label: l10n.password,
                onChanged: notifier.updatePassword,
                obscureText: true,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
            ] else ...[
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
                            hintText: l10n.search_country,
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
                      label: l10n.phone,
                      onChanged: notifier.updatePhone,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
              if (isDriverMode) ...[
                SizedBox(height: 16.h),
                AppTextField(
                  label: l10n.drivers_license_number,
                  onChanged: notifier.updateLicense,
                ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
              ],
            ],

            SizedBox(height: 40.h),

            // Continue Button
            PrimaryButton(
              text: l10n.continue_btn,
              isLoading: state.isLoading || ref.watch(truvViewModelProvider).isLoading,

              onPressed: isValid

                  ? () {
                      notifier.handleContinue().then((success) async {
                        if (success && context.mounted) {
                          if (isDriverMode) {
                            // Save driver details
                            await LocalService.setDriverDetails(
                              phone: state.fullPhone,
                              license: state.license,
                            );


                            final truvNotifier = ref.read(truvViewModelProvider.notifier);
                            final bridgeToken = await truvNotifier.createBridgeToken();
                            
                            if (bridgeToken != null && context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DriverVerificationScreen(
                                    platformName: platformName,
                                  ),
                                ),
                              );
                            }
                          } else {
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

