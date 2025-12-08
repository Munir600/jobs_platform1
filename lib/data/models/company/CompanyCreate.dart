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
  final String? country;
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
    this.country,
    required this.size,
    required this.industry,
    this.foundedYear,
    this.employeesCount,
  });

  factory CompanyCreate.fromJson(Map<String, dynamic> json) {
    return CompanyCreate(
      name: json['name'],
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
    );
  }

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
