// screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nas_masr_app/core/theming/colors.dart';
import 'package:nas_masr_app/core/theming/styles.dart';
import 'package:nas_masr_app/screens/home.dart';
import '../widgets/custom_text_field.dart';
import 'terms_screen.dart';
import 'privacy_policy_screen.dart';
import 'package:provider/provider.dart';
import 'package:nas_masr_app/core/data/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _phone = '';
  String _password = '';
  bool _loading = false;

  Future<void> _submit() async {
    final phone = _phone.trim();
    final pass = _password;
    // أولاً: تحقق من الحقول الفارغة برسالة مناسبة
    if (phone.isEmpty || pass.isEmpty) {
      String msg;
      if (phone.isEmpty && pass.isEmpty) {
        msg = 'من فضلك أدخل رقم الهاتف وكلمة المرور';
      } else if (phone.isEmpty) {
        msg = 'من فضلك أدخل رقم الهاتف';
      } else {
        msg = 'من فضلك أدخل كلمة المرور';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    // تحقق مبسط: يبدأ بـ 01 وطوله 11 رقم وكلها أرقام
    if (!(phone.length == 11 && phone.startsWith('01') && int.tryParse(phone) != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الهاتف غير صحيح')),
      );
      return;
    }
    // تحقق بسيط لرقم مصري: يبدأ بـ 01 وطوله 11 رقم
    
    final phoneValid = RegExp(r'^01[0-9]{9}$').hasMatch(phone) || RegExp(r'^01[0-9]{9}$').hasMatch(phone);
    if (!phoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رقم الهاتف غير صحيح')),
      );
      return;
    }
    
    if (pass.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور غير صحيحة')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final auth = context.read<AuthProvider>();
      final token = await auth.register(phone: phone, password: pass);
      if (token != null && token.isNotEmpty) {
        if (!mounted) return;
        // استبدال Navigator بـ go_router
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final Color bg = const Color(0xFFF1F1F1);
    return Scaffold(
      // backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Column(
                    children: [
                      ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: .8,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 150.h,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.image_not_supported_outlined,
                              size: 48.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
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
                Text(
                  'تسجيل دخول',
                  textAlign: TextAlign.center,
                  style: tt.titleLarge?.copyWith(fontSize: 22.sp, color: cs.onSurface),
                ),
                SizedBox(height: 1.h),
                Text(
                  'مرحباً بعودتك مجدداً',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: cs.primary, fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  labelText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => _phone = v,
                ),
                CustomTextField(
                  labelText: 'كلمة المرور',
                  isPassword: true,
                  hintText: '***',
                  onChanged: (v) => _password = v,
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: tt.bodyMedium?.copyWith(
                            color: cs.onSurface,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  labelText: 'كود المندوب',
                  isOptional: true,
                  hintText: 'XXXX',
                  showTopLabel: true,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    elevation: 2,
                    shadowColor: cs.primary.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    _loading ? 'جاري التحميل...' : 'تسجيل الدخول',
                    style: tt.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        SafeArea(
          minimum: EdgeInsets.only(bottom: 16.h),
          child: Material(
            type: MaterialType.transparency,
            elevation: 0,
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: 'بالتسجيل، أنت توافق\n',
                  style: tt.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      color: cs.onSurface,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'على ',
                      style: tt.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: 'الشروط والأحكام',
                      style: tt.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: cs.secondary,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/terms');
                        },
                    ),
                    TextSpan(
                      text: ' و ',
                      style: tt.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: cs.onSurface,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: tt.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          color: cs.secondary,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push('/privacy');
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}