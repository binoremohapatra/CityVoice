import 'package:flutter/material.dart';

import '../../../widgets/custom_bottom_bar.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}