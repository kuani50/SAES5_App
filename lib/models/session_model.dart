class SessionModel {
  final String id;
  final int? userId;
  final String? ipAddress;
  final String? userAgent;
  final String payload;
  final int lastActivity;

  SessionModel({
    required this.id,
    this.userId,
    this.ipAddress,
    this.userAgent,
    required this.payload,
    required this.lastActivity,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as int?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      payload: json['payload'] as String,
      lastActivity: json['last_activity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'payload': payload,
      'last_activity': lastActivity,
    };
  }
}
