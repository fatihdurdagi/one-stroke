import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tek_dokunus/models/drawing_result.dart';

class UserDrawing {
  const UserDrawing({
    required this.imageFile,
    required this.points,
    required this.drawingTime,
    required this.color,
    required this.createdAt,
    required this.result,
  });

  final File           imageFile;
  final List<Offset?>  points;
  final int            drawingTime;
  final Color          color;
  final DateTime       createdAt;
  final DrawingResult  result;

  // Convenience getters (keep backward-compatible names)
  double get strokeLength => result.strokeLength;
  double get score        => result.score.toDouble();
  double get fluency      => result.fluency;
}

class UserDrawingStore {
  UserDrawingStore._();

  static final ValueNotifier<List<UserDrawing>> drawings =
      ValueNotifier<List<UserDrawing>>(<UserDrawing>[]);

  static void add(UserDrawing drawing) {
    drawings.value = [drawing, ...drawings.value];
  }
}
