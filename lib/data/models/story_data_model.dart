import '../../core/enums/enums.dart';

class StoryDataModel {
  final int id;
  final String url;
  final StoryMediaType storyMediaType;

  const StoryDataModel({
    required this.id,
    required this.url,
    required this.storyMediaType,
  });

  bool get isPhoto => storyMediaType == StoryMediaType.photo;
}
