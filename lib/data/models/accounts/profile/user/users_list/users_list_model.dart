// هذه العملية غير مصرح بها

// To parse this JSON data, do
//
//     final usersListModel = usersListModelFromJson(jsonString);

import 'dart:convert';

UsersListModel usersListModelFromJson(String str) => UsersListModel.fromJson(json.decode(str));

String usersListModelToJson(UsersListModel data) => json.encode(data.toJson());

class UsersListModel {
  final String? ordering;
  final String? page;
  final String? search;

  UsersListModel({
    this.ordering,
    this.page,
    this.search,
  });

  factory UsersListModel.fromJson(Map<String, dynamic> json) => UsersListModel(
    ordering: json["ordering"],
    page: json["page"],
    search: json["search"],
  );

  Map<String, dynamic> toJson() => {
    "ordering": ordering,
    "page": page,
    "search": search,
  };
}
