part of 'story_progress_bloc.dart';

sealed class StoryProgressEvent {}

class StoryProgressEventRefresh extends StoryProgressEvent {
  final int newProgressIndex;

  StoryProgressEventRefresh({
    required this.newProgressIndex,
  });
}
