import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_group/story_group_bloc.dart';
import 'package:instagram_story_clone/blocs/story_page_view/story_page_view_bloc.dart';
import 'package:instagram_story_clone/blocs/story_progress/story_progress_bloc.dart';
import 'package:instagram_story_clone/presentation/components/story_group_view.dart';
import 'package:instagram_story_clone/presentation/components/story_progress_bar_item.dart';

import '../../test_classes/test_variables.dart';

class MockStoryPageViewBloc
    extends MockBloc<StoryPageViewEvent, StoryPageViewState>
    implements StoryPageViewBloc {
  @override
  List<int> get storyGroupHistoryIndexList => [0];
}

class MockStoryGroupBloc extends MockBloc<StoryGroupEvent, StoryGroupState>
    implements StoryGroupBloc {}

void main() {
  late StoryPageViewBloc mockStoryPageViewBloc;
  late StoryGroupBloc mockStoryGroupBloc;

  setUp(() {
    mockStoryPageViewBloc = MockStoryPageViewBloc()
      ..add(StoryPageViewEventInitialize());
    mockStoryGroupBloc = MockStoryGroupBloc()
      ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0));
  });

  tearDown(() {
    mockStoryPageViewBloc.close();
    mockStoryGroupBloc.close();
  });

  Future<void> pumpStoryGroupView(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => mockStoryPageViewBloc),
          BlocProvider(create: (_) => mockStoryGroupBloc),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return StoryGroupView(
                  groupIndex: 0,
                  initialPage: 0,
                  storyGroupModel: TestVariables.testStoryGroupModelList.first,
                  scaffoldState: Scaffold.of(context),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  group("TestVariables.testStoryGroupModelList Tests", () {
    test(
      "should verify that TestVariables.testStoryGroupModelList contains at least one element",
      () => expect(TestVariables.testStoryGroupModelList.isNotEmpty, true),
    );
  });

  group("StoryGroupView Tests", () {
    testWidgets("should build StoryGroupView", (widgetTester) async {
      whenListen(
        mockStoryGroupBloc,
        Stream.fromIterable([StoryGroupStateInitial()]),
        initialState: StoryGroupStateInitial(),
      );
      await pumpStoryGroupView(widgetTester);
      final widgetFinder = find.byType(StoryGroupView);
      expect(widgetFinder, findsOneWidget);
    });

    testWidgets("should build StoryGroupBloc child", (widgetTester) async {
      whenListen(
        mockStoryGroupBloc,
        Stream.fromIterable([StoryGroupStateInitial()]),
        initialState: StoryGroupStateInitial(),
      );
      await pumpStoryGroupView(widgetTester);
      final widgetFinder = find.byType(BlocProvider<StoryGroupBloc>);
      expect(widgetFinder, findsOneWidget);
    });

    testWidgets("should build StoryProgressBloc child", (widgetTester) async {
      whenListen(
        mockStoryGroupBloc,
        Stream.fromIterable([StoryGroupStateInitial()]),
        initialState: StoryGroupStateInitial(),
      );
      await pumpStoryGroupView(widgetTester);
      final widgetFinder = find.byType(BlocProvider<StoryProgressBloc>);
      expect(widgetFinder, findsOneWidget);
    });

    testWidgets(
      "should build StoryGroupBloc consumer child",
      (widgetTester) async {
        whenListen(
          mockStoryGroupBloc,
          Stream.fromIterable([StoryGroupStateInitial()]),
          initialState: StoryGroupStateInitial(),
        );
        await pumpStoryGroupView(widgetTester);
        final widgetFinder = find.byType(
          BlocConsumer<StoryGroupBloc, StoryGroupState>,
        );
        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build PageView while emitting StoryGroupStateReady",
      (widgetTester) async {
        whenListen(
          mockStoryPageViewBloc,
          Stream.fromIterable([
            StoryPageViewStateInitial(),
            StoryPageViewStateReady(
              pageController: PageController(),
              storyGroupList: [],
              storyGroupHistoryIndexList: [],
            ),
          ]),
          initialState: StoryPageViewStateInitial(),
        );
        whenListen(
          mockStoryGroupBloc,
          Stream.fromIterable([
            StoryGroupStateInitial(),
            StoryGroupStateReady(pageController: PageController()),
          ]),
          initialState: StoryGroupStateInitial(),
        );
        await pumpStoryGroupView(widgetTester);
        await widgetTester.pumpAndSettle();
        final widgetFinder = find.byType(PageView);
        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build PageView while emitting StoryGroupStateReady",
      (widgetTester) async {
        whenListen(
          mockStoryPageViewBloc,
          Stream.fromIterable([
            StoryPageViewStateInitial(),
            StoryPageViewStateReady(
              pageController: PageController(),
              storyGroupList: [],
              storyGroupHistoryIndexList: [],
            ),
          ]),
          initialState: StoryPageViewStateInitial(),
        );
        whenListen(
          mockStoryGroupBloc,
          Stream.fromIterable([
            StoryGroupStateInitial(),
            StoryGroupStateReady(pageController: PageController()),
          ]),
          initialState: StoryGroupStateInitial(),
        );
        await pumpStoryGroupView(widgetTester);
        await widgetTester.pumpAndSettle();
        final widgetFinder = find.byType(StoryProgressBarItem);
        expect(widgetFinder, findsAtLeastNWidgets(1));
      },
    );
  });
}
