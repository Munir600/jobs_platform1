import 'FormQuestions.dart';

class FormDetail {
  final int id;
  final int? company;
  final String name;
  final String? description;
  final bool? isActive;
  final FormQuestions? questions;
  final int questionsCount;
  final String? createdAt;

  FormDetail({
    required this.id,
    required this.company,
    required this.name,
    this.description,
    this.isActive,
    this.questions,
    required this.questionsCount,
    this.createdAt
  });

  factory FormDetail.fromJson(Map<String, dynamic> json) {
    return FormDetail(
      id: json['id'],
      company: json['company'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      questions: json['questions'] != null ? FormQuestions.fromJson(json['questions']) : null,
      questionsCount: json['questions_count'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'company': company,
      'name': name,
      'description': description,
      'is_active': isActive,
      'questions': questions?.toJson(),
      'questions_count' : questionsCount,
      'created_at' : createdAt,
    };
  }
}
