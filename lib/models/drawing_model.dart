import 'package:flutter/material.dart';
import 'package:one_stroke/models/drawing_result.dart';

class DrawingModel {
  const DrawingModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.points,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.analysis,
    required this.createdAt,
  });

  final String        id;
  final String        userId;
  final String        username;
  final List<Offset>  points;
  final int           likeCount;
  final int           commentCount;
  final bool          isLiked;
  final DrawingResult analysis;
  final DateTime      createdAt;

  DrawingModel copyWith({
    String?        id,
    String?        userId,
    String?        username,
    List<Offset>?  points,
    int?           likeCount,
    int?           commentCount,
    bool?          isLiked,
    DrawingResult? analysis,
    DateTime?      createdAt,
  }) {
    return DrawingModel(
      id:           id           ?? this.id,
      userId:       userId       ?? this.userId,
      username:     username     ?? this.username,
      points:       points       ?? this.points,
      likeCount:    likeCount    ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked:      isLiked      ?? this.isLiked,
      analysis:     analysis     ?? this.analysis,
      createdAt:    createdAt    ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'id':           id,
    'userId':       userId,
    'username':     username,
    'likeCount':    likeCount,
    'commentCount': commentCount,
    'isLiked':      isLiked,
    'analysis':     analysis.toMap(),
    'createdAt':    createdAt.millisecondsSinceEpoch,
  };

  factory DrawingModel.fromMap(Map<String, dynamic> map) => DrawingModel(
    id:           map['id']           as String,
    userId:       map['userId']       as String,
    username:     map['username']     as String,
    points:       const [],
    likeCount:    map['likeCount']    as int,
    commentCount: map['commentCount'] as int,
    isLiked:      map['isLiked']      as bool,
    analysis:     DrawingResult.fromMap(map['analysis'] as Map<String, dynamic>),
    createdAt:    DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
  );
}
