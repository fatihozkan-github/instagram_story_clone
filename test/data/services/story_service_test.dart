import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/data/models/story_group_model.dart';
import 'package:instagram_story_clone/data/services/media_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_classes/test_variables.dart';

class MockStoryService extends Mock implements StoryService {}

void main() {
  late MockStoryService mockStoryService;

  setUp(() {
    mockStoryService = MockStoryService();
  });

  group("StoryService Tests", () {
    test(
      "should return List<StoryGroupModel> type on fetchNewStories call",
      () async {
        when(() => mockStoryService.fetchNewStories()).thenAnswer(
          (_) async => Future.value(TestVariables.testStoryGroupModelList),
        );

        expect(
          await mockStoryService.fetchNewStories(),
          isA<List<StoryGroupModel>>(),
        );
      },
    );

    test(
      "should return testStoryGroupModelList on fetchNewStories call",
      () async {
        when(() => mockStoryService.fetchNewStories()).thenAnswer(
          (_) => Future.value(TestVariables.testStoryGroupModelList),
        );

        expect(
          await mockStoryService.fetchNewStories(),
          TestVariables.testStoryGroupModelList,
        );
      },
    );

    test(
      "should throw an error on failed fetchNewStories call",
      () async {
        when(() => mockStoryService.fetchNewStories()).thenThrow(Error());

        throwsA(Error());
      },
    );
  });
}
