class ApplicationMessage {
  final int? id;
  final int? application;
  final dynamic sender;
  final String? senderName;
  final String? message;
  final String? attachment;
  final bool? isRead;
  final String? sentAt;

  ApplicationMessage({
    this.id,
    this.application,
    this.sender,
    this.senderName,
    this.message,
    this.attachment,
    this.isRead,
    this.sentAt,
  });

  factory ApplicationMessage.fromJson(Map<String, dynamic> json) {
    return ApplicationMessage(
      id: json['id'],
      application: json['application'],
      sender: json['sender'], // Keep as dynamic to handle both ID and Object
      senderName: json['sender_name'],
      message: json['message'],
      attachment: json['attachment'],
      isRead: json['is_read'],
      sentAt: json['sent_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'application': application,
      'sender': sender,
      'sender_name': senderName,
      'message': message,
      'attachment': attachment,
      'is_read': isRead,
      'sent_at': sentAt,
    };
  }
}
