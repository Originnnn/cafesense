import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cafesense/features/cafe/data/models/cafe.dart';
import 'package:cafesense/features/cafe/data/repositories/cafe_repository.dart';

class AiChatService {
  // TODO: Replace with your actual Gemini API Key from https://aistudio.google.com/app/apikey
  static const String _apiKey = 'AIzaSyAXUcfMzy-05r0PiAszqey_lXKqFeCFLcY';

  final GenerativeModel _model;
  final CafeRepository _cafeRepository;

  AiChatService(this._cafeRepository)
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: _apiKey,
        );

  Future<ChatResponse> sendMessage(String userMessage) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      return ChatResponse(
        text:
            'Lỗi: Vui lòng cập nhật Gemini API Key trong file ai_chat_service.dart để sử dụng tính năng này!',
        matchedCafes: [],
      );
    }

    try {
      // 1. Lấy dữ liệu các quán cafe để cung cấp cho AI
      final cafes = await _cafeRepository.getCafes();

      // Tạo một chuỗi JSON tóm tắt các quán cafe để AI hiểu
      final cafesJson = cafes
          .map((c) => {
                'id': c.id,
                'name': c.name,
                'description': c.description,
                'amenities': c.amenities,
                'priceLabel': c.priceLabel,
                'spaceStyle': c.spaceStyle,
              })
          .toList();

      // 2. Tạo System Prompt
      final systemPrompt = '''
Bạn là trợ lý AI chuyên gia về cà phê của ứng dụng CafeSense. Nhiệm vụ của bạn là tư vấn và gợi ý quán cafe phù hợp nhất dựa trên yêu cầu của người dùng.
Dưới đây là danh sách các quán cafe trong hệ thống dưới dạng JSON:
${jsonEncode(cafesJson)}

Quy tắc trả lời:
1. Phân tích yêu cầu của người dùng và đối chiếu với danh sách quán ở trên.
2. Trả lời bằng tiếng Việt, giọng điệu thân thiện, tự nhiên, và hữu ích.
3. Nếu có quán phù hợp, hãy giới thiệu ngắn gọn lý do tại sao nó phù hợp.
4. RẤT QUAN TRỌNG: Ở cuối câu trả lời của bạn, bạn PHẢI in ra một dòng chứa ID của các quán bạn gợi ý theo định dạng chính xác sau: [MATCHED_IDS: id1, id2, id3].
Ví dụ: [MATCHED_IDS: sora_coffee, zone_six]
Nếu không có quán nào phù hợp, in ra: [MATCHED_IDS: NONE].
Đừng thêm bất kỳ ký tự nào khác vào dòng MATCHED_IDS này.
''';

      // 3. Gửi yêu cầu tới Gemini
      final prompt = '$systemPrompt\n\nYêu cầu của người dùng: "$userMessage"';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final responseText = response.text ?? '';

      // 4. Phân tích chuỗi trả về để tìm MATCHED_IDS
      final matchedIds = _extractMatchedIds(responseText);

      // 5. Lọc ra danh sách quán thực tế
      final matchedCafes =
          cafes.where((c) => matchedIds.contains(c.id)).toList();

      // Làm sạch text (xóa dòng MATCHED_IDS để không hiển thị cho user)
      final cleanText =
          responseText.replaceAll(RegExp(r'\[MATCHED_IDS:.*\]'), '').trim();

      return ChatResponse(
        text: cleanText.isEmpty
            ? "Mình đã tìm thấy một số quán bên dưới nhé!"
            : cleanText,
        matchedCafes: matchedCafes,
      );
    } catch (e) {
      return ChatResponse(
        text:
            'Xin lỗi, hiện tại mình đang gặp sự cố khi xử lý yêu cầu. Vui lòng thử lại sau. (Lỗi: $e)',
        matchedCafes: [],
      );
    }
  }

  List<String> _extractMatchedIds(String text) {
    final RegExp regExp = RegExp(r'\[MATCHED_IDS:\s*(.*?)\]');
    final match = regExp.firstMatch(text);

    if (match != null && match.groupCount >= 1) {
      final idsString = match.group(1)?.trim() ?? '';
      if (idsString == 'NONE' || idsString.isEmpty) {
        return [];
      }
      // Tách bằng dấu phẩy và xóa khoảng trắng
      return idsString
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }
}

class ChatResponse {
  final String text;
  final List<Cafe> matchedCafes;

  ChatResponse({required this.text, required this.matchedCafes});
}
