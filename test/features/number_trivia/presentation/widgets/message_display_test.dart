import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/message_display.dart';

import '../../../../fixtures/widget_wrapper.dart';

void main() {
  testWidgets('should display correct message', (WidgetTester tester) async {
    final testText = "Hello World!";

    await tester.pumpWidget(buildWidgetWrapper(MessageDisplay(message: testText)));

    final messageFinder = find.text(testText);

    expect(messageFinder, findsOneWidget);
  });
}
