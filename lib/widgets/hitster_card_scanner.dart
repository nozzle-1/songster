import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:safe_device/safe_device.dart';
import 'package:songster/song/hitster_song_url.dart';

class HitsterCardScanner extends StatefulWidget {
  final Function(HitsterSongUrl hitsterUrl) onDetect;

  const HitsterCardScanner({super.key, required this.onDetect});

  @override
  State<HitsterCardScanner> createState() => _HitsterCardScannerState();
}

class _HitsterCardScannerState extends State<HitsterCardScanner> {
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

    final hitsterUrl = HitsterSongUrl.parse("www.hitstergame.com/fr/$padded");
    widget.onDetect(hitsterUrl);
  }

  void onDetect(BarcodeCapture? capture) {
    if (capture == null) {
      print("No QR Code detected.");
      return;
    }

    final List<Barcode> barcodes = capture.barcodes;
    final hitsterUrl =
        HitsterSongUrl.parse(barcodes.firstOrNull?.rawValue ?? "");

    widget.onDetect(hitsterUrl);
  }
}
