import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/trivia_display.dart';

import '../../../../fixtures/widget_wrapper.dart';

void main() {

  testWidgets('should display correct number trivia', (WidgetTester tester) async {
    final tNumberTrivia = NumberTrivia(number: 1, text: "Hello World");

    await tester.pumpWidget(buildWidgetWrapper(TriviaDisplay(numberTrivia: tNumberTrivia)));

    final numberFinder = find.text(tNumberTrivia.number.toString());
    final textFinder = find.text(tNumberTrivia.text);

    expect(numberFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
  });
}