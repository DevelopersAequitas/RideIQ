import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/core/constants/app_assets.dart';
import 'package:rideiq/core/providers/language_provider.dart';
import 'package:rideiq/features/profile/view/widgets/settings_widgets.dart';
import 'package:rideiq/features/profile/view/widgets/delete_account_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rideiq/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _showLanguageBottomSheet(
    BuildContext context,
    String currentLang,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.select_language,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Figtree',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 24.h),
              ListTile(
                title: Text(l10n.english),
                trailing:
                    currentLang == 'en'
                        ? const Icon(Icons.check, color: Color(0xFF1E74E9))
                        : null,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.spanish),
                trailing:
                    currentLang == 'es'
                        ? const Icon(Icons.check, color: Color(0xFF1E74E9))
                        : null,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage('es');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context)!;

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
          l10n.settings,
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
          children: [
            SizedBox(height: 10.h),

            // Notifications Toggle
            SettingSwitchItem(
              assetPath: AppAssets.bellSvg,
              label: l10n.notifications,
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
            ),

            const Divider(color: Color(0xFFF2F2F2)),

            // Language Selection
            SettingDropdownItem(
              assetPath: AppAssets.translateSvg,
              label: l10n.language,
              value: lang == 'en' ? l10n.english : l10n.spanish,
              onTap: () => _showLanguageBottomSheet(context, lang),
            ),

            // Default Ride Selection
            SettingDropdownItem(
              assetPath: AppAssets.carProfileSettingSvg,
              label: l10n.default_ride,
              value: "Comfort",
              onTap: () {},
            ),

            const Divider(color: Color(0xFFF2F2F2)),

            // Delete Account
            SettingActionItem(
              assetPath: AppAssets.trashSvg,
              label: l10n.delete_account,
              onTap: () => DeleteAccountDialog.show(context, ref),
            ),
          ]
              .animate(interval: 50.ms)
              .fadeIn(duration: 400.ms)
              .slideY(
                begin: 0.05,
                end: 0,
                curve: Curves.easeOutQuad,
              ),
        ),
      ),
    );
  }
}
