import 'package:flutter_test/flutter_test.dart';
import 'package:ezan_vakti_premium/core/services/quran_repository.dart';

void main() {
  test('QuranRepository surah count test', () {
    final repo = QuranRepository();
    final surahs = repo.getSurahs();
    expect(surahs.isNotEmpty, isTrue);
  });
}
