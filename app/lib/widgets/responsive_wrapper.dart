import 'package:flutter/material.dart';

/// Wrapper that constrains content to mobile width on desktop
/// Makes the app look consistent with Figma design
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    Key? key,
    required this.child,
    this.maxWidth = 600, // Max mobile width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxWidth,
        height: double.infinity,
        child: child,
      ),
    );
  }
}
