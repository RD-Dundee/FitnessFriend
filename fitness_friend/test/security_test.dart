import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_friend/security/encrypt.dart';

void main() {
  group('Security Implementation', () {
    test('Encrypt and decrypt meal names', () {
      const testMeals = [
        "Chicken Salad",
        "Protein Shake",
        "Pasta",
        "Test Meal 123"
      ];
      
      for (final meal in testMeals) {
        final encrypted = securityHelper.encrypt(meal);
        final decrypted = securityHelper.decrypt(encrypted);
        
        expect(decrypted, meal);
        print('✓ "$meal" -> encrypted -> "$decrypted"');
      }
    });

    test('Handle empty and edge cases', () {
      expect(securityHelper.encrypt(""), "");
      expect(securityHelper.decrypt(""), "");
      
      const testString = "Test";
      final encrypted = securityHelper.encrypt(testString);
      expect(encrypted is String, true);
      expect(encrypted.isNotEmpty, true);
    });
  });
}
