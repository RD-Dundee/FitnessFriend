import 'package:encrypt/encrypt.dart';

class securityHelper {
  static final _key = Key.fromUtf8('INeedAKeyButDKWhatNeedMoreChar?');
  static final _encrypter = Encrypter(AES(_key));
  
  static String encrypt(String data) {
    if (data.isEmpty) return data;
    try {
      return _encrypter.encrypt(data).base64;
    } catch (e) {
      return data;
    }
  }
  
  static String decrypt(String encryptedData) {
    if (encryptedData.isEmpty) return encryptedData;
    try {
      return _encrypter.decrypt64(encryptedData);
    } catch (e) {
      return encryptedData;
    }
  }
}
