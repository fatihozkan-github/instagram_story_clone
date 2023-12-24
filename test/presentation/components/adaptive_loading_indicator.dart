import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/presentation/components/adaptive_loading_indicator.dart';

void main() {
  group("AdaptiveLoadingIndicator Widget Tests ", () {
    testWidgets(
      "should build loading indicator for android",
      (widgetTester) async {
        await widgetTester.pumpWidget(const AdaptiveLoadingIndicator());
        final widgetFinder = find.byType(AdaptiveLoadingIndicator);

        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build loading indicator for iOS",
      (widgetTester) async {
        await widgetTester.pumpWidget(
          Theme(
            data: ThemeData(platform: TargetPlatform.iOS),
            child: const AdaptiveLoadingIndicator(),
          ),
        );
        final widgetFinder = find.byType(AdaptiveLoadingIndicator);

        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build CircularProgressIndicator child for android",
      (widgetTester) async {
        const adaptiveLoadingIndicator = AdaptiveLoadingIndicator();
        await widgetTester.pumpWidget(adaptiveLoadingIndicator);
        final widgetFinder = find.descendant(
          of: find.byWidget(adaptiveLoadingIndicator),
          matching: find.byType(CircularProgressIndicator),
        );

        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build CupertinoActivityIndicator child for iOS",
      (widgetTester) async {
        final themedAdaptiveLoadingIndicator = Theme(
          data: ThemeData(platform: TargetPlatform.iOS),
          child: const AdaptiveLoadingIndicator(),
        );
        await widgetTester.pumpWidget(themedAdaptiveLoadingIndicator);
        final widgetFinder = find.descendant(
          of: find.byWidget(themedAdaptiveLoadingIndicator),
          matching: find.byType(CupertinoActivityIndicator),
        );

        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build CupertinoActivityIndicator for non-mobile platform",
      (widgetTester) async {
        final themedAdaptiveLoadingIndicator = Theme(
          data: ThemeData(platform: TargetPlatform.linux),
          child: const AdaptiveLoadingIndicator(),
        );
        await widgetTester.pumpWidget(themedAdaptiveLoadingIndicator);
        final widgetFinder = find.descendant(
          of: find.byWidget(themedAdaptiveLoadingIndicator),
          matching: find.byType(CupertinoActivityIndicator),
        );

        expect(widgetFinder, findsOneWidget);
      },
    );
  });
}
