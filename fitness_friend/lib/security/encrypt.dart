import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class securityHelper {
  static final _key = Key.fromUtf8('FFSecureKey_2024_123456_ABCDEFGH');
  static final _iv = IV.fromUtf8('1234567890123456');
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
  
  static String encrypt(String data) {
    if (data.isEmpty) return data;
    try {
      final encrypted = _encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Encryption error: $e');
      return 'enc_${base64.encode(utf8.encode(data))}';
    }
  }
  
  static String decrypt(String encryptedData) {
    if (encryptedData.isEmpty) return encryptedData;
    try {
      final decrypted = _encrypter.decrypt64(encryptedData, iv: _iv);
      return decrypted;
    } catch (e) {
      if (encryptedData.startsWith('enc_')) {
        final base64Data = encryptedData.substring(4);
        return utf8.decode(base64.decode(base64Data));
      }
      return encryptedData;
    }
  }
}
