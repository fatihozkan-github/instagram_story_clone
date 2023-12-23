import '../models/story_group_model.dart';
import '../services/media_service.dart';

class StoryRepository {
  final _storyService = StoryService();

  Future<List<StoryGroupModel>> fetchNewStories() {
    return _storyService.fetchNewStories();
  }
}
