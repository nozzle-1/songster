import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safe_device/safe_device.dart';

class QrCodeScanner extends StatefulWidget {
  final Function(String qrCodeValue) onDetect;

  const QrCodeScanner({super.key, required this.onDetect});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectImageInGallery,
      child: MobileScanner(onDetect: onDetect),
    );
  }

  void selectImageInGallery() async {
    var isPhysicalDevice = await SafeDevice.isRealDevice;
    if (isPhysicalDevice) {
      return;
    }

    final songId = _random.nextInt(307) + 1;
    var padded = "$songId".padLeft(5, "0");

    widget.onDetect("www.hitster.com/fr/$padded");
  }

  void onDetect(BarcodeCapture? capture) {
    if (capture == null) {
      print("No QR Code detected.");
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    widget.onDetect(barcodes.firstOrNull?.rawValue ?? "");
  }
}
