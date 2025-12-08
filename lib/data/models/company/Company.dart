class Company {
  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? website;
  final String? email;
  final String? phone;
  final String? size;
  final String? address;
  final String? city;
  final String? country;
  final String? industry;
  final int? foundedYear;
  final int? employeesCount;
  final bool? isVerified;
  final bool? isFeatured;

  final int? totalJobs;
  final int? activeJobs;
  final bool? isFollowing;
  final int? followersCount;
  final double? averageRating;

  final String? createdAt;

  Company({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.logo,
    this.coverImage,
    this.website,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.size,
    this.industry,
    this.foundedYear,
    this.employeesCount,
    this.isVerified,
    this.isFeatured,
    this.totalJobs,
    this.activeJobs,
    this.isFollowing,
    this.followersCount,
    this.averageRating,
    this.createdAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      logo: json['logo'],
      coverImage: json['cover_image'],
      website: json['website'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      size: json['size'],
      industry: json['industry'],
      foundedYear: json['founded_year'],
      employeesCount: json['employees_count'],
      isVerified: json['is_verified'],
      isFeatured: json['is_featured'],

      totalJobs: json['total_jobs'],
      activeJobs: json['active_jobs'],
      isFollowing: json['is_following'],
      followersCount: json['followers_count'],
      averageRating: json['average_rating'] != null
          ? (json['average_rating'] as num).toDouble()
          : null,

      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'logo': logo,
      'cover_image': coverImage,
      'website': website,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'size': size,
      'industry': industry,
      'founded_year': foundedYear,
      'employees_count': employeesCount,
      'is_verified': isVerified,
      'is_featured': isFeatured,
      'total_jobs': totalJobs,
      'active_jobs': activeJobs,
      'is_following': isFollowing,
      'followers_count': followersCount,
      'average_rating': averageRating,
      'created_at': createdAt,
    };
  }
}
