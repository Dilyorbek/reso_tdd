import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:reso_tdd/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:reso_tdd/injection_container.dart';

import '../../../../fixtures/widget_wrapper.dart';

class MockNumberTriviaBloc extends Mock implements NumberTriviaBloc {}

void main() {
  NumberTriviaBloc mockBloc;

  setUpAll(() {
    mockBloc = MockNumberTriviaBloc();

    sl.registerLazySingleton(() => mockBloc);
  });

  group('StateToWidget', () {
    Future<void> setupStateAndWidget(WidgetTester tester, NumberTriviaState state) async {
      when(mockBloc.state).thenReturn(state);

      await tester.pumpWidget(buildWidgetWrapper(NumberTriviaPage(), isPage: true));
      await tester.pump(Duration.zero);
    }

    testWidgets('should show empty message for Empty state', (WidgetTester tester) async {
      final emptyStateText = "Start searching...";
      await setupStateAndWidget(tester, Empty());

      expect(find.widgetWithText(MessageDisplay, emptyStateText), findsOneWidget);
      expect(find.byType(LoadingWidget), findsNothing);
      expect(find.byType(TriviaDisplay), findsNothing);
    });

    testWidgets('should show message for Error state', (WidgetTester tester) async {
      final errorMessage = "Invalid Input";

      await setupStateAndWidget(tester, Error(message: errorMessage));

      expect(find.widgetWithText(MessageDisplay, errorMessage), findsOneWidget);
      expect(find.byType(LoadingWidget), findsNothing);
      expect(find.byType(TriviaDisplay), findsNothing);
    });

    testWidgets('should show loader for Loading state', (WidgetTester tester) async {
      await setupStateAndWidget(tester, Loading());

      expect(find.byType(TriviaDisplay), findsNothing);
      expect(find.byType(MessageDisplay), findsNothing);
      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('should show number and text for Loaded state', (WidgetTester tester) async {
      final tNumberTrivia = NumberTrivia(number: 12, text: "Hello");

      await setupStateAndWidget(tester, Loaded(trivia: tNumberTrivia));

      expect(find.widgetWithText(TriviaDisplay, tNumberTrivia.number.toString()), findsOneWidget);
      expect(find.widgetWithText(TriviaDisplay, tNumberTrivia.text), findsOneWidget);
      expect(find.byType(LoadingWidget), findsNothing);
      expect(find.byType(MessageDisplay), findsNothing);
    });

  });

  group('MethodToEvent', () {
    final inputText = "12";
    final hintText = "Input a number";
    final searchButtonText = "Search";
    final randomButtonText = "Random";

    Future<void> onButtonClick(WidgetTester tester, String text, NumberTriviaEvent event) async {
      await tester.pumpWidget(buildWidgetWrapper(NumberTriviaPage(), isPage: true));
      await tester.pump(Duration.zero);
      await tester.enterText(find.widgetWithText(TextField, hintText), inputText);
      await tester.tap(find.text(text));

      verify(mockBloc.add(event));
    }

    testWidgets('should call correct method when random button click', (WidgetTester tester) async {
      await onButtonClick(tester, randomButtonText, GetTriviaForRandomNumber());
    });

    testWidgets('should call correct method when search button click', (WidgetTester tester) async {
      await onButtonClick(tester, searchButtonText, GetTriviaForConcreteNumber(inputText));
    });
  });
}
