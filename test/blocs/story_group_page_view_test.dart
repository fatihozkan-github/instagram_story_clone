import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_page_view/story_page_view_bloc.dart';

void main() {
  group("StoryPageViewBloc Tests", () {
    blocTest(
      "should emit nothing",
      build: () => StoryPageViewBloc(),
      expect: () => [],
    );

    blocTest(
      "should emit StoryPageViewEventInitialize on StoryPageViewStateReady",
      build: () => StoryPageViewBloc(),
      act: (bloc) => bloc.add(StoryPageViewEventInitialize()),
      expect: () => [isA<StoryPageViewStateReady>()],
    );

    blocTest(
      "should emit StoryPageViewStateDeltaUpdate on StoryPageViewEventDeltaUpdate",
      build: () => StoryPageViewBloc(),
      act: (bloc) => bloc
        ..add(StoryPageViewEventInitialize())
        ..add(StoryPageViewEventDeltaUpdate(delta: 0)),
      expect: () => [
        isA<StoryPageViewStateReady>(),
        isA<StoryPageViewStateDeltaUpdate>(),
      ],
    );

    blocTest(
      "should not emit new state on StoryPageViewEventUpdateHistory",
      build: () => StoryPageViewBloc(),
      act: (bloc) => bloc
        ..add(StoryPageViewEventInitialize())
        ..add(
          StoryPageViewEventUpdateHistory(groupIndex: 0, newInitialPage: 0),
        ),
      expect: () => [isA<StoryPageViewStateReady>()],
    );

    /// All methods using [StoryPageViewBloc._pageController]'s methods will
    /// fail because of the reasons mentioned in [StoryPageViewBloc].
    ///
    /// Uncommenting the [blocTest] below allows one to observe the underlying
    /// problem.
    // blocTest(
    //   "should StoryPageViewStatePageChanged emit on StoryPageViewEventNavigate",
    //   build: () => StoryPageViewBloc(),
    //   act: (bloc) => bloc
    //     ..add(StoryPageViewEventInitialize())
    //     ..add(
    //       StoryPageViewEventNavigate(navigationAction: NavigationAction.push),
    //     ),
    //   expect: () => [
    //     isA<StoryPageViewStateReady>(),
    //     isA<StoryPageViewStatePageChanged>(),
    //   ],
    // );
  });
}
