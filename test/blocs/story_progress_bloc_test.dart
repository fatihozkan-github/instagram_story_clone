import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/blocs/story_progress/story_progress_bloc.dart';

void main() {
  group("StoryProgressBloc Tests", () {
    blocTest(
      "should emit nothing",
      build: () => StoryProgressBloc(0),
      expect: () => [],
    );

    blocTest(
      "should emit StoryProgressStateRefresh on StoryProgressEventRefresh",
      build: () => StoryProgressBloc(0),
      act: (bloc) => bloc.add(StoryProgressEventRefresh(newProgressIndex: 0)),
      expect: () => [
        isA<StoryProgressStateRefresh>(),
      ],
    );
  });
}
