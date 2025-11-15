import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nas_masr_app/core/theming/colors.dart';
import 'package:nas_masr_app/widgets/custom_text_field.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:nas_masr_app/widgets/map_action_button.dart';
import 'package:nas_masr_app/widgets/map_round_icon_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final MapController _mapController = MapController();

  String agentCode = '5284600';
  String username = '';
  String phone = '01093925544';
  String password = '';
  String? delegateNumber;
  double? latitude;
  double? longitude;
  String _mapStyle = 'hot';
  String? _address;

  Future<void> _getCurrentLocation() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('خدمة الموقع غير مفعلة. قم بتفعيلها من الإعدادات.')),
          );
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفض إذن الموقع')),
          );
          return;
        }
      }
      if (permissionGranted == PermissionStatus.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('إذن الموقع مرفوض نهائياً، فعّله من الإعدادات.')),
        );
        return;
      }

      final data = await location.getLocation();
      setState(() {
        latitude = data.latitude;
        longitude = data.longitude;
      });
      try {
        if (latitude != null && longitude != null) {
          final placemarks = await geocoding.placemarkFromCoordinates(
            latitude!,
            longitude!,
            localeIdentifier: 'ar',
          );
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final parts = <String?>[
              p.street,
              p.subLocality,
              p.locality,
              p.administrativeArea,
              p.country,
            ]
                .where((s) => s != null && s!.trim().isNotEmpty)
                .cast<String>()
                .toList();
            setState(() {
              _address = parts.join('، ');
            });
          }
        }
      } catch (_) {}
      try {
        if (mounted && latitude != null && longitude != null) {
          _mapController.move(latlng.LatLng(latitude!, longitude!), 16);
        }
      } catch (_) {}
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديد الموقع بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تعذر تحديد الموقع: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: cs.onSurface,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          centerTitle: true,
          title: Text(
            'الملف الشخصي',
            style: tt.titleLarge,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                      CustomTextField(
                        labelText: 'كود المندوب',
                        initialValue: agentCode,
                        readOnly: true,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        labelText: 'اسم المستخدم*',
                        initialValue: username,
                        onChanged: (v) => username = v,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        labelText: 'رقم الهاتف',
                        keyboardType: TextInputType.phone,
                        initialValue: phone,
                        onChanged: (v) => phone = v,
                        textDirection: TextDirection.rtl,
                        suffix: Padding(
                          padding: EdgeInsetsDirectional.only(end: 6.w),
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم إرسال رمز التأكيد')),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: ColorManager.secondaryColor,
                              minimumSize: Size(0, 0),
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('تأكيد'),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        labelText: 'كلمة المرور',
                        isPassword: true,
                        onChanged: (v) => password = v,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        labelText: 'رقم المندوب',
                        isOptional: true,
                        hintText: 'XXXX',
                        initialValue: delegateNumber,
                        onChanged: (v) => delegateNumber = v,
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'الموقع*',
                          style: tt.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: cs.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _address ?? 'لم يتم التحديد بعد',
                          textAlign: TextAlign.right,
                          style: tt.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            color: cs.onSurface.withOpacity(0.65),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _mapWidget(context),
                      SizedBox(height: 8.h),
                  
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final valid = _formKey.currentState?.validate() ?? true;
                            if (valid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم حفظ التغييرات')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: const Text('حفظ'),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.onSurface,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: const Text('إلغاء'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  

  latlng.LatLng _center() {
    final defaultCairo = latlng.LatLng(30.0444, 31.2357);
    if (latitude == null || longitude == null) return defaultCairo;
    return latlng.LatLng(latitude!, longitude!);
  }

  Widget _mapWidget(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 220.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F6),
          border: Border.all(color: const Color(0xFFE0E3E5)),
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center(),
                initialZoom: 13,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: _mapStyle == 'hot'
                      ? 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
                      : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.nas_masr_app',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _center(),
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on,
                        color: ColorManager.secondaryColor,
                        size: 40.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Column(
                children: [
                  MapRoundIconButton(
                    icon: Icons.add,
                    onPressed: () {
                      _mapController.move(_center(), (_mapController.camera.zoom + 1).clamp(3, 19));
                    },
                  ),
                  SizedBox(height: 6.h),
                  MapRoundIconButton(
                    icon: Icons.remove,
                    onPressed: () {
                      _mapController.move(_center(), (_mapController.camera.zoom - 1).clamp(3, 19));
                    },
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              bottom: 8,
              start: 8,
              child: MapActionButton(
                label: 'تحديد موقعي',
                onTap: _getCurrentLocation,
                color: ColorManager.secondaryColor,
                textColor: Colors.white,
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('عادي'),
                    selected: _mapStyle == 'hot',
                    onSelected: (_) => setState(() => _mapStyle = 'hot'),
                  ),
                  SizedBox(width: 6.w),
                  ChoiceChip(
                    label: const Text('ملون'),
                    selected: _mapStyle == 'standard',
                    onSelected: (_) => setState(() => _mapStyle = 'standard'),
                    selectedColor: ColorManager.secondaryColor.withOpacity(.85),
                    labelStyle: const TextStyle(color: Colors.black),
                    disabledColor:const Color.fromARGB(255, 92, 89, 89)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}