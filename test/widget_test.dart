import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:getx/app/routes/app_routes.dart';
import 'package:getx/app/di/service_locator.dart';
import 'package:getx/main.dart';

void main() {
  late Directory hiveDirectory;

  setUpAll(() async {
    hiveDirectory = Directory.systemTemp.createTempSync('getx_store_test_');
    Hive.init(hiveDirectory.path);
    final box = await Hive.openBox<String>('getx_store');
    configureDependencies(box);
  });

  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });

  testWidgets('bottom navigation switches between home and categories', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("let's shop!"), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(Get.currentRoute, AppRoutes.home);

    await tester.tap(find.text('Categories'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(Get.currentRoute, AppRoutes.categories);
  });
}
