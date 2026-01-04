
enum DocumentType {
  certificate,
  training,
  project,
  recommendation,
  award,
  other;

  String get value => name;
}

enum DocumentVisibility {
  public_,
  private_,
  employersOnly;

  String get value {
    switch (this) {
      case DocumentVisibility.public_:
        return 'public';
      case DocumentVisibility.private_:
        return 'private';
      case DocumentVisibility.employersOnly:
        return 'employers_only';
    }
  }

  static DocumentVisibility fromString(String? value) {
    switch (value) {
      case 'public':
        return DocumentVisibility.public_;
      case 'private':
        return DocumentVisibility.private_;
      case 'employers_only':
        return DocumentVisibility.employersOnly;
      default:
        return DocumentVisibility.public_;
    }
  }
}

// class AppEnums {
//   static const Map<String, String> documentType = {
//     'certificate': 'شهادة أكاديمية',
//     'training': 'شهادة دورة تدريبية',
//     'project': 'مشروع',
//     'recommendation': 'خطاب توصية',
//     'award': 'جائزة أو تكريم',
//     'other': 'أخرى',
//   };
//
//   static const Map<String, String> visibility = {
//     'public': 'عام',
//     'private': 'خاص',
//     'employers_only': 'أصحاب العمل فقط',
//   };
// }
