part of 'story_group_bloc.dart';

sealed class StoryGroupEvent {}

class StoryGroupEventInitialize extends StoryGroupEvent {
  final int itemCount;
  final int initialPage;

  StoryGroupEventInitialize({
    required this.itemCount,
    required this.initialPage,
  });
}

class StoryGroupEventScreenTapped extends StoryGroupEvent {
  final StoryScreenTapRegion storyScreenTapRegion;

  StoryGroupEventScreenTapped({required this.storyScreenTapRegion});
}

class StoryGroupEventStoryPlayerPlay extends StoryGroupEvent {
  final Duration duration;
  final int newPage;

  StoryGroupEventStoryPlayerPlay({
    required this.duration,
    required this.newPage,
  });
}

class StoryGroupEventScreenStoryStart extends StoryGroupEvent {
  final int newProgressIndex;
  final Duration duration;
  final ScaffoldState scaffoldState;

  StoryGroupEventScreenStoryStart({
    required this.newProgressIndex,
    required this.duration,
    required this.scaffoldState,
  });
}

class StoryGroupEventScreenStoryPaused extends StoryGroupEvent {
  final int storyIndex;

  StoryGroupEventScreenStoryPaused({required this.storyIndex});
}

class StoryGroupEventScreenStoryResumed extends StoryGroupEvent {}
