part of 'story_progress_bloc.dart';

sealed class StoryProgressState {
  final int currentProgressIndex;

  StoryProgressState({required this.currentProgressIndex});
}

class StoryProgressStateInitial extends StoryProgressState {
  StoryProgressStateInitial({required super.currentProgressIndex});
}

class StoryProgressStateRefresh extends StoryProgressState {
  StoryProgressStateRefresh({required super.currentProgressIndex});
}
