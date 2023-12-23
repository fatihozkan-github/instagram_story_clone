import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/enums/enums.dart';
import '../models/story_data_model.dart';
import '../models/story_group_model.dart';

class StoryService {
  final _random = Random();

  Future<List<StoryGroupModel>> fetchNewStories() async {
    try {
      List<StoryGroupModel> dataList = [];

      for (int i = 0; i < _random.nextInt(10) + 1; i++) {
        dataList.add(
          StoryGroupModel(
            id: i,
            name: 'User Name ${i + 1}',
            subtitle: 'Added ...',
            timestamp: '${i + 1}h',
            storyDataList: _createRandomStoryDataList(),
          ),
        );
      }
      return dataList;
    } catch (e, s) {
      debugPrint("$e $s");
      return [];
    }
  }

  List<StoryDataModel> _createRandomStoryDataList() {
    List<StoryDataModel> returnList = [];
    try {
      for (int j = 0; j < _random.nextInt(10) + 1; j++) {
        final isPhoto = _random.nextBool();
        returnList.add(
          StoryDataModel(
            id: j,
            url: isPhoto
                ? "https://picsum.photos/100$j/110$j"
                : "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
            storyMediaType:
                isPhoto ? StoryMediaType.photo : StoryMediaType.video,
          ),
        );
      }
      return returnList;
    } catch (e, s) {
      debugPrint("$e $s");
      return [];
    }
  }
}
