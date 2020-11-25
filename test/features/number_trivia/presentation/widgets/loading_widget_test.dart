import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_tdd/features/number_trivia/presentation/widgets/loading_widget.dart';

import '../../../../fixtures/widget_wrapper.dart';

void main() {

  testWidgets('should display circular loader', (WidgetTester tester) async {

    await tester.pumpWidget(buildWidgetWrapper(LoadingWidget()));

    expect(find.byElementType(CircularProgressIndicator), findsOneWidget);
  });
}