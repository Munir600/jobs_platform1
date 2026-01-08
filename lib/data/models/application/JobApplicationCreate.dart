class JobApplicationCreate {
  final int job;
  final String? coverLetter;
  final String? resume;
  final String? portfolioUrl;
  final int? expectedSalary;
  final String? availabilityDate;
  final String? notes;
  final String? filledTemplate;
  final List<JobApplicationResponse>? responses;

  JobApplicationCreate({
    required this.job,
    this.coverLetter,
    this.resume,
    this.portfolioUrl,
    this.expectedSalary,
    this.availabilityDate,
    this.notes,
    this.filledTemplate,
    this.responses,
  });

  factory JobApplicationCreate.fromJson(Map<String, dynamic> json) {
    return JobApplicationCreate(
      job: json['job'],
      coverLetter: json['cover_letter'],
      resume: json['resume'],
      portfolioUrl: json['portfolio_url'],
      expectedSalary: json['expected_salary'],
      availabilityDate: json['availability_date'],
      notes: json['notes'],
      filledTemplate: json['filled_template'],
      responses: json['responses'] != null
          ? (json['responses'] as List)
              .map((i) => JobApplicationResponse.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job': job,
      'cover_letter': coverLetter,
      'resume': resume,
      'portfolio_url': portfolioUrl,
      'expected_salary': expectedSalary,
      'availability_date': availabilityDate,
      'notes': notes,
      'filled_template': filledTemplate,
      'responses': responses?.map((e) => e.toJson()).toList(),
    };
  }
}

class JobApplicationResponse {
  final int? question;
  final String? answerText;
  final String? answerFile;

  JobApplicationResponse({
     this.question,
    this.answerText,
    this.answerFile,
  });

  factory JobApplicationResponse.fromJson(Map<String, dynamic> json) {
    return JobApplicationResponse(
      question: json['question'],
      answerText: json['answer_text'],
      answerFile: json['answer_file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer_text': answerText,
      'answer_file': answerFile,
    };
  }
}
