import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/core/utils/helpers.dart';

void main() {
  group('Helpers', () {
    test('formatDuration formats correctly', () {
      expect(Helpers.formatDuration(const Duration(seconds: 30)), '00:30');
      expect(Helpers.formatDuration(const Duration(minutes: 2, seconds: 15)), '02:15');
      expect(Helpers.formatDuration(const Duration(hours: 1, minutes: 30, seconds: 45)), '1:30:45');
    });

    test('formatFileSize formats correctly', () {
      expect(Helpers.formatFileSize(0), '0 B');
      expect(Helpers.formatFileSize(1024), '1.00 KB');
      expect(Helpers.formatFileSize(1048576), '1.00 MB');
      expect(Helpers.formatFileSize(1073741824), '1.00 GB');
    });

    test('isValidEmail validates correctly', () {
      expect(Helpers.isValidEmail('test@example.com'), true);
      expect(Helpers.isValidEmail('invalid-email'), false);
      expect(Helpers.isValidEmail(''), false);
    });

    test('capitalize works correctly', () {
      expect(Helpers.capitalize('hello'), 'Hello');
      expect(Helpers.capitalize('Hello'), 'Hello');
      expect(Helpers.capitalize(''), '');
    });

    test('generateId creates unique IDs', () {
      final id1 = Helpers.generateId();
      final id2 = Helpers.generateId();
      expect(id1, isNot(equals(id2)));
      expect(id1.length, greaterThan(0));
    });
  });
}