class JobCategory {
  final int? id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final bool? isActive;
  final int? jobsCount;

  JobCategory({
    this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.isActive,
    this.jobsCount,
  });

  factory JobCategory.fromJson(Map<String, dynamic> json) {
    return JobCategory(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['is_active'],
      jobsCount: json['jobs_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'is_active': isActive,
      'jobs_count': jobsCount,
    };
  }
}
