import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nas_masr_app/core/theming/colors.dart';
import 'package:nas_masr_app/screens/home.dart';
import 'package:nas_masr_app/screens/setting.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNav({required this.currentIndex});

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  int? _pendingNavIndex;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: cs.surface,
      currentIndex: widget.currentIndex,
      showUnselectedLabels: true,
      selectedItemColor: cs.secondary,
      unselectedItemColor: cs.onSurface,
      onTap: (index) async {
        switch (index) {
          case 0:
          context.go('/home');
            break;
          case 1:
           // context.push('/favorite');
            break;
          case 2:
            {
             // context.push('/favorite');
            }
          case 3:
            {
            //  context.push('/favorite');
            }

          case 4:
           context.go('/settings');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 26.w,
            height: 26.h,
            child: SvgPicture.asset(
              "assets/svg/home.svg",
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                widget.currentIndex == 0
                    ? cs.secondary // لون المختار
                    : cs.onSurface, // لون غير المختار
                BlendMode.srcIn,
              ),
            ),
          ),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 26.w,
            height: 26.h,
            child: SvgPicture.asset(
              "assets/svg/ads.svg",
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                widget.currentIndex == 3
                    ? cs.secondary // لون المختار
                    : cs.onSurface, // لون غير المختار
                BlendMode.srcIn,
              ),
            ),
          ),
           label: "إعلاناتي",

        ),
        BottomNavigationBarItem(
          icon: Center(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.primary,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white, // لون الزائد
                  size: 18,
                ),
              ),
            ),
          ),
          label: "نشر",
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            width: 26.w,
            height: 26.h,
            child: SvgPicture.asset(
              "assets/svg/chat.svg",
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                widget.currentIndex == 3
                    ? cs.secondary // لون المختار
                    : cs.onSurface, // لون غير المختار
                BlendMode.srcIn,
              ),
            ),
          ),
          label:" رسائل",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.gear),
          label:" رسائل",
        ),
      ],
    );
  }
}
