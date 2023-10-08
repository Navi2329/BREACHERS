import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String societyName;
  final String societyProfilePic;
  final List<String> upvotes;
  final List<String> downvotes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;
  Post({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.societyName,
    required this.societyProfilePic,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? societyName,
    String? societyProfilePic,
    List<String>? upvotes,
    List<String>? downvotes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      societyName: societyName ?? this.societyName,
      societyProfilePic: societyProfilePic ?? this.societyProfilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'societyName': societyName,
      'societyProfilePic': societyProfilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      link: map['link'],
      description: map['description'],
      societyName: map['societyName'] ?? '',
      societyProfilePic: map['societyProfilePic'] ?? '',
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
      commentCount: map['commentCount']?.toInt() ?? 0,
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      type: map['type'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, description: $description, societyName: $societyName, societyProfilePic: $societyProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.societyName == societyName &&
        other.societyProfilePic == societyProfilePic &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        societyName.hashCode ^
        societyProfilePic.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        awards.hashCode;
  }
}