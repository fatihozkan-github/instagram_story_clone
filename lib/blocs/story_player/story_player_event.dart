part of 'story_player_bloc.dart';

sealed class StoryPlayerEvent {}

class StoryPlayerEventInitial extends StoryPlayerEvent {
  final StoryDataModel storyDataModel;

  StoryPlayerEventInitial({required this.storyDataModel});
}

class StoryPlayerEventPlayerPlay extends StoryPlayerEvent {}
