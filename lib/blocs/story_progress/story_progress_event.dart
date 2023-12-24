part of 'story_progress_bloc.dart';

sealed class StoryProgressEvent {}

class StoryProgressEventInitial extends StoryProgressEvent {
  final int newProgressIndex;

  StoryProgressEventInitial({
    required this.newProgressIndex,
  });
}

class StoryProgressEventRefresh extends StoryProgressEvent {
  final int newProgressIndex;

  StoryProgressEventRefresh({
    required this.newProgressIndex,
  });
}
