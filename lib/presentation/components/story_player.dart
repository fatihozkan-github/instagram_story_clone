import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/story_group/story_group_bloc.dart';
import '../../blocs/story_player/story_player_bloc.dart';
import '../../core/constants/story_constants.dart';
import '../../core/constants/string_constants.dart';
import '../../core/enums/enums.dart';
import '../../core/typedefs/typedefs.dart';
import '../../data/models/story_data_model.dart';
import 'adaptive_loading_indicator.dart';

class StoryPlayer extends StatelessWidget {
  final int storyIndex;
  final int totalStoryCount;
  final bool isFirstGroup;
  final bool isLastGroup;
  final StoryDataModel storyDataModel;
  final OnScreenTapped onTap;

  const StoryPlayer({
    super.key,
    required this.storyIndex,
    required this.totalStoryCount,
    required this.isFirstGroup,
    required this.isLastGroup,
    required this.storyDataModel,
    required this.onTap,
  });

  void _listenStoryPlayerBloc(BuildContext context, StoryPlayerState state) {
    if (state is StoryPlayerStatePlayerReady) {
      BlocProvider.of<StoryPlayerBloc>(context).add(
        StoryPlayerEventPlayerPlay(),
      );
    } else if (state is StoryPlayerStatePlay) {
      BlocProvider.of<StoryGroupBloc>(context).add(
        StoryGroupEventStoryPlayerPlay(
          duration: state.videoPlayerController?.value.duration ??
              StoryConstants.defaultStoryDuration,
          newPage: storyIndex,
        ),
      );
    }
  }

  void _onLongPress(
    BuildContext context,
    StoryPlayerStatePlay state,
  ) async {
    await state.videoPlayerController?.pause();
    if (context.mounted) {
      BlocProvider.of<StoryGroupBloc>(context).add(
        StoryGroupEventScreenStoryPaused(storyIndex: storyIndex),
      );
    }
  }

  void _onLongPressDown(
    BuildContext context,
    StoryPlayerStatePlay state,
  ) async {
    await state.videoPlayerController?.play();
    if (context.mounted) {
      BlocProvider.of<StoryGroupBloc>(context).add(
        StoryGroupEventScreenStoryResumed(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryPlayerBloc, StoryPlayerState>(
      listener: _listenStoryPlayerBloc,
      builder: _buildStoryPlayerBlocUI,
    );
  }

  Widget _buildStoryPlayerBlocUI(BuildContext context, StoryPlayerState state) {
    switch (state) {
      case StoryPlayerStateInitial():
      case StoryPlayerStateLoading():
      case StoryPlayerStatePlayerReady():
        return _buildLoadingUI();
      case StoryPlayerStatePlay():
        return GestureDetector(
          onLongPress: () => _onLongPress(context, state),
          onLongPressEnd: (_) => _onLongPressDown(context, state),
          child: _buildStoryPlayerUI(context, state),
        );
    }
  }

  Widget _buildStoryPlayerUI(BuildContext context, StoryPlayerStatePlay state) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Center(
            child: SizedBox.expand(
              child: storyDataModel.isPhoto
                  ? _buildImageUI(storyDataModel.url)
                  : _buildVideoUI(state.videoPlayerController),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: [
                for (final tapRegion in StoryScreenTapRegion.values)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!(storyIndex == 0 && isFirstGroup) &&
                            !(storyIndex == totalStoryCount - 1 &&
                                isLastGroup)) {
                          _onLongPress(context, state);
                        }
                        onTap(tapRegion);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUI(String mediaUrl) {
    return Image.network(
      mediaUrl,
      fit: BoxFit.scaleDown,
      errorBuilder: (_, __, ___) => _buildErrorUI(),
      loadingBuilder: (_, Widget child, ImageChunkEvent? chunkEvent) {
        if (chunkEvent != null) return _buildLoadingUI();
        return child;
      },
    );
  }

  Widget _buildVideoUI(CachedVideoPlayerController? videoPlayerController) {
    return videoPlayerController?.value.hasError ?? true
        ? _buildErrorUI()
        : videoPlayerController?.value.isInitialized ?? false
            ? Center(
                child: AspectRatio(
                  aspectRatio: videoPlayerController!.value.aspectRatio,
                  child: CachedVideoPlayer(videoPlayerController),
                ),
              )
            : const SizedBox();
  }

  Widget _buildLoadingUI() {
    return const Center(child: AdaptiveLoadingIndicator());
  }

  Widget _buildErrorUI() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, color: Colors.red),
        SizedBox(height: 8),
        Text(
          StringConstants.defaultErrorMessage,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
