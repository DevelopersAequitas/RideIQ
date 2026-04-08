import 'package:flutter/material.dart';

import 'package:rideiq/views/home/select_location_screen.dart';

/// Home shell — shows the main rider “Select location” experience.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      child: const SelectLocationScreen(),
    );
  }
}
