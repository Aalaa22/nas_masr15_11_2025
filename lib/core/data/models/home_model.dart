class HomeModel {
  final String? bannerUrl;
  final String? supportNumber;

  const HomeModel({this.bannerUrl, this.supportNumber});

  /// ينشئ موديل من خريطة الاستجابة، ويقوم بإصلاح امتداد الصورة ودمج `baseUrl` عند الحاجة
  factory HomeModel.fromMap(
    Map<String, dynamic> map, {
    required String baseUrl,
  }) {
    String? raw = map['panner_image']?.toString();
    if (raw != null && raw.isNotEmpty) {
      // إصلاح الامتداد الخاطئ .bng إلى .png
      raw = raw.replaceAll('.bng', '.png');
      // لو الرابط نسبي، نركبه على الـ baseUrl
      if (!raw.startsWith('http')) {
        if (!raw.startsWith('/')) raw = '/$raw';
        raw = '$baseUrl$raw';
      }
    }

    final supportNumber = map['support_number']?.toString();

    return HomeModel(
      bannerUrl: raw,
      supportNumber: supportNumber,
    );
  }

  /// بعض الـ APIs ترجع قائمة بإعدادات النظام؛ نأخذ أول عنصر
  factory HomeModel.fromApiList(
    List<dynamic> data, {
    required String baseUrl,
  }) {
    if (data.isNotEmpty && data.first is Map<String, dynamic>) {
      return HomeModel.fromMap(
        data.first as Map<String, dynamic>,
        baseUrl: baseUrl,
      );
    }
    return const HomeModel();
  }
}