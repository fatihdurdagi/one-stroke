import 'dart:math' as math;

import 'package:flutter/material.dart';

class DrawingResult {
  const DrawingResult({
    required this.strokeLength,
    required this.drawingTimeMs,
    required this.fluency,
    required this.score,
  });

  final double strokeLength;  // total px
  final int    drawingTimeMs; // ms
  final double fluency;       // 0–100
  final int    score;         // 0–10

  // ── Factory ──────────────────────────────────────────────────────────────────

  factory DrawingResult.calculate(List<Offset?> points, int drawingTimeMs) {
    final pts = points.whereType<Offset>().toList();

    // Stroke length
    var length = 0.0;
    for (var i = 0; i < pts.length - 1; i++) {
      length += (pts[i] - pts[i + 1]).distance;
    }

    // Fluency: average angle change across consecutive triplets
    var totalAngle = 0.0;
    var angleCount = 0;
    for (var i = 0; i < pts.length - 2; i++) {
      final v1 = pts[i + 1] - pts[i];
      final v2 = pts[i + 2] - pts[i + 1];
      if (v1.distance > 0 && v2.distance > 0) {
        final dot = v1.dx * v2.dx + v1.dy * v2.dy;
        final cos = (dot / (v1.distance * v2.distance)).clamp(-1.0, 1.0);
        totalAngle += math.acos(cos);
        angleCount++;
      }
    }
    final avgAngle = angleCount > 0 ? totalAngle / angleCount : 0.0;
    // avgAngle ∈ [0, π] → fluency ∈ [100, 0]
    final fluency = ((1.0 - avgAngle / math.pi) * 100).clamp(0.0, 100.0);

    // Score formula (PDF):
    // raw = (fluency/100)*0.4 + min(length/1000,1)*0.3 + max(0, 1-time/10000)*0.3
    final timeFactor = drawingTimeMs > 0 ? drawingTimeMs / 10000.0 : 1.0;
    final raw = (fluency / 100 * 0.4) +
        (math.min(length / 1000.0, 1.0) * 0.3) +
        (math.max(0.0, 1.0 - timeFactor) * 0.3);
    final score = (raw * 10).round().clamp(0, 10);

    return DrawingResult(
      strokeLength: length,
      drawingTimeMs: drawingTimeMs,
      fluency: fluency,
      score: score,
    );
  }

  // ── copyWith ─────────────────────────────────────────────────────────────────

  DrawingResult copyWith({
    double? strokeLength,
    int?    drawingTimeMs,
    double? fluency,
    int?    score,
  }) {
    return DrawingResult(
      strokeLength:  strokeLength  ?? this.strokeLength,
      drawingTimeMs: drawingTimeMs ?? this.drawingTimeMs,
      fluency:       fluency       ?? this.fluency,
      score:         score         ?? this.score,
    );
  }

  // ── Serialisation ─────────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() => {
    'strokeLength':  strokeLength,
    'drawingTimeMs': drawingTimeMs,
    'fluency':       fluency,
    'score':         score,
  };

  factory DrawingResult.fromMap(Map<String, dynamic> map) => DrawingResult(
    strokeLength:  (map['strokeLength']  as num).toDouble(),
    drawingTimeMs:  map['drawingTimeMs'] as int,
    fluency:       (map['fluency']       as num).toDouble(),
    score:          map['score']         as int,
  );
}
