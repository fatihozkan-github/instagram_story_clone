import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/story_group/story_group_bloc.dart';
import '../../blocs/story_page_view/story_page_view_bloc.dart';
import '../../blocs/story_player/story_player_bloc.dart';
import '../../blocs/story_progress/story_progress_bloc.dart';
import '../../core/enums/enums.dart';
import '../../data/models/story_group_model.dart';
import 'adaptive_loading_indicator.dart';
import 'story_player.dart';
import 'story_progress_bar_item.dart';

class StoryGroupView extends StatelessWidget {
  final int groupIndex;
  final int initialPage;
  final StoryGroupModel storyGroupModel;
  final ScaffoldState scaffoldState;

  const StoryGroupView({
    super.key,
    required this.groupIndex,
    required this.initialPage,
    required this.storyGroupModel,
    required this.scaffoldState,
  });

  StoryProgressBloc _createStoryProgressBloc(BuildContext context) {
    return StoryProgressBloc(
      BlocProvider.of<StoryPageViewBloc>(context)
          .storyGroupHistoryIndexList[groupIndex],
    );
  }

  void _listenStoryGroupBloc(BuildContext context, StoryGroupState state) {
    final storyPageViewBloc = BlocProvider.of<StoryPageViewBloc>(context);
    final storyGroupBloc = BlocProvider.of<StoryGroupBloc>(context);

    if (state is StoryGroupStatePageChange) {
      storyPageViewBloc.add(
        StoryPageViewEventUpdateHistory(
          groupIndex: groupIndex,
          newInitialPage: state.newPage,
        ),
      );
    } else if (state is StoryGroupStateSendNavigationNotification) {
      storyPageViewBloc.add(
        StoryPageViewEventNavigate(navigationAction: state.navigationAction),
      );
    } else if (state is StoryGroupStateStoryPlayerReady) {
      storyGroupBloc.add(
        StoryGroupEventScreenStoryStart(
          duration: state.duration,
          newProgressIndex: state.newPage,
          scaffoldState: scaffoldState,
        ),
      );
      BlocProvider.of<StoryProgressBloc>(context).add(
        StoryProgressEventInitial(newProgressIndex: state.newPage),
      );
    } else if (state is StoryGroupStateScreenStoryStart) {
      BlocProvider.of<StoryProgressBloc>(context).add(
        StoryProgressEventRefresh(newProgressIndex: state.newPage),
      );
    } else if (state is StoryGroupStateScreenStoryPaused) {
      storyGroupBloc.currentStoryProgressAnimationController?.stop();
    } else if (state is StoryGroupStateScreenStoryResumed) {
      storyGroupBloc.currentStoryProgressAnimationController?.forward();
    }
  }

  bool _buildStoryGroupBlocWhen(_, StoryGroupState current) {
    return current is StoryGroupStateReady || current is StoryGroupStateInitial;
  }

  void _onTap(BuildContext context, StoryScreenTapRegion storyScreenTapRegion) {
    BlocProvider.of<StoryGroupBloc>(context).add(
      StoryGroupEventScreenTapped(
        storyScreenTapRegion: storyScreenTapRegion,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocProvider(
          create: _createStoryProgressBloc,
          child: BlocConsumer<StoryGroupBloc, StoryGroupState>(
            listener: _listenStoryGroupBloc,
            buildWhen: _buildStoryGroupBlocWhen,
            builder: _buildStoryGroupBlocUI,
          ),
        ),
      ),
    );
  }

  Widget _buildStoryGroupBlocUI(BuildContext context, StoryGroupState state) {
    if (state is StoryGroupStateReady) {
      return Column(
        children: [
          const SizedBox(height: 8),
          _buildStoryProgressBar(context),
          _buildHeader(),
          Expanded(child: _buildPageView(context, state)),
        ],
      );
    }
    return _buildLoadingUI();
  }

  Widget _buildPageView(BuildContext context, StoryGroupStateReady state) {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: state.pageController,
      itemCount: storyGroupModel.storyDataList.length,
      itemBuilder: (_, int index) {
        final storyGroupList =
            BlocProvider.of<StoryPageViewBloc>(context).storyGroupList;
        return BlocProvider(
          create: (_) => StoryPlayerBloc()
            ..add(
              StoryPlayerEventInitial(
                storyDataModel: storyGroupModel.storyDataList[index],
              ),
            ),
          child: StoryPlayer(
            storyIndex: index,
            totalStoryCount: storyGroupModel.storyDataList.length,
            storyDataModel: storyGroupModel.storyDataList[index],
            onTap: (StoryScreenTapRegion storyScreenTapRegion) {
              _onTap(context, storyScreenTapRegion);
            },
            isFirstGroup: storyGroupList.isEmpty
                ? false
                : storyGroupList.first.id == storyGroupModel.id,
            isLastGroup: storyGroupList.isEmpty
                ? false
                : storyGroupList.last.id == storyGroupModel.id,
          ),
        );
      },
    );
  }

  Widget _buildLoadingUI() {
    return const Center(child: AdaptiveLoadingIndicator());
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const CircleAvatar(),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    storyGroupModel.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    storyGroupModel.timestamp,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                storyGroupModel.subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 2),
          const Icon(Icons.close_rounded, color: Colors.white, size: 32),
        ],
      ),
    );
  }

  Widget _buildStoryProgressBar(BuildContext context) {
    final storyGroupLength = storyGroupModel.storyDataList.length;
    return Row(
      children: [
        for (int i = 0; i < storyGroupLength; i++)
          Expanded(
            child: StoryProgressBarItem(
              currentStoryIndex: i,
              totalCount: storyGroupLength,
            ),
          ),
      ],
    );
  }
}
