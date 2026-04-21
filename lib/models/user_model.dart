class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.followerCount,
    required this.followingCount,
    required this.isFollowing,
  });

  final String id;
  final String username;
  final String avatarUrl;
  final int    followerCount;
  final int    followingCount;
  final bool   isFollowing;

  UserModel copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    int?    followerCount,
    int?    followingCount,
    bool?   isFollowing,
  }) {
    return UserModel(
      id:             id             ?? this.id,
      username:       username       ?? this.username,
      avatarUrl:      avatarUrl      ?? this.avatarUrl,
      followerCount:  followerCount  ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing:    isFollowing    ?? this.isFollowing,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':             id,
    'username':       username,
    'avatarUrl':      avatarUrl,
    'followerCount':  followerCount,
    'followingCount': followingCount,
    'isFollowing':    isFollowing,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id:             map['id']             as String,
    username:       map['username']       as String,
    avatarUrl:      map['avatarUrl']      as String,
    followerCount:  map['followerCount']  as int,
    followingCount: map['followingCount'] as int,
    isFollowing:    map['isFollowing']    as bool,
  );
}
