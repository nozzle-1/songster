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
  final MobileScannerController _controller = MobileScannerController();

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

    //Impossible d'utiliser ImagePicker, ne fonctionne pas avec Simulator
    const path =
        "/Users/dylan/Library/Developer/CoreSimulator/Devices/61D931C7-21EB-4157-BF9B-A9CE2AE1A649/data/Containers/Shared/AppGroup/17EA51AA-D9A9-48D3-8D14-6AF0BB978D25/File Provider Storage/Downloads/Capture d’écran 2024-09-24 à 23.54.PNG";

    final BarcodeCapture? barcodeCapture = await _controller.analyzeImage(path);

    onDetect(barcodeCapture);
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
