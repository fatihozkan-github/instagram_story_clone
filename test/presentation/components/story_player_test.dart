import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_group/story_group_bloc.dart';
import 'package:instagram_story_clone/blocs/story_player/story_player_bloc.dart';
import 'package:instagram_story_clone/core/enums/enums.dart';
import 'package:instagram_story_clone/presentation/components/adaptive_loading_indicator.dart';
import 'package:instagram_story_clone/presentation/components/story_player.dart';
import 'package:video_player/video_player.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../test_classes/fake_video_player_platform.dart';
import '../../test_classes/test_variables.dart';

class MockStoryGroupBloc extends MockBloc<StoryGroupEvent, StoryGroupState>
    implements StoryGroupBloc {}

class MockStoryPlayerBloc extends MockBloc<StoryPlayerEvent, StoryPlayerState>
    implements StoryPlayerBloc {}

void main() {
  late StoryGroupBloc mockStoryGroupBloc;
  late StoryPlayerBloc mockStoryPlayerBloc;
  late FakeVideoPlayerPlatform fakeVideoPlayerPlatform;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    fakeVideoPlayerPlatform = FakeVideoPlayerPlatform();
    VideoPlayerPlatform.instance = fakeVideoPlayerPlatform;
    mockStoryGroupBloc = MockStoryGroupBloc();
    mockStoryPlayerBloc = MockStoryPlayerBloc();
  });

  tearDown(() {
    mockStoryGroupBloc.close();
    mockStoryPlayerBloc.close();
  });

  Future<void> pumpStoryPlayerViewWithPhoto(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => mockStoryGroupBloc
              ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0)),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) => mockStoryPlayerBloc
                  ..add(
                    StoryPlayerEventInitial(
                      storyDataModel: TestVariables
                          .testStoryGroupModelList.first.storyDataList.first,
                    ),
                  ),
                child: StoryPlayer(
                  storyIndex: 0,
                  totalStoryCount: 0,
                  storyDataModel: TestVariables
                      .testStoryGroupModelList.first.storyDataList.first,
                  onTap: (StoryScreenTapRegion storyScreenTapRegion) {},
                  isFirstGroup: true,
                  isLastGroup: true,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> pumpStoryPlayerViewWithVideo(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => mockStoryGroupBloc
              ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0)),
          ),
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            home: Scaffold(
              body: BlocProvider(
                create: (_) => mockStoryPlayerBloc
                  ..add(
                    StoryPlayerEventInitial(
                      storyDataModel: TestVariables
                          .testStoryGroupModelList.first.storyDataList.last,
                    ),
                  ),
                child: StoryPlayer(
                  storyIndex: 0,
                  totalStoryCount: 0,
                  storyDataModel: TestVariables
                      .testStoryGroupModelList.first.storyDataList.last,
                  onTap: (StoryScreenTapRegion storyScreenTapRegion) {},
                  isFirstGroup: true,
                  isLastGroup: true,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  group("TestVariables.testStoryGroupModelList Tests", () {
    test(
      "should verify that TestVariables.testStoryGroupModelList contains at least one element",
      () => expect(
        TestVariables.testStoryGroupModelList.first.storyDataList.isNotEmpty,
        true,
      ),
    );

    test(
      "should verify that TestVariables.testStoryGroupModelList.first isPhoto true",
      () => expect(
        TestVariables.testStoryGroupModelList.first.storyDataList.first.isPhoto,
        true,
      ),
    );

    test(
      "should verify that TestVariables.testStoryGroupModelList.last isPhoto false",
      () => expect(
        TestVariables.testStoryGroupModelList.first.storyDataList.last.isPhoto,
        false,
      ),
    );
  });

  group("StoryPlayer Tests", () {
    testWidgets("should build StoryPlayer", (widgetTester) async {
      whenListen(
        mockStoryPlayerBloc,
        Stream.fromIterable([
          StoryPlayerStateLoading(),
          StoryPlayerStatePlayerReady(),
        ]),
        initialState: StoryPlayerStateInitial(),
      );
      await pumpStoryPlayerViewWithPhoto(widgetTester);

      final widgetFinder = find.byType(StoryPlayer);
      expect(widgetFinder, findsOneWidget);
    });

    testWidgets(
      "should build StoryPlayer loading UI while StoryPlayerStateInitial",
      (widgetTester) async {
        whenListen(
          mockStoryPlayerBloc,
          Stream.fromIterable([StoryPlayerStateInitial()]),
          initialState: StoryPlayerStateInitial(),
        );
        await pumpStoryPlayerViewWithPhoto(widgetTester);

        final widgetFinder = find.byType(AdaptiveLoadingIndicator);
        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build StoryPlayer loading UI while StoryPlayerStatePlayerReady",
      (widgetTester) async {
        whenListen(
          mockStoryPlayerBloc,
          Stream.fromIterable([StoryPlayerStatePlayerReady()]),
          initialState: StoryPlayerStateInitial(),
        );
        await pumpStoryPlayerViewWithPhoto(widgetTester);

        final widgetFinder = find.byType(AdaptiveLoadingIndicator);
        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets(
      "should build StoryPlayer loading UI while StoryPlayerStateLoading",
      (widgetTester) async {
        whenListen(
          mockStoryPlayerBloc,
          Stream.fromIterable([StoryPlayerStateLoading()]),
          initialState: StoryPlayerStateInitial(),
        );
        await pumpStoryPlayerViewWithPhoto(widgetTester);

        final widgetFinder = find.byType(AdaptiveLoadingIndicator);
        expect(widgetFinder, findsOneWidget);
      },
    );

    testWidgets("should build StoryPlayer with image", (widgetTester) async {
      whenListen(
        mockStoryPlayerBloc,
        Stream.fromIterable([
          StoryPlayerStateLoading(),
          StoryPlayerStatePlayerReady(),
          StoryPlayerStatePlay(
            videoPlayerController: null,
          ),
        ]),
        initialState: StoryPlayerStateInitial(),
      );
      await pumpStoryPlayerViewWithPhoto(widgetTester);
      mockStoryPlayerBloc.add(StoryPlayerEventPlayerPlay());
      await widgetTester.pumpAndSettle();
      final widgetFinder = find.byType(Image);
      expect(widgetFinder, findsOneWidget);
    });

    testWidgets("should build StoryPlayer with video", (widgetTester) async {
      final fakeVideoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('https://127.0.0.1'),
      );
      await fakeVideoPlayerController.initialize();

      whenListen(
        mockStoryPlayerBloc,
        Stream.fromIterable([
          StoryPlayerStateLoading(),
          StoryPlayerStatePlayerReady(),
          StoryPlayerStatePlay(
            videoPlayerController: fakeVideoPlayerController,
          ),
        ]),
        initialState: StoryPlayerStateInitial(),
      );

      await pumpStoryPlayerViewWithVideo(widgetTester);
      mockStoryPlayerBloc.add(StoryPlayerEventPlayerPlay());
      await widgetTester.pumpAndSettle();
      final widgetFinder = find.byType(VideoPlayer);
      expect(widgetFinder, findsOneWidget);
    });
  });
}
