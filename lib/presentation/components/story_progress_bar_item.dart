import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/story_group/story_group_bloc.dart';
import '../../blocs/story_progress/story_progress_bloc.dart';

class StoryProgressBarItem extends StatelessWidget {
  final int currentStoryIndex;
  final int totalCount;

  const StoryProgressBarItem({
    super.key,
    required this.currentStoryIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    const rightMargin = 2.0;
    return Container(
      color: Colors.grey,
      margin: const EdgeInsets.only(right: rightMargin),
      child: BlocBuilder<StoryProgressBloc, StoryProgressState>(
        builder: _buildActiveStoryUI,
      ),
    );
  }

  Widget _buildActiveStoryUI(BuildContext context, StoryProgressState state) {
    final progressItemWidth = MediaQuery.of(context).size.width / totalCount;
    final animationController = BlocProvider.of<StoryGroupBloc>(context)
        .currentStoryProgressAnimationController;
    if (currentStoryIndex == state.currentProgressIndex &&
        animationController != null &&
        state is StoryProgressStateRefresh) {
      return Stack(
        children: [
          Container(height: 2, width: progressItemWidth, color: Colors.grey),
          AnimatedBuilder(
            animation: animationController,
            builder: (_, __) {
              return Container(
                height: 2,
                color: Colors.white,
                width: animationController.value * progressItemWidth,
              );
            },
          ),
        ],
      );
    } else if (state.currentProgressIndex > currentStoryIndex) {
      return Container(height: 2, color: Colors.white);
    } else if (state.currentProgressIndex < currentStoryIndex) {
      return Container(height: 2, color: Colors.grey);
    }
    return Container(height: 2, color: Colors.grey);
  }
}
