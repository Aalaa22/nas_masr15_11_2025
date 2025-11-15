import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapRoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? background;
  final Color? iconColor;

  const MapRoundIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.background,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = background ?? Theme.of(context).colorScheme.surface;
    final ic = iconColor ?? Theme.of(context).colorScheme.onSurface;
    return Material(
      color: bg,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: Icon(icon, color: ic, size: 20.sp),
        ),
      ),
    );
  }
}