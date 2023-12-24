import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_player/story_player_bloc.dart';
import 'package:instagram_story_clone/core/enums/enums.dart';
import 'package:instagram_story_clone/data/models/story_data_model.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../test_classes/fake_video_player_platform.dart';

void main() {
  late StoryDataModel mockStoryDataModel;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    VideoPlayerPlatform.instance = FakeVideoPlayerPlatform();

    mockStoryDataModel = const StoryDataModel(
      id: 0,
      url: "",
      storyMediaType: StoryMediaType.video,
    );
  });

  group("StoryPlayerBloc Tests", () {
    blocTest(
      "should emit nothing",
      build: () => StoryPlayerBloc(),
      expect: () => [],
    );

    blocTest(
      "should emit StoryPlayerStateLoading and StoryGroupStateReady on StoryGroupEventInitialize",
      build: () => StoryPlayerBloc(),
      act: (storyPlayerBloc) => storyPlayerBloc.add(
        StoryPlayerEventInitial(storyDataModel: mockStoryDataModel),
      ),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<StoryPlayerStateLoading>(),
        isA<StoryPlayerStatePlayerReady>(),
      ],
    );

    blocTest(
      "should emit StoryPlayerStateLoading, StoryGroupStateReady, and StoryPlayerStatePlay on StoryPlayerEventPlayerPlay",
      build: () => StoryPlayerBloc(),
      act: (storyPlayerBloc) {
        storyPlayerBloc.add(
          StoryPlayerEventInitial(storyDataModel: mockStoryDataModel),
        );
        storyPlayerBloc.add(StoryPlayerEventPlayerPlay());
      },
      expect: () => [
        isA<StoryPlayerStateLoading>(),
        isA<StoryPlayerStatePlay>(),
        isA<StoryPlayerStatePlayerReady>(),
      ],
    );
  });
}
