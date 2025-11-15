// widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:nas_masr_app/core/theming/colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool isOptional;
  final Function(String)? onChanged;
  final String? hintText;
  final bool showTopLabel;
  final bool filled;
  final Color? fillColor;
  final TextDirection? textDirection;
  final bool readOnly;
  final Widget? suffix;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.isPassword = false,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.isOptional = false,
    this.onChanged,
    this.hintText,
    this.showTopLabel = true,
    this.filled = true,
    this.fillColor,
    this.textDirection,
    this.readOnly = false,
    this.suffix,
    this.textAlign,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    const inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 1), width: 1.0),
    );

    final String fullLabel = isOptional ? '$labelText (اختياري)' : labelText;
    final Color effectiveFill = fillColor ?? Color.fromRGBO(255, 255, 255, 1);

    final Widget field = TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: isPassword,
      readOnly: readOnly,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 16),
      textAlign: textAlign ?? TextAlign.right,
      decoration: InputDecoration(
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        filled: filled,
        fillColor: effectiveFill,
        // إذا كان الحقل كلمة مرور، نلغي التلميح ونضيف أيقونة بادئة
        hintText: isPassword ? null : (hintText ?? (isOptional ? 'XXXX' : null)),
        prefixIcon: isPassword
            ? Icon(Icons.password_outlined, color: Color.fromRGBO(118, 129, 130, 1))
            : null,
        suffix: suffix,
        hintStyle: TextStyle(color: Color.fromRGBO(118, 129, 130, 1)),
      ),
    );

    // إضافة ظل للحقل بقيمة 2 ولون rgba(0,0,0,0.25)
    final Widget fieldWithShadow = Material(
      elevation: 4.0,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.25).withOpacity(.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: field,
    );

    final Widget fieldWithDirection = Directionality(
      textDirection: textDirection ?? Directionality.of(context),
      child: fieldWithShadow,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: showTopLabel
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                isOptional
                    ? Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: labelText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: ColorManager.primary_font_color,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' (اختياري)',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(1, 22, 24, 0.45),
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      )
                    : Text(
                        fullLabel,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorManager.primary_font_color,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                const SizedBox(height: 2),
                fieldWithDirection,
              ],
            )
          : fieldWithDirection,
    );
  }
}
