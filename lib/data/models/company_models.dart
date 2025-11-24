// lib/models/company_models.dart
class Company {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String? logo;
  final String? coverImage;
  final String? website;
  final String email;
  final String? phone;
  final String? address;
  final String city;
  final String country;
  final String size;
  final String industry;
  final int? foundedYear;
  final int? employeesCount;
  final bool isVerified;
  final bool isFeatured;
  final int totalJobs;
  final int activeJobs;
  final bool isFollowing;
  final int followersCount;
  final double averageRating;
  final DateTime createdAt;

  Company({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.logo,
    this.coverImage,
    this.website,
    required this.email,
    this.phone,
    this.address,
    required this.city,
    required this.country,
    required this.size,
    required this.industry,
    this.foundedYear,
    this.employeesCount,
    required this.isVerified,
    required this.isFeatured,
    required this.totalJobs,
    required this.activeJobs,
    required this.isFollowing,
    required this.followersCount,
    required this.averageRating,
    required this.createdAt,
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
      totalJobs: int.parse(json['total_jobs']),
      activeJobs: int.parse(json['active_jobs']),
      isFollowing: json['is_following'] == 'true',
      followersCount: int.parse(json['followers_count']),
      averageRating: double.parse(json['average_rating']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class CompanyCreate {
  final String name;
  final String description;
  final String? logo;
  final String? coverImage;
  final String? website;
  final String email;
  final String? phone;
  final String? address;
  final String city;
  final String country;
  final String size;
  final String industry;
  final int? foundedYear;
  final int? employeesCount;

  CompanyCreate({
    required this.name,
    required this.description,
    this.logo,
    this.coverImage,
    this.website,
    required this.email,
    this.phone,
    this.address,
    required this.city,
    required this.country,
    required this.size,
    required this.industry,
    this.foundedYear,
    this.employeesCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
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
    };
  }
}

class CompanyFollower {
  final int id;
  final Company company;
  final DateTime followedAt;

  CompanyFollower({
    required this.id,
    required this.company,
    required this.followedAt,
  });

  factory CompanyFollower.fromJson(Map<String, dynamic> json) {
    return CompanyFollower(
      id: json['id'],
      company: Company.fromJson(json['company']),
      followedAt: DateTime.parse(json['followed_at']),
    );
  }
}

class CompanyReview {
  final int id;
  final int rating;
  final String title;
  final String reviewText;
  final String? pros;
  final String? cons;
  final bool isCurrentEmployee;
  final String? jobTitle;
  final String reviewer;
  final String reviewerName;
  final DateTime createdAt;

  CompanyReview({
    required this.id,
    required this.rating,
    required this.title,
    required this.reviewText,
    this.pros,
    this.cons,
    required this.isCurrentEmployee,
    this.jobTitle,
    required this.reviewer,
    required this.reviewerName,
    required this.createdAt,
  });

  factory CompanyReview.fromJson(Map<String, dynamic> json) {
    return CompanyReview(
      id: json['id'],
      rating: json['rating'],
      title: json['title'],
      reviewText: json['review_text'],
      pros: json['pros'],
      cons: json['cons'],
      isCurrentEmployee: json['is_current_employee'],
      jobTitle: json['job_title'],
      reviewer: json['reviewer'],
      reviewerName: json['reviewer_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'title': title,
      'review_text': reviewText,
      'pros': pros,
      'cons': cons,
      'is_current_employee': isCurrentEmployee,
      'job_title': jobTitle,
    };
  }
}