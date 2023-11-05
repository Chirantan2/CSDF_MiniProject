import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/export.dart';
//
// import 'dart:typed_data';
// import 'package:pointycastle/export.dart';
//
// // AES encryption function
// import 'dart:typed_data';
// import 'package:pointycastle/export.dart';
//
// // AES encryption function
// import 'dart:typed_data';
// import 'package:pointycastle/export.dart';
// import 'package:pointycastle/pointycastle.dart' as pointycastle;
//
// // AES encryption function
// import 'dart:typed_data';
// import 'package:pointycastle/export.dart';
//
//
// class AES {
//   Uint8List aesCbcEncrypt(
//       Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
//     assert([128, 192, 256].contains(key.length * 8));
//     assert(128 == iv.length * 8);
//     assert(128 == paddedPlaintext.length * 8);
//
//     final cbc = CBCBlockCipher(AESEngine())
//       ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt
//
//     final cipherText = Uint8List(paddedPlaintext.length); // allocate space
//
//     var offset = 0;
//     while (offset < paddedPlaintext.length) {
//       offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
//     }
//     assert(offset == paddedPlaintext.length);
//
//     return cipherText;
//   }
//
//   Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
//     assert([128, 192, 256].contains(key.length * 8));
//     assert(128 == iv.length * 8);
//     assert(128 == cipherText.length * 8);
//
//     final cbc = CBCBlockCipher(AESEngine())
//       ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt
//
//     final paddedPlainText = Uint8List(cipherText.length); // allocate space
//
//     var offset = 0;
//     while (offset < cipherText.length) {
//       offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
//     }
//     assert(offset == cipherText.length);
//
//     return paddedPlainText;
//   }
// }



class AES {
  Uint8List aesCbcEncrypt(Uint8List key, Uint8List iv, Uint8List paddedPlaintext) {
    assert([128, 192, 256].contains(key.length * 8));
    assert(128 == iv.length * 8);

    final cbc = CBCBlockCipher(AESEngine())
      ..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

    final cipherText = Uint8List(paddedPlaintext.length); // allocate space

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }

    return cipherText;
  }

  Uint8List aesCbcDecrypt(Uint8List key, Uint8List iv, Uint8List cipherText) {
    assert([128, 192, 256].contains(key.length * 8));
    assert(128 == iv.length * 8);

    final cbc = CBCBlockCipher(AESEngine())
      ..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

    final paddedPlainText = Uint8List(cipherText.length + 16); // Allocate space with some extra room for padding

    var offset = 0;
    var paddedOffset = 0;
    while (offset < cipherText.length) {
      paddedOffset += cbc.processBlock(cipherText, offset, paddedPlainText, paddedOffset);
      offset += 16; // AES block size
    }

    // Trim any padding
    final unpaddedPlainText = Uint8List(paddedOffset);
    unpaddedPlainText.setRange(0, paddedOffset, paddedPlainText);

    return unpaddedPlainText;
  }

}
