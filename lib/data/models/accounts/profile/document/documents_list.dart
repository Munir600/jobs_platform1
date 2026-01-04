// To parse this JSON data, do
//
//     final documentsList = documentsListFromJson(jsonString);

import 'dart:convert';

import 'document_detail.dart';

DocumentsList documentsListFromJson(String str) => DocumentsList.fromJson(json.decode(str));

String documentsListToJson(DocumentsList data) => json.encode(data.toJson());

class DocumentsList {
  // final int count;
  // final String? next;
  // final String? previous;
  final List<DocumentDetail>? results;

  DocumentsList({
    // required this.count,
    // this.next,
    // this.previous,
     this.results,
  });

  factory DocumentsList.fromJson(Map<String, dynamic> json) => DocumentsList(
    // count: json["count"],
    // next: json["next"],
    // previous: json["previous"],
    results: json["data"] == null ? [] : List<DocumentDetail>.from(json["data"]!.map((x) => DocumentDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "count": count,
    // "next": next,
    // "previous": previous,
    "data": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

