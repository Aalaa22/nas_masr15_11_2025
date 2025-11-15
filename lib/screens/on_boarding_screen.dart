// screens/Onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nas_masr_app/core/theming/colors.dart';
import 'package:nas_masr_app/core/theming/styles.dart';
import 'login_screen.dart'; // هنحتاجه للـ Navigation
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// نماذج للبيانات اللي هتظهر في الـ Carousel
class OnboardingPageModel {
  final String title;
  // صورة اختيارية لعرضها داخل الكارد
  final String? imagePath;
  const OnboardingPageModel(this.title, {this.imagePath});
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // دي البيانات الثابتة اللي هتظهر (تقدري تغيريها)
  final List<OnboardingPageModel> _pages = const [
    OnboardingPageModel('إعلانات وإرشادات'),
    OnboardingPageModel('مميزات منصتنا'),
    // يمكنك إضافة المزيد من صفحات الـ Onboarding
  ];

  // وصف كل صفحة (مفصول عن بيانات الكارد)
  final List<String> _descriptions = const [
    'منصة تجمع أقوى المتاجر والعروض والخدمات \nابدأ تجربتك الآن بكل سهولة وأمان',
    'منصة تجمع أقوى المتاجر والعروض والخدمات \nابدأ تجربتك الآن بكل سهولة وأمان',
     ];

  @override
  void initState() {
    super.initState();
    // Listener لمتابعة رقم الصفحة الحالية لتحديث النقط (Indicators)
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // الدالة الخاصة ببناء صفحة واحدة داخل الـ Onboarding
  Widget _buildPageContent(BuildContext context, int index, OnboardingPageModel page) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // البطاقة الرئيسية بشكل Card فلات بدون ظل
          SizedBox(
            height: 330.h,
            width: double.infinity,
            child: Card(
              elevation: 3, // فلات بدون ظل
              color: cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                children: [
                  SizedBox(height: 6.h),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: tt.titleLarge
                  ),
                  SizedBox(height: 12.h),
                  // صورة وهمية داخل الكارد لعرض الإرشادات
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F6),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE0E3E5)),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: ColorManager.primary_font_color.withOpacity(0.25),
                    ),
                  ),
                  Spacer(),
                  // المؤشرات داخل البطاقة (النقطة المفعلة طويلة وبرتقالية)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (dotIndex) {
                      final bool active = _currentPage == dotIndex;
                      return Container(
                        width: active ? 18.w : 8.w,
                        height: 8.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: active
                              ? cs.secondary
                              : cs.onSurface.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
              ),
            ),
          ),



          ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // اللوجو (Logo) في الجزء العلوي
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: .8,
                      child: Image.asset('assets/images/logo.png', height:150.h, fit: BoxFit.contain),
                    ),
                  ),

                  Text(
                    'لكل مصر',
                    textAlign: TextAlign.center,
                    style: tt.titleLarge?.copyWith(height: 1.0),
                  ),
                ],
              ),
            ),
             SizedBox(height: 12.h),
                
            // الـ PageView اللي هيمر عليها اليوزر
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPageContent(context, index, _pages[index]);
                },
              ),
            ),
            // النصوص الثابتة تحت الـ PageView (لا تتحرك مع السحب)
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'احصل على كل ما تحتاجه في مكان واحد',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.secondary,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                _descriptions[_currentPage],
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                  height: 1.6,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // زر "التالي"
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Center(
                child: SizedBox(
                  width: 334.w,
                  height: 48.h,
                child: ElevatedButton(
                onPressed: () async {
                  if (_currentPage < _pages.length - 1) {
                    // لو مش آخر صفحة، اعمل Move لـ next page
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                  } 
                  else {
                   // لو آخر صفحة: خزّن حالة الإتمام ثم انقل لصفحة الدخول
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboarding_done', true);
                    if (!mounted) return;
                    // استبدال Navigator بـ go_router
                    context.go('/login');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  elevation: 2,
                  shadowColor: cs.primary.withOpacity(0.4),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child:  Text(
                  'التالي',
                  style: tt.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ),
              ),
            ),
        )],
        ),
      ),
    );
  }
  
}