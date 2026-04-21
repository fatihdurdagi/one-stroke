class CommentModel {
  const CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  final String   id;
  final String   userId;
  final String   username;
  final String   text;
  final DateTime createdAt;

  CommentModel copyWith({
    String?   id,
    String?   userId,
    String?   username,
    String?   text,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id:        id        ?? this.id,
      userId:    userId    ?? this.userId,
      username:  username  ?? this.username,
      text:      text      ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':        id,
    'userId':    userId,
    'username':  username,
    'text':      text,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
    id:        map['id']       as String,
    userId:    map['userId']   as String,
    username:  map['username'] as String,
    text:      map['text']     as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
  );
}
