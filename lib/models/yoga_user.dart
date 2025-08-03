class YogaUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final DateTime? createdAt;
  final bool isEmailVerified;

  YogaUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.createdAt,
    this.isEmailVerified = false,
  });

  factory YogaUser.fromJson(Map<String, dynamic> json) {
    return YogaUser(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
    };
  }

  YogaUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return YogaUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  String toString() {
    return 'YogaUser(uid: $uid, email: $email, displayName: $displayName, phoneNumber: $phoneNumber, createdAt: $createdAt, isEmailVerified: $isEmailVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YogaUser &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.phoneNumber == phoneNumber &&
        other.createdAt == createdAt &&
        other.isEmailVerified == isEmailVerified;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        phoneNumber.hashCode ^
        createdAt.hashCode ^
        isEmailVerified.hashCode;
  }
} 