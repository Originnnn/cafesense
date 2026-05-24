import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cafesense/core/widgets/survey_widgets.dart';

void main() {
  group('Survey Widgets UI Tests', () {
    testWidgets('SurveyProgressBar nên hiển thị đúng phần trăm', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SurveyProgressBar(progress: 0.75),
          ),
        ),
      );

      // Verify the text says 75%
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('PrimaryButton nên phản hồi khi click (nếu isEnabled = true)', (WidgetTester tester) async {
      bool isClicked = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Tiếp tục',
              isEnabled: true,
              onPressed: () {
                isClicked = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Tiếp tục'), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      
      expect(isClicked, isTrue);
    });
  });
}
