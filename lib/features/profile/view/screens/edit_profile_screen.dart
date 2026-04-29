import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rideiq/core/utils/size_config.dart';
import 'package:rideiq/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:rideiq/l10n/app_localizations.dart';
import 'package:rideiq/shared/widgets/primary_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final profileState = ref.read(profileViewModelProvider);
    _firstNameController = TextEditingController(
      text: profileState.userData?['first_name'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: profileState.userData?['last_name'] ?? '',
    );
    _emailController = TextEditingController(
      text: profileState.userData?['email'] ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      final success = await ref
          .read(profileViewModelProvider.notifier)
          .updateProfile(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        final error = ref.read(profileViewModelProvider).errorMessage;
        if (error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
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
          l10n.edit_profile,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Figtree',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40.w,
                  backgroundColor: const Color(0xFF1E74E9),
                  child: Text(
                    profileState.initials,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Figtree',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                l10n.first_name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: l10n.enter_first_name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? l10n.required_field : null,
              ),
              SizedBox(height: 20.h),
              Text(
                l10n.last_name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: l10n.enter_last_name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? l10n.required_field : null,
              ),
              SizedBox(height: 20.h),
              Text(
                l10n.email,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: l10n.enter_email,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Color(0xFFF2F2F2)),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n.required_field;
                  if (!val.contains('@')) return l10n.invalid_email;
                  return null;
                },
              ),
              SizedBox(height: 40.h),
              PrimaryButton(
                text: l10n.save_changes,
                isLoading: profileState.isLoading,
                onPressed: _updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
