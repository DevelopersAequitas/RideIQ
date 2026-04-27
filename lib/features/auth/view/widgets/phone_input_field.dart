import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:rideiq/core/utils/size_config.dart';

class PhoneInputField extends StatelessWidget {
  final String countryCode;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onCountryChanged;

  const PhoneInputField({
    super.key,
    required this.countryCode,
    required this.onPhoneChanged,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 64.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.w),
            borderRadius: BorderRadius.circular(12.w),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              // Clickable Country Picker
              InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      onCountryChanged('+${country.phoneCode}');
                    },
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                        topRight: Radius.circular(20.w),
                      ),
                      inputDecoration: InputDecoration(
                        hintText: 'Search country',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      countryCode,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
              
              SizedBox(width: 8.w),
              Container(
                height: 24.h,
                width: 1.w,
                color: const Color(0xFFE0E0E0),
              ),
              SizedBox(width: 12.w),
              
              // Phone Input
              Expanded(
                child: TextField(
                  onChanged: onPhoneChanged,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "0000 0000 00",
                    hintStyle: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 16.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Label on Border
        Positioned(
          left: 12.w,
          top: -8.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            color: Colors.white,
            child: Text(
              "Phone",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
