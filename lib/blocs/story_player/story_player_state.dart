part of 'story_player_bloc.dart';

sealed class StoryPlayerState {}

class StoryPlayerStateInitial extends StoryPlayerState {}

class StoryPlayerStateLoading extends StoryPlayerState {}

class StoryPlayerStatePlayerReady extends StoryPlayerState {}

class StoryPlayerStatePlay extends StoryPlayerState {
  final VideoPlayerController? videoPlayerController;

  StoryPlayerStatePlay({required this.videoPlayerController});
}
