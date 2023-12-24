import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_group/story_group_bloc.dart';

void main() {
  group("StoryGroupBloc Tests", () {
    blocTest(
      "should emit nothing",
      build: () => StoryGroupBloc(),
      expect: () => [],
    );

    blocTest(
      "should emit StoryGroupStateReady on StoryGroupEventInitialize",
      build: () => StoryGroupBloc(),
      act: (storyGroupBloc) => storyGroupBloc.add(
        StoryGroupEventInitialize(
          itemCount: 0,
          initialPage: 0,
        ),
      ),
      expect: () => [isA<StoryGroupStateReady>()],
    );

    /// This will throw the same error at [StoryGroupPageView] test.
    // blocTest(
    //   "should emit StoryGroupStateReady on StoryGroupEventInitialize",
    //   build: () => StoryGroupBloc(),
    //   act: (storyGroupBloc) => storyGroupBloc
    //     ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0))
    //     ..add(
    //       StoryGroupEventScreenTapped(
    //         storyScreenTapRegion: StoryScreenTapRegion.right,
    //       ),
    //     ),
    //   expect: () => [isA<StoryGroupStatePageChange>()],
    // );

    blocTest(
      "should emit StoryGroupStateStoryPlayerReady on StoryGroupEventStoryPlayerPlay",
      build: () => StoryGroupBloc(),
      act: (storyGroupBloc) => storyGroupBloc
        ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0))
        ..add(
          StoryGroupEventStoryPlayerPlay(duration: Duration.zero, newPage: 0),
        ),
      expect: () => [
        isA<StoryGroupStateReady>(),
        isA<StoryGroupStateStoryPlayerReady>(),
      ],
    );

    /// Since [StoryGroupBloc] has an [AnimationController] in it, the behavior of
    /// [AnimationController] is not testable without tree building.
    // blocTest(
    //       "should emit StoryGroupStateScreenStoryStart on StoryGroupEventScreenStoryStart",
    //       build: () => StoryGroupBloc(),
    //       act: (storyGroupBloc) => storyGroupBloc
    //         ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0))
    //         ..add(
    //           StoryGroupEventScreenStoryStart(
    //             duration: Duration.zero,
    //             newProgressIndex: 0,
    //             scaffoldState: null,
    //           ),
    //         ),
    //       expect: () => [
    //         isA<StoryGroupStateReady>(),
    //         isA<StoryGroupStateScreenStoryStart>(),
    //       ],
    //     );

    blocTest(
      "should emit StoryGroupStateScreenStoryPaused on StoryGroupEventScreenStoryPaused",
      build: () => StoryGroupBloc(),
      act: (storyGroupBloc) => storyGroupBloc
        ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0))
        ..add(StoryGroupEventScreenStoryPaused(storyIndex: 0)),
      expect: () => [
        isA<StoryGroupStateReady>(),
        isA<StoryGroupStateScreenStoryPaused>(),
      ],
    );

    blocTest(
      "should emit StoryGroupStateScreenStoryResumed on StoryGroupEventScreenStoryResumed",
      build: () => StoryGroupBloc(),
      act: (storyGroupBloc) => storyGroupBloc
        ..add(StoryGroupEventInitialize(itemCount: 0, initialPage: 0))
        ..add(StoryGroupEventScreenStoryResumed()),
      expect: () => [
        isA<StoryGroupStateReady>(),
        isA<StoryGroupStateScreenStoryResumed>(),
      ],
    );
  });
}
