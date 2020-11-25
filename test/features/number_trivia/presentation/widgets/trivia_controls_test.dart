import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/trivia_controls.dart';

import '../../../../fixtures/widget_wrapper.dart';

void main() {
  final hintText = "Input a number";
  final searchButtonText = "Search";
  final randomButtonText = "Random";
  final Function onSearchClick = (input) {};
  final Function onRandomClick = () {};
  testWidgets('should have textField and buttons with correct text', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetWrapper(TriviaControls(
      onSearchClick: onSearchClick,
      onRandomClick: onRandomClick,
    )));

    final textFieldFinder = find.widgetWithText(TextField, hintText);
    final searchButton = find.widgetWithText(RaisedButton, searchButtonText);
    final randomButton = find.widgetWithText(RaisedButton, randomButtonText);

    expect(textFieldFinder, findsOneWidget);
    expect(searchButton, findsOneWidget);
    expect(randomButton, findsOneWidget);
  });

  testWidgets('should textField cleared when search button click', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetWrapper(TriviaControls(
      onSearchClick: onSearchClick,
      onRandomClick: onRandomClick,
    )));

    await tester.enterText(find.widgetWithText(TextField, hintText), "12");
    await tester.tap(find.widgetWithText(RaisedButton, searchButtonText));

    expect(find.text("12"), findsNothing);
  });

  testWidgets('should textField cleared when random button click', (WidgetTester tester) async {
    await tester.pumpWidget(buildWidgetWrapper(TriviaControls(
      onSearchClick: onSearchClick,
      onRandomClick: onRandomClick,
    )));

    await tester.enterText(find.widgetWithText(TextField, hintText), "12");
    await tester.tap(find.widgetWithText(RaisedButton, randomButtonText));

    expect(find.text("12"), findsNothing);
  });
}
