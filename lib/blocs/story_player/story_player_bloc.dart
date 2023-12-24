import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import "../../data/models/story_data_model.dart";

part 'story_player_event.dart';
part 'story_player_state.dart';

class StoryPlayerBloc extends Bloc<StoryPlayerEvent, StoryPlayerState> {
  StoryPlayerBloc() : super(StoryPlayerStateInitial()) {
    on<StoryPlayerEventInitial>(_onInitialize);
    on<StoryPlayerEventPlayerPlay>(_onPlay);
  }

  CachedVideoPlayerController? _videoPlayerController;

  FutureOr<void> _onInitialize(
    StoryPlayerEventInitial event,
    Emitter<StoryPlayerState> emit,
  ) async {
    emit(StoryPlayerStateLoading());
    final storyData = event.storyDataModel;

    if (!storyData.isPhoto) {
      await _initializeVideoPlayer(storyData.url);
    }

    emit(StoryPlayerStatePlayerReady());
  }

  FutureOr<void> _onPlay(
    StoryPlayerEventPlayerPlay event,
    Emitter<StoryPlayerState> emit,
  ) async {
    await _videoPlayerController?.play();
    emit(
      StoryPlayerStatePlay(
        videoPlayerController: _videoPlayerController,
      ),
    );
  }

  Future<void> _initializeVideoPlayer(String mediaUrl) async {
    try {
      _videoPlayerController = CachedVideoPlayerController.network(
        mediaUrl,
      );
      _videoPlayerController?.addListener(() {
        if (isClosed) {
          _videoPlayerController?.dispose();
          _videoPlayerController = null;
        }
      });
      await _videoPlayerController?.initialize();
    } catch (e, s) {
      debugPrint("$e $s");
    }
  }
}
