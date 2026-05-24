import 'package:flutter_test/flutter_test.dart';

// Giả lập hàm tính toán phần trăm độ phù hợp giữa 2 chuỗi/mảng
int calculateMatchPercent(List<String> userTags, List<String> cafeTags) {
  if (userTags.isEmpty || cafeTags.isEmpty) return 0;
  int matchCount = 0;
  for (var tag in userTags) {
    if (cafeTags.contains(tag)) {
      matchCount++;
    }
  }
  return ((matchCount / userTags.length) * 100).round();
}

void main() {
  group('Logic tính độ tương thích (Match Percent)', () {
    test('Nên trả về 100% nếu tất cả tag đều khớp', () {
      final userTags = ['Quiet', 'Wifi', 'Coffee'];
      final cafeTags = ['Quiet', 'Wifi', 'Coffee', 'Cake'];
      
      final result = calculateMatchPercent(userTags, cafeTags);
      
      expect(result, 100);
    });

    test('Nên trả về 50% nếu khớp một nửa số tag', () {
      final userTags = ['Quiet', 'Wifi', 'Coffee', 'Tea'];
      final cafeTags = ['Quiet', 'Wifi', 'Cake'];
      
      final result = calculateMatchPercent(userTags, cafeTags);
      
      expect(result, 50);
    });

    test('Nên trả về 0% nếu không có tag nào', () {
      final userTags = <String>[];
      final cafeTags = ['Quiet', 'Wifi'];
      
      final result = calculateMatchPercent(userTags, cafeTags);
      
      expect(result, 0);
    });
  });
}
