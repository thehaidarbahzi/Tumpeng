import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tumpeng/core/theme/app_theme.dart';

class QrCodeView extends StatelessWidget {
  const QrCodeView({super.key, required this.data, this.size = 184});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Kode QR',
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: QrImageView(
        data: data,
        size: size,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.darkGreen,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      ),
    ),
  );
}
