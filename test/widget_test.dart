import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/keys.dart';
import 'package:test_task_flutter/random_number_generator.dart';
import 'package:test_task_flutter/yellow_screen.dart';

class MyRandomNumberGenerator extends RandomNumberGenerator {
  @override
  int generate() {
    return 35; // возвращается фиксированное число для проверки
  }
}
void main() {
  group('YellowScreen widget test', () {
    testWidgets(
        'Should display number less 49 when button is pressed, the color is number should be blue',
            (WidgetTester tester) async {
          final generator = MyRandomNumberGenerator();
          await tester.pumpWidget(MaterialApp(
            home: YellowScreen(generator: generator),
          ));

          final backButton = find.byIcon(Icons.arrow_back);
          expect(backButton, findsOneWidget);

          final randomButton = find.byWidgetPredicate((widget) {     // Найти кнопку с текстом "Случайное число"
            if (widget is ElevatedButton &&
                widget.child is Text &&
                (widget.child as Text).data == 'Случайное число') {
              return true;
            }
            return false;
          });

          final containerYSCRFinder = find.byWidgetPredicate(
                  (widget) => widget is Container
                      && widget.color == yellowColor);

          expect(containerYSCRFinder, findsOneWidget);          // проверить, что он один
          final containerWidgetGSCR = tester.widget<Container>(containerYSCRFinder);
          expect(containerWidgetGSCR.color, equals(yellowColor));// проверить, что его цвет желтый

          expect(randomButton, findsOneWidget);
          await tester.tap(randomButton);
          await tester.pumpAndSettle();

          final containerFinder = find.byKey(Key(Keys.randomNumberContainerKey));
          final containerWidgetNumber = tester.widget<Container>(containerFinder);
          final childWidget = containerWidgetNumber.child as Text;    // ожидаем как text

          final randomNumber = generator.generate();
          final color = randomNumber < 50 ? blueColor : Colors.black;

          expect(childWidget.style?.color, color);                    // проверяем цвет
          expect(containerWidgetNumber.alignment, equals(Alignment.center));

        });
  });
}
