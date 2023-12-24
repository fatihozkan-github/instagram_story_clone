import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_story_clone/core/enums/enums.dart';
import 'package:instagram_story_clone/data/models/story_data_model.dart';

void main() {
  group("StoryDataModel Tests", () {
    group("StoryDataModel StoryMediaType.photo Tests", () {
      test("should return true on isPhoto getter call", () {
        const storyDataModel = StoryDataModel(
          id: 0,
          url: "",
          storyMediaType: StoryMediaType.photo,
        );

        expect(storyDataModel.isPhoto, true);
      });
      test("should return false on not isPhoto getter call", () {
        const storyDataModel = StoryDataModel(
          id: 0,
          url: "",
          storyMediaType: StoryMediaType.photo,
        );

        expect(!storyDataModel.isPhoto, false);
      });
    });

    group("StoryDataModel StoryMediaType.video Tests", () {
      test("should return false on isPhoto getter call", () {
        const storyDataModel = StoryDataModel(
          id: 0,
          url: "",
          storyMediaType: StoryMediaType.video,
        );

        expect(storyDataModel.isPhoto, false);
      });

      test("should return true on not isPhoto getter call", () {
        const storyDataModel = StoryDataModel(
          id: 0,
          url: "",
          storyMediaType: StoryMediaType.video,
        );

        expect(!storyDataModel.isPhoto, true);
      });
    });
  });
}
