// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:pointycastle/pointycastle.dart' as pointycastle;
// import 'dart:typed_data';
// import 'encryption.dart';
//
// class GenerateQRScreen extends StatefulWidget {
//   @override
//   _GenerateQRScreenState createState() => _GenerateQRScreenState();
// }
//
// class _GenerateQRScreenState extends State<GenerateQRScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   String qrData = "";
//
//   @override
//   void dispose() {
//     _textEditingController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate QR Code'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _textEditingController,
//               decoration: InputDecoration(labelText: 'Enter Text'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 generateQRCode();
//               },
//               child: Text('Generate QR Code'),
//             ),
//             if (qrData.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.all(16.0),
//                 child: QrImageView(
//                   data: qrData,
//                   version: QrVersions.auto,
//                   size: 200.0,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   final key = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]);
//   final iv = Uint8List.fromList([17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]);
//
//
//
//   void generateQRCode() {
//     final inputText = _textEditingController.text;
//
//     final bytes = utf8.encode(inputText);
//     final encodedString = base64Encode(bytes);
//
//     setState(() {
//       qrData = encodedString; // Convert encrypted data to base64
//     });
//   }
// }
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:pointycastle/pointycastle.dart' as pointycastle;
// import 'dart:typed_data';
// import 'encryption.dart'; // Import your encryption logic
//
// class GenerateQRScreen extends StatefulWidget {
//   @override
//   _GenerateQRScreenState createState() => _GenerateQRScreenState();
// }
//
// class _GenerateQRScreenState extends State<GenerateQRScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final TextEditingController _encryptionKeyController = TextEditingController(); // New controller for the encryption key
//   String qrData = "";
//   Uint8List encryptionKey = Uint8List(16); // Initialize an empty key
//
//   @override
//   void dispose() {
//     _textEditingController?.dispose();
//     _encryptionKeyController?.dispose(); // Dispose of the key controller
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Generate QR Code'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _textEditingController,
//               decoration: InputDecoration(labelText: 'Enter Text'),
//             ),
//             TextFormField( // New text field for the encryption key
//               controller: _encryptionKeyController,
//               decoration: InputDecoration(labelText: 'Encryption Key'),
//               obscureText: true, // Obscure the text
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 generateQRCode();
//               },
//               child: Text('Generate QR Code'),
//             ),
//             if (qrData.isNotEmpty)
//               Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(16.0),
//                     child: QrImageView(
//                       data: qrData,
//                       version: QrVersions.auto,
//                       size: 200.0,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: copyEncryptionKey,
//                     child: Text('Copy Encryption Key'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void generateQRCode() {
//     final inputText = _textEditingController.text;
//     final keyText = _encryptionKeyController.text;
//
//     // Validate the encryption key
//     if (keyText.length != 16) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Invalid Key'),
//             content: Text('The encryption key must be 16 characters long.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     // Convert the key from a string to Uint8List
//     encryptionKey = Uint8List.fromList(utf8.encode(keyText));
//
//     // Use your encryption logic to encrypt the inputText
//     final encryptedText = encryptWithAES(inputText, encryptionKey);
//
//     setState(() {
//       qrData = base64Encode(encryptedText);
//     });
//   }
//
//   void copyEncryptionKey() {
//     final keyText = String.fromCharCodes(encryptionKey);
//     Clipboard.setData(ClipboardData(text: keyText));
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Encryption Key Copied'),
//     ));
//   }
// }


import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'encryption.dart'; // Import your AES class

class GenerateQRScreen extends StatefulWidget {
  @override
  _GenerateQRScreenState createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _encryptionKeyController = TextEditingController();
  String qrData = "";
  Uint8List encryptionKey = Uint8List(16);

  @override
  void dispose() {
    _textEditingController?.dispose();
    _encryptionKeyController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(labelText: 'Enter Text'),
              ),
              TextFormField(
                controller: _encryptionKeyController,
                decoration: InputDecoration(labelText: 'Encryption Key'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () {
                  generateQRCode();
                },
                child: Text('Generate QR Code'),
              ),
              if (qrData.isNotEmpty)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: copyEncryptionKey,
                      child: Text('Copy Encryption Key'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void generateQRCode() {
    final inputText = _textEditingController.text;
    final keyText = _encryptionKeyController.text;

    // Validate the encryption key
    if (keyText.length != 16) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Invalid Key'),
              content: Text('The encryption key must be 16 characters long.'),
              actions: [
              TextButton(
              onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
              )],

          );
        },
      );
      return;
    }

    encryptionKey = Uint8List.fromList(utf8.encode(keyText));

    // Encrypt the input text using the provided AES class
    final aes = AES();
    final key = encryptionKey;
    final iv = Uint8List(16); // Use a unique IV

    final plaintextBytes = Uint8List.fromList(utf8.encode(inputText));
    final paddedPlaintext = padPlaintext(plaintextBytes);

    final encryptedData = aes.aesCbcEncrypt(key, iv, paddedPlaintext);

    setState(() {
      qrData = base64Encode(encryptedData);
    });
  }

  Uint8List padPlaintext(Uint8List plaintext) {
    final blockSize = 16; // AES block size in bytes
    final paddingLength = blockSize - (plaintext.length % blockSize);
    final paddedPlaintext = Uint8List(plaintext.length + paddingLength);
    paddedPlaintext.setAll(0, plaintext);
    for (var i = plaintext.length; i < paddedPlaintext.length; i++) {
      paddedPlaintext[i] = paddingLength;
    }
    return paddedPlaintext;
  }



  void copyEncryptionKey() {
    final keyText = String.fromCharCodes(encryptionKey);
    Clipboard.setData(ClipboardData(text: keyText));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Encryption Key Copied'),
        ));
  }
}
