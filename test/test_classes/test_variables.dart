import 'package:instagram_story_clone/core/enums/enums.dart';
import 'package:instagram_story_clone/data/models/story_data_model.dart';
import 'package:instagram_story_clone/data/models/story_group_model.dart';

class TestVariables {
  static const List<StoryGroupModel> testStoryGroupModelList = [
    StoryGroupModel(
      id: 0,
      name: "User Name 1",
      subtitle: "Added ...",
      timestamp: "1h",
      storyDataList: [
        StoryDataModel(
          id: 0,
          url: "https://picsum.photos/1000/1100",
          storyMediaType: StoryMediaType.photo,
        ),
        StoryDataModel(
          id: 1,
          url:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          storyMediaType: StoryMediaType.video,
        ),
        StoryDataModel(
          id: 2,
          url:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          storyMediaType: StoryMediaType.video,
        ),
        StoryDataModel(
          id: 3,
          url:
              " https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          storyMediaType: StoryMediaType.video,
        ),
        StoryDataModel(
          id: 4,
          url:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          storyMediaType: StoryMediaType.video,
        )
      ],
    )
  ];
}
