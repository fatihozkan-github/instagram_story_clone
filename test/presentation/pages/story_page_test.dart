import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_page_view/story_page_view_bloc.dart';
import 'package:instagram_story_clone/presentation/pages/story_page.dart';

class MockStoryPageViewBloc
    extends MockBloc<StoryPageViewEvent, StoryPageViewState>
    implements StoryPageViewBloc {
  @override
  List<int> get storyGroupHistoryIndexList => [];
}

void main() {
  late StoryPageViewBloc mockStoryPageViewBloc;

  setUp(() {
    mockStoryPageViewBloc = MockStoryPageViewBloc()
      ..add(StoryPageViewEventInitialize());
  });

  tearDown(() {
    mockStoryPageViewBloc.close();
  });

  Future<void> pumpStoryPageView(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => mockStoryPageViewBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(body: StoryPageView()),
        ),
      ),
    );
  }

  group("StoryPageView Tests", () {
    testWidgets("should build StoryPageView", (widgetTester) async {
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
      await pumpStoryPageView(widgetTester);
      final widgetFinder = find.byType(StoryPageView);
      expect(widgetFinder, findsOneWidget);
    });
  });
}
