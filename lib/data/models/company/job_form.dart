class JobForm {
  final int? id;
  final int? company;
  final String? name;
  final String? description;
  final bool? isActive;
  final List<FormQuestion>? questions;
  final int? questionsCount;
  final String? createdAt;

  JobForm({
    this.id,
    this.company,
    this.name,
    this.description,
    this.isActive,
    this.questions,
    this.questionsCount,
    this.createdAt,
  });

  factory JobForm.fromJson(Map<String, dynamic> json) {
    return JobForm(
      id: json['id'],
      company: json['company'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'],
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((i) => FormQuestion.fromJson(i))
              .toList()
          : null,
      questionsCount: json['questions_count'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'name': name,
      'description': description,
      'is_active': isActive,
      'questions': questions?.map((e) => e.toJson()).toList(),
      'questions_count': questionsCount,
      'created_at': createdAt,
    };
  }
}

class FormQuestion {
  final int? id;
  final String? label;
  final String? helpText;
  final String? questionType;
  final bool? required;
  final String? options;
  final int? order;

  FormQuestion({
    this.id,
    this.label,
    this.helpText,
    this.questionType,
    this.required,
    this.options,
    this.order,
  });

  factory FormQuestion.fromJson(Map<String, dynamic> json) {
    return FormQuestion(
      id: json['id'],
      label: json['label'],
      helpText: json['help_text'],
      questionType: json['question_type'],
      required: json['required'],
      options: json['options'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'help_text': helpText,
      'question_type': questionType,
      'required': required,
      'options': options,
      'order': order,
    };
  }
}
