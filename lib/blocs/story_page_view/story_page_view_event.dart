part of 'story_page_view_bloc.dart';

sealed class StoryPageViewEvent {}

class StoryPageViewEventInitialize extends StoryPageViewEvent {}

class StoryPageViewEventDeltaUpdate extends StoryPageViewEvent {
  final double delta;

  StoryPageViewEventDeltaUpdate({required this.delta});
}

class StoryPageViewEventNavigate extends StoryPageViewEvent {
  final NavigationAction navigationAction;

  StoryPageViewEventNavigate({required this.navigationAction});
}

class StoryPageViewEventUpdateHistory extends StoryPageViewEvent {
  final int groupIndex;
  final int newInitialPage;

  StoryPageViewEventUpdateHistory({
    required this.groupIndex,
    required this.newInitialPage,
  });
}

class StoryPageViewEventDispose extends StoryPageViewEvent {}
