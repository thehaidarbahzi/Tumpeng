import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tumpeng/core/theme/app_theme.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  String? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pindai kode QR')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final value = capture.barcodes
                        .map((barcode) => barcode.rawValue)
                        .whereType<String>()
                        .firstOrNull;
                    if (value != null && mounted)
                      setState(() => _result = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _result ?? 'Arahkan kamera ke kode QR',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            if (_result != null)
              ElevatedButton.icon(
                onPressed: () => setState(() => _result = null),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Pindai lagi'),
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _controller.toggleTorch(),
              icon: const Icon(Icons.flash_on),
              label: const Text('Lampu kilat'),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pastikan isi kode berasal dari sumber tepercaya.',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ],
        ),
      ),
    ),
  );
}
