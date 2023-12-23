part of 'story_page_view_bloc.dart';

sealed class StoryPageViewState {}

class StoryPageViewStateInitial extends StoryPageViewState {}

class StoryPageViewStateReady extends StoryPageViewState {
  final PageController pageController;
  final List<StoryGroupModel> storyGroupList;
  final List<int> storyGroupHistoryIndexList;

  StoryPageViewStateReady({
    required this.pageController,
    required this.storyGroupList,
    required this.storyGroupHistoryIndexList,
  });
}

class StoryPageViewStateDeltaUpdate extends StoryPageViewState {
  final double delta;

  StoryPageViewStateDeltaUpdate({required this.delta});
}

class StoryPageViewStatePageChanged extends StoryPageViewState {}

class StoryPageViewStateDisposed extends StoryPageViewState {}
