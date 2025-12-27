// To parse this JSON data, do
//
//     final companiesStatistics = companiesStatisticsFromJson(jsonString);

import 'dart:convert';

CompaniesStatistics companiesStatisticsFromJson(String str) => CompaniesStatistics.fromJson(json.decode(str));

String companiesStatisticsToJson(CompaniesStatistics data) => json.encode(data.toJson());

class CompaniesStatistics {
  final int? totalCompanies;
  final int? verifiedCompanies;
  final int? featuredCompanies;
  final List<CompaniesBySize>? companiesBySize;
  final List<CompaniesByIndustry>? companiesByIndustry;
  final List<CompaniesByCity>? companiesByCity;

  CompaniesStatistics({
    this.totalCompanies,
    this.verifiedCompanies,
    this.featuredCompanies,
    this.companiesBySize,
    this.companiesByIndustry,
    this.companiesByCity,
  });

  factory CompaniesStatistics.fromJson(Map<String, dynamic> json) => CompaniesStatistics(
    totalCompanies: json["total_companies"],
    verifiedCompanies: json["verified_companies"],
    featuredCompanies: json["featured_companies"],
    companiesBySize: json["companies_by_size"] == null ? [] : List<CompaniesBySize>.from(json["companies_by_size"]!.map((x) => CompaniesBySize.fromJson(x))),
    companiesByIndustry: json["companies_by_industry"] == null ? [] : List<CompaniesByIndustry>.from(json["companies_by_industry"]!.map((x) => CompaniesByIndustry.fromJson(x))),
    companiesByCity: json["companies_by_city"] == null ? [] : List<CompaniesByCity>.from(json["companies_by_city"]!.map((x) => CompaniesByCity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_companies": totalCompanies,
    "verified_companies": verifiedCompanies,
    "featured_companies": featuredCompanies,
    "companies_by_size": companiesBySize == null ? [] : List<dynamic>.from(companiesBySize!.map((x) => x.toJson())),
    "companies_by_industry": companiesByIndustry == null ? [] : List<dynamic>.from(companiesByIndustry!.map((x) => x.toJson())),
    "companies_by_city": companiesByCity == null ? [] : List<dynamic>.from(companiesByCity!.map((x) => x.toJson())),
  };
}

class CompaniesByCity {
  final String? city;
  final int? count;

  CompaniesByCity({
    this.city,
    this.count,
  });

  factory CompaniesByCity.fromJson(Map<String, dynamic> json) => CompaniesByCity(
    city: json["city"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "count": count,
  };
}

class CompaniesByIndustry {
  final String? industry;
  final int? count;

  CompaniesByIndustry({
    this.industry,
    this.count,
  });

  factory CompaniesByIndustry.fromJson(Map<String, dynamic> json) => CompaniesByIndustry(
    industry: json["industry"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "industry": industry,
    "count": count,
  };
}

class CompaniesBySize {
  final String? size;
  final int? count;

  CompaniesBySize({
    this.size,
    this.count,
  });

  factory CompaniesBySize.fromJson(Map<String, dynamic> json) => CompaniesBySize(
    size: json["size"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "size": size,
    "count": count,
  };
}
