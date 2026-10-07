import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:getx/main.dart';

void main() {
  testWidgets('bottom navigation switches between the three destinations', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('GetxStore'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);

    await tester.tap(find.text('Categories'));
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );

    await tester.tap(find.text('Account'));
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
    expect(find.text('Account'), findsNWidgets(2));

    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      0,
    );
  });
}
