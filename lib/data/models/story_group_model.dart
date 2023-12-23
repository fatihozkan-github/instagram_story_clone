import 'story_data_model.dart';

class StoryGroupModel {
  final int id;
  final String name;
  final String subtitle;
  final String timestamp;
  final List<StoryDataModel> storyDataList;

  const StoryGroupModel({
    this.id = -1,
    required this.name,
    required this.subtitle,
    required this.timestamp,
    required this.storyDataList,
  });
}
