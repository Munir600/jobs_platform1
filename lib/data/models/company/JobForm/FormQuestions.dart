class FormQuestions {
  final int? id;
  final String label;
  final String? helpText;
  final String? questionType;
  final bool? required;
  final String? options;
  final int? order;

  FormQuestions({
    this.id,
    required this.label,
    this.helpText,
    this.questionType,
    this.required,
    this.options,
     this.order,
  });

  factory FormQuestions.fromJson(Map<String, dynamic> json) {
    return FormQuestions(
      id: json['id'],
      label: json['label'],
      helpText: json['help_text'],
      questionType: json['question_type'],
      required: json['required'],
      options:  json['options'],
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
