import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura/core/common/app_images.dart';

import 'app_colors.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  final Widget child;
  final String? imgSrc;
  // final Color? backgroundColor;

  BackgroundScreen({
    super.key,
    required this.child,
    this.imgSrc = AppImages.authBackground, // Default background image
    // this.backgroundColor = AppColors.backgroundColor,              // Optional background color
  });

  @override
  ConsumerState<BackgroundScreen> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Conditionally render background color or image
        // if (widget.backgroundColor != null)
        //   Positioned.fill(
        //     child: Container(
        //       color: widget.backgroundColor, // Fill with the specified color
        //     ),
        //   ),
        if (widget.imgSrc != null)
          Positioned.fill(
            child: Image.asset(
              widget.imgSrc!, // Replace with the image path
              fit: BoxFit.cover,
            ),
          ),
        // Content on top of the background
        Positioned.fill(
          child: widget.child,
        ),
      ],
    );
  }
}
