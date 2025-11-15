import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// Removed direct ColorManager imports in favor of Theme references
import 'package:nas_masr_app/core/data/providers/home_provider.dart';
import 'package:nas_masr_app/widgets/category_card.dart';
import 'package:nas_masr_app/widgets/custom_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل بيانات الصفحة الرئيسية
    Future.microtask(() => context.read<HomeProvider>().loadHome());
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //backgroundColor: Colors.white,
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // محتوى بمسافات جانبية
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopRow(),
                      //SizedBox(height: 8.h),
                      _SearchBar(),
                    ],
                  ),
                ),
                // البانر بعرض الصفحة كامل بدون هوامش جانبية
                SizedBox(height: 4.h),
                _BannerSection(bannerUrl: home.bannerUrl, loading: home.loading),
                SizedBox(height: 12.h),
                // بقية المحتوى مع هوامش جانبية
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HintContainer(),
                      SizedBox(height: 12.h),
                      if (home.error != null) _ErrorBox(message: home.error!),
                      _CategoriesGrid( loading: home.loading, categories: home.categories),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        // borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(color: const Color(0xFFE4E7EB)),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 80.h,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              'لكل مصر',
              style: tt.titleLarge?.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_rounded, color: cs.onSurface, size: 25.sp),
            tooltip: 'المفضلة',
          ),

          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_rounded, color: cs.onSurface, size: 30.sp),
            tooltip: 'المفضلة',
          )
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final inputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ).copyWith(
      borderSide: BorderSide(color: cs.surface, width: 1.0),
    );

    final Widget field = TextField(
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: cs.primary, width: 2.0),
        ),
        filled: true,
        fillColor: cs.surface,
        hintText: 'ابحث عن خدمة أو إعلان......؟',
        prefixIcon: Icon(Icons.search, color: cs.onSurface.withOpacity(0.45)),
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.45)),
      ),
    );

    return Material(
      elevation: 8.0,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.25).withOpacity(.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: field,
    );
  }
}

class _BannerSection extends StatelessWidget {
  final String? bannerUrl;
  final bool loading;
  const _BannerSection({required this.bannerUrl, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12.r),
      //   boxShadow: [
      //     BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
      //   ],
      // ),
      child: AspectRatio(
        aspectRatio: 16 / 6,
        child: Builder(
          builder: (context) {
            if (loading && (bannerUrl == null || bannerUrl!.isEmpty)) {
              return Container(color: const Color(0xFFF0F2F5));
            }
            if (bannerUrl == null || bannerUrl!.isEmpty) {
              return Container(
                color: const Color(0xFFF0F2F5),
                child: Center(
                  child: Text(
                    'لا توجد صورة متاحة',
                    style: TextStyle(fontSize: 13.sp, color: const Color(0xFF8A949B)),
                  ),
                ),
              );
            }
            return Image.network(
              bannerUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFF0F2F5),
                child: Center(
                  child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade400, size: 32.sp),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HintContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          'للاشتراك وسداد الباقات اضغط هنا',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            color: cs.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFEA),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFC7B8)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: cs.secondary, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12.sp,
                fontFamily: 'Tajawal',
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
 // final String categoriesSectionTitle;
  final bool loading;
  final List<dynamic> categories;
  const _CategoriesGrid({
  //  required this.categoriesSectionTitle,
    required this.loading,
    required this.categories,
  });

  int _columnsForWidth(double w) {
    // مطلوب إظهار 4 كروت في الصف دائمًا
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = _columnsForWidth(width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // أزيل عنوان الأقسام ليختفي من الصفحة
        if (loading && categories.isEmpty)
          GridView.builder(
            itemCount: cols * 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              // قلّل العرض وزد الارتفاع
              childAspectRatio: 0.60,
            ),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          )
        else
          GridView.builder(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              // أطوّل الكارد وأقلل عرضه لزيادة مساحة الصورة
              childAspectRatio: 0.70,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryCard(category: cat);
            },
          ),
      ],
    );
  }
}