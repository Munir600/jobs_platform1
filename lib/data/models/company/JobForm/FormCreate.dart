import 'FormQuestions.dart';

class FormCreate {
  final int? company;
  final String name;
  final String? description;
  final bool? isActive;
  final FormQuestions? questions;

  FormCreate({
    required this.company,
    required this.name,
     this.description,
    this.isActive,
    this.questions
  });

  factory FormCreate.fromJson(Map<String, dynamic> json) {
    return FormCreate(
        company: json['company'],
        name: json['name'],
        description: json['description'],
        isActive: json['is_active'],
        questions: json['questions'] != null ? FormQuestions.fromJson(json['questions']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'name': name,
      'description': description,
      'is_active': isActive,
      'questions': questions?.toJson()
    };
  }
}
