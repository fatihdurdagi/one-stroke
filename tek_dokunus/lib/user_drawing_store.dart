import 'dart:io';

import 'package:flutter/material.dart';

class UserDrawing {
  const UserDrawing({
    required this.imageFile,
    required this.points,
    required this.drawingTime,
    required this.color,
    required this.createdAt,
    required this.strokeLength,
    required this.score,
  });

  final File imageFile;
  final List<Offset?> points;
  final int drawingTime;
  final Color color;
  final DateTime createdAt;
  final double strokeLength;
  final double score;
}

class UserDrawingStore {
  UserDrawingStore._();

  static final ValueNotifier<List<UserDrawing>> drawings =
      ValueNotifier<List<UserDrawing>>(<UserDrawing>[]);

  static void add(UserDrawing drawing) {
    drawings.value = [drawing, ...drawings.value];
  }
}
