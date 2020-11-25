import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Number Trivia', () {

    final titleFinder = find.byValueKey('title');
    final messageFinder = find.byValueKey('message');
    final textFieldFinder = find.byValueKey('text_field');
    final searchFinder = find.byValueKey('search_button');
    final randomFinder = find.byValueKey('random_button');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('empty placeholder is displayed', () async {
      expect(await driver.getText(titleFinder), "Number Trivia");
      expect(await driver.getText(messageFinder), "Start searching...");
      expect(await driver.getText(textFieldFinder), isEmpty);
    });

    test('should clear the textField when button click', () async {
      await driver.tap(textFieldFinder);
      await driver.waitFor(find.text(''));
      await driver.enterText("-12");
      await driver.tap(searchFinder);

      expect(await driver.getText(textFieldFinder), isEmpty);
    });

    test('should show error message when wrong input', () async {
      await driver.tap(textFieldFinder);
      await driver.waitFor(find.text(''));
      await driver.enterText("-12");
      await driver.tap(searchFinder);

      expect(await driver.getText(messageFinder), "Invalid Input");
    });

  });
}