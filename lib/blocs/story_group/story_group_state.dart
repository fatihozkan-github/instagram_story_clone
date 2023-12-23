part of 'story_group_bloc.dart';

sealed class StoryGroupState {}

class StoryGroupStateInitial extends StoryGroupState {}

class StoryGroupStateReady extends StoryGroupState {
  final PageController cont;

  StoryGroupStateReady({required this.cont});
}

class StoryGroupStatePageChange extends StoryGroupState {
  final int newPage;

  StoryGroupStatePageChange({required this.newPage});
}

class StoryGroupStateSendNavigationNotification extends StoryGroupState {
  final NavigationAction navigationAction;

  StoryGroupStateSendNavigationNotification({required this.navigationAction});
}

class StoryGroupStateStoryPlayerReady extends StoryGroupState {
  final Duration duration;
  final int newPage;

  StoryGroupStateStoryPlayerReady({
    required this.duration,
    required this.newPage,
  });
}

class StoryGroupStateScreenStoryStart extends StoryGroupState {
  final int newPage;

  StoryGroupStateScreenStoryStart({required this.newPage});
}

class StoryGroupStateScreenStoryPaused extends StoryGroupState {
  final int storyIndex;

  StoryGroupStateScreenStoryPaused({required this.storyIndex});
}

class StoryGroupStateScreenStoryResumed extends StoryGroupState {}
