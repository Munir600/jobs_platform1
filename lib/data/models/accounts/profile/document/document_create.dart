// To parse this JSON data, do
//
//     final documentCreate = documentCreateFromJson(jsonString);

import 'dart:convert';

DocumentCreate documentCreateFromJson(String str) => DocumentCreate.fromJson(json.decode(str));

String documentCreateToJson(DocumentCreate data) => json.encode(data.toJson());

class DocumentCreate {
  final String documentType;
  final String? file;
  final String title;
  final String? description;
  final String? issuedBy;
  final DateTime? issueDate;
  final String? visibility;

  DocumentCreate({
    required this.documentType,
    this.file,
    required this.title,
    this.description,
    this.issuedBy,
    this.issueDate,
    this.visibility,
  });

  factory DocumentCreate.fromJson(Map<String, dynamic> json) => DocumentCreate(
        documentType: json["document_type"],
        file: json["file"],
        title: json["title"],
        description: json["description"],
        issuedBy: json["issued_by"],
        issueDate: json["issue_date"] == null ? null : DateTime.parse(json["issue_date"]),
        visibility: json["visibility"],
      );

  Map<String, dynamic> toJson() => {
        "document_type": documentType,
        if (file != null && file!.isNotEmpty) "file": file,
        "title": title,
        "description": description,
        "issued_by": issuedBy,
        "issue_date": issueDate == null ? null : "${issueDate!.year.toString().padLeft(4, '0')}-${issueDate!.month.toString().padLeft(2, '0')}-${issueDate!.day.toString().padLeft(2, '0')}",
        "visibility": visibility,
      };
}

