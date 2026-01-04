// To parse this JSON data, do
//
//     final documentDetail = documentDetailFromJson(jsonString);

import 'dart:convert';

DocumentDetail documentDetailFromJson(String str) => DocumentDetail.fromJson(json.decode(str));

String documentDetailToJson(DocumentDetail data) => json.encode(data.toJson());

class DocumentDetail {
  final int id;
  final String documentType;
  final String title;
  final String? description;
  final String file;
  final String fileUrl;
  final String fileSize;
  final String fileName;
  final String? issuedBy;
  final DateTime? issueDate;
  final String? visibility;
  final int viewsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DocumentDetail({
    required this.id,
    required this.documentType,
    required this.title,
    this.description,
    required this.file,
    required this.fileUrl,
    required this.fileSize,
    required this.fileName,
    this.issuedBy,
    this.issueDate,
    this.visibility,
    required this.viewsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory DocumentDetail.fromJson(Map<String, dynamic> json) {
    // Handle nested 'document' structure from some API responses
    final Map<String, dynamic> data = json.containsKey('document') ? json['document'] : json;
    
    return DocumentDetail(
      id: data["id"] ?? 0,
      documentType: data["document_type"] ?? 'other',
      title: data["title"] ?? '',
      description: data["description"],
      file: data["file"] ?? '',
      fileUrl: data["file_url"] ?? '',
      fileSize: data["file_size"]?.toString() ?? '0 B',
      fileName: data["file_name"] ?? '',
      issuedBy: data["issued_by"],
      issueDate: data["issue_date"] == null ? null : DateTime.parse(data["issue_date"]),
      visibility: data["visibility"],
      viewsCount: data["views_count"] ?? 0,
      createdAt: data["created_at"] == null ? null : DateTime.parse(data["created_at"]),
      updatedAt: data["updated_at"] == null ? null : DateTime.parse(data["updated_at"]),
    );
  }

  DocumentDetail copyWith({
    int? id,
    String? documentType,
    String? title,
    String? description,
    String? file,
    String? fileUrl,
    String? fileSize,
    String? fileName,
    String? issuedBy,
    DateTime? issueDate,
    String? visibility,
    int? viewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentDetail(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      description: description ?? this.description,
      file: file ?? this.file,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      fileName: fileName ?? this.fileName,
      issuedBy: issuedBy ?? this.issuedBy,
      issueDate: issueDate ?? this.issueDate,
      visibility: visibility ?? this.visibility,
      viewsCount: viewsCount ?? this.viewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "document_type": documentType,
        "title": title,
        "description": description,
        "file": file,
        "file_url": fileUrl,
        "file_size": fileSize,
        "file_name": fileName,
        "issued_by": issuedBy,
        "issue_date": issueDate == null ? null : "${issueDate!.year.toString().padLeft(4, '0')}-${issueDate!.month.toString().padLeft(2, '0')}-${issueDate!.day.toString().padLeft(2, '0')}",
        "visibility": visibility,
        "views_count": viewsCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}


