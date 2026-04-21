import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tek_dokunus/app_colors.dart';
import 'package:tek_dokunus/models/drawing_result.dart';
import 'package:tek_dokunus/user_drawing_store.dart';
import 'package:tek_dokunus/welcome_page.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({
    super.key,
    required this.imageFile,
    required this.points,
    required this.drawingTime,
    required this.color,
    required this.result,
  });

  final File           imageFile;
  final List<Offset?>  points;
  final int            drawingTime;
  final Color          color;
  final DrawingResult  result;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _saveImage() async {
    try {
      await Gal.putImage(widget.imageFile.path);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Galeriye kaydedildi')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaydetme başarısız')),
      );
    }
  }

  Future<void> _shareImage() async {
    try {
      await Share.shareXFiles([XFile(widget.imageFile.path)]);
    } catch (_) {}
  }

  void _postToGallery() {
    UserDrawingStore.add(UserDrawing(
      imageFile:   widget.imageFile,
      points:      widget.points,
      drawingTime: widget.drawingTime,
      color:       widget.color,
      createdAt:   DateTime.now(),
      result:      widget.result,
    ));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ───────────────────────────────────────────────────
              Row(
                children: [
                  _TopIcon(
                    icon: Icons.menu_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  const Text(
                    'OneStroke',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Spacer(),
                  _TopIcon(
                    icon: Icons.account_circle_outlined,
                    onTap: _shareImage,
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Labels ────────────────────────────────────────────────────
              const Text(
                'SON İNCELEME',
                style: TextStyle(
                  color: Color(0xFFF4E6A2),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'GÖNDERİ ÖNİZLEMESİ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
              ),
              const SizedBox(height: 16),

              // ── Preview image ─────────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: const Color(0xFF111111),
                  child: Image.file(widget.imageFile, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),

              // ── Analysis badges ───────────────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _Badge(label: '${r.score} puan',
                        color: AppColors.accent),
                    const SizedBox(width: 6),
                    _Badge(label: '${r.strokeLength.toStringAsFixed(0)} px',
                        color: AppColors.teal),
                    const SizedBox(width: 6),
                    _Badge(label: '${r.drawingTimeMs} ms',
                        color: AppColors.coral),
                    const SizedBox(width: 6),
                    _Badge(label: '${r.fluency.toStringAsFixed(0)}% akıcılık',
                        color: const Color(0xFF9B9B9B)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Caption field ─────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: TextField(
                  controller: _captionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Başeseriniz için bir başlık girin...',
                    hintStyle: TextStyle(color: Color(0xFF747474)),
                    contentPadding: EdgeInsets.all(14),
                    suffixIcon: Icon(Icons.edit_outlined,
                        size: 18, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Info row ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF252525)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Color(0xFFE8E8E8), size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Bu eskiz stüdyo akışınıza kaydedilecek. '
                        'Darbe uzunluğu ${r.strokeLength.toStringAsFixed(0)} px, '
                        'süre ${r.drawingTimeMs} ms, puan ${r.score}.',
                        style: const TextStyle(
                          color: Color(0xFFC8C8C8),
                          fontSize: 11,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // ── Action buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'VAZGEÇ',
                        style: TextStyle(
                          color: Color(0xFFA8A8A8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _postToGallery,
                      child: const Text(
                        'GALERİYE GÖNDER',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saveImage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF2E2E2E)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('KAYDET'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _shareImage,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF2E2E2E)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('PAYLAŞ'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small widgets ──────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({required this.icon, required this.onTap});

  final IconData    icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2B2B2B)),
        ),
        child: Icon(icon, size: 17, color: Colors.white),
      ),
    );
  }
}
