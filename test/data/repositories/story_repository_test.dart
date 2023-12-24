import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/data/models/story_group_model.dart';
import 'package:instagram_story_clone/data/repositories/story_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_classes/test_variables.dart';

class MockStoryRepository extends Mock implements StoryRepository {}

void main() {
  late MockStoryRepository mockStoryRepository;

  setUp(() {
    mockStoryRepository = MockStoryRepository();
  });

  group("StoryRepository Tests", () {
    test(
      "should return List<StoryGroupModel> type on fetchNewStories call",
      () async {
        when(() => mockStoryRepository.fetchNewStories()).thenAnswer(
          (_) => Future.value(TestVariables.testStoryGroupModelList),
        );

        expect(
          await mockStoryRepository.fetchNewStories(),
          isA<List<StoryGroupModel>>(),
        );
      },
    );

    test(
      "should return testStoryGroupModelList on fetchNewStories call",
      () async {
        when(() => mockStoryRepository.fetchNewStories()).thenAnswer(
          (_) => Future.value(TestVariables.testStoryGroupModelList),
        );

        expect(
          await mockStoryRepository.fetchNewStories(),
          TestVariables.testStoryGroupModelList,
        );
      },
    );

    test(
      "should throw an error on failed fetchNewStories call",
      () async {
        when(() => mockStoryRepository.fetchNewStories()).thenThrow(Error());

        throwsA(Error());
      },
    );
  });
}
