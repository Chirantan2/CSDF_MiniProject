import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'encryption.dart'; // Import your AES class

class ScanQRScreen extends StatefulWidget {
  @override
  _ScanQRScreenState createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String encryptionKey = ""; // Store the encryption key entered by the user
  String decryptedData = ""; // Store the decrypted data

  Uint8List iv = Uint8List(16);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                encryptionKey = value;
              });
            },
            decoration: InputDecoration(labelText: 'Enter Encryption Key'),
          ),
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  try {
                    decryptedData = decryptQRCodeData(scanData);
                    // Update the state with decrypted data
                    setState(() {});
                  } catch (e) {
                    // Handle decryption error
                    print('Error decrypting QR code: $e');
                  }
                });
              },
            ),
          ),
          if (decryptedData.isNotEmpty)
            Text(
              'Decrypted Data: $decryptedData',
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String decryptQRCodeData(Barcode scanData) {
    if (scanData.code != null && encryptionKey.isNotEmpty) {
      final encryptedData = Uint8List.fromList(base64.decode(scanData.code!));
      final aes = AES();
      final key = Uint8List.fromList(utf8.encode(encryptionKey)); // Convert encryptionKey to Uint8List
      final decryptedData = aes.aesCbcDecrypt(key, iv, encryptedData);
      return String.fromCharCodes(decryptedData);
    } else {
      throw Exception('Invalid QR code data or encryption key is empty');
    }
  }
}
