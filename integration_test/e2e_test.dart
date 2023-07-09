import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/green_screen.dart';
import 'package:test_task_flutter/home_screen.dart';
import 'package:test_task_flutter/keys.dart';
import 'package:test_task_flutter/main.dart';
import 'package:test_task_flutter/yellow_screen.dart';

void main() {

  group('Widget tests group', () {
    testWidgets(
      'Test the button and check result event of push the yellow button and green button',
      (tester) async {
        await tester.pumpWidget(MyApp());
        await tester.pumpAndSettle();
        await tester.pump(Duration(seconds: 2));              // дождаться завершения анимации

        widgetPredicateGr(Widget widgetGB) =>
            widgetGB is ElevatedButton &&
            widgetGB.child is Text &&
            (widgetGB.child as Text).data == 'зеленый';

        final widgetGrButton = tester                         // найти зеленую кнопку
            .widget<ElevatedButton>(find.byWidgetPredicate(widgetPredicateGr));

        // тапнуть на “зеленый” - должен открыться экран с белой надписью “зеленый экран” и зеленым фоном

        await tester.tap(find.byWidget(widgetGrButton));    // нажать зеленую кнопку
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsNothing);      // не нашел домашнего экрана
        expect(find.byType(GreenScreen), findsOneWidget);   // нашел зеленый экран

        final appBarFinder = find.ancestor(
          of: find.text('Зеленый экран'),
          matching: find.byType(AppBar),
        );
        expect(appBarFinder, findsOneWidget);               // appBar зеленого экрана найден

        final textFinderGS = find.descendant(
          of: find.byType(Container),
          matching: find.text('Зеленый экран'),
        );

        final textWidgetGScreen = tester.widget(textFinderGS) as Text;
        expect(textWidgetGScreen.style?.color, Colors.white);  // текст "зеленый экран" найден

        final containerGSCRFinder = find.byType(Container);    // определить контейнер экрана с цветом
        final containerWidgetGSCR = tester.widget<Container>(containerGSCRFinder);

        expect(containerGSCRFinder, findsOneWidget);          // проверить, что он один
        expect(containerWidgetGSCR.color, equals(greenColor));// проверить, что его цвет зеленый

        // тапнуть кнопку назад - должны попасть на стартовый экран

        final backButton = find.byIcon(Icons.arrow_back);      // кнопка назад
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);      // найден домашний экран

        widgetPredicateYellow(Widget widgetYB) =>
            widgetYB is ElevatedButton &&
            widgetYB.child is Text &&
            (widgetYB.child as Text).data == 'желтый';

        final widgetYellowButton = tester.widget<ElevatedButton>(
            find.byWidgetPredicate(widgetPredicateYellow));

        // тапнуть на “желтый” - должен открыться экран с кнопкой “случайное число”, текст в центре экрана не отображается

        await tester.tap(find.byWidget(widgetYellowButton));  // переход на желтый экран
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsNothing);        // не найден домашний экран
        expect(find.byType(YellowScreen), findsOneWidget);    // найден желтый экран

        final appBarFinderYscr = find.ancestor(
          of: find.text('Желтый экран'),
          matching: find.byType(AppBar),
        );

        expect(appBarFinderYscr, findsOneWidget);

        final randomButton = find.byWidgetPredicate((widget) {     // Найти кнопку с текстом "Случайное число"
          if (widget is ElevatedButton &&
              widget.child is Text &&
              (widget.child as Text).data == 'Случайное число') {
            return true;
          }
          return false;
        });

        // Кнопка рандома найдена, число не должно отображаться

        expect(randomButton, findsOneWidget);                     // найдена кнопка рандома
        final containerFinder = find.byKey(Key(Keys.randomNumberContainerKey)); // контейнер для генерации
        final containerWidget = tester.widget(containerFinder);
        final containerChild =
            (containerWidget as Container).child;                 // получаем потомка контейнера

         // Проверка, что containerChild является SizedBox.shrink это значит вернулся NULL
        expect(containerChild.runtimeType, SizedBox);

        // тапнуть кнопку “случайное число” - отображается надпись с числом от 0 до 99 в центре экрана

        await tester.tap(randomButton);
        await tester.pumpAndSettle();

        /////////////происходит генерация случайного числа/////////////

        final containerWidgetNumber = tester.widget<Container>(containerFinder);
        final childWidget = containerWidgetNumber.child as Text; // теперь ожидаем как text

        expect(childWidget.data, isNotEmpty);                    // проверяем, что значение не пустое
        expect(containerWidgetNumber.alignment, equals(Alignment.center)); // Проверка выравнивания на центр

        // тапнуть кнопку назад - должны попасть на стартовый экран
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        expect(find.byType(HomeScreen), findsOneWidget);        // найден домашний экран

      },
    );
  });
}