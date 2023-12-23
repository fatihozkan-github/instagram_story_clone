import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/story_page_view/story_page_view_bloc.dart';
import '../components/loading_indicator.dart';
import '../components/story_group_view.dart';

class StoryPageView extends StatelessWidget {
  const StoryPageView({super.key});

  bool _onNotification(
    BuildContext context,
    PageController pageController,
    Notification notification,
  ) {
    if (notification is ScrollUpdateNotification) {
      if (pageController.page == pageController.page?.floor()) {
        return true;
      }
      BlocProvider.of<StoryPageViewBloc>(context).add(
        StoryPageViewEventDeltaUpdate(
          delta: pageController.page! - pageController.page!.floor(),
        ),
      );
    }
    return true;
  }

  bool _buildStoryPageViewBlocWhen(
    StoryPageViewState previousState,
    StoryPageViewState nextState,
  ) {
    return (previousState is StoryPageViewStateInitial &&
        nextState is StoryPageViewStateReady);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return BlocBuilder<StoryPageViewBloc, StoryPageViewState>(
            buildWhen: _buildStoryPageViewBlocWhen,
            builder: _buildStoryPageViewBlocUI,
          );
        },
      ),
    );
  }

  Widget _buildStoryPageViewBlocUI(
      BuildContext context, StoryPageViewState state) {
    switch (state) {
      case StoryPageViewStateInitial():
        return _buildLoadingUI();
      case StoryPageViewStateDeltaUpdate():
      case StoryPageViewStateDisposed():
      case StoryPageViewStatePageChanged():
        return const SizedBox();
      case StoryPageViewStateReady():
        return NotificationListener(
          onNotification: (Notification notification) {
            if (state is StoryPageViewStatePageChanged) return true;
            return _onNotification(context, state.pageController, notification);
          },
          child: _buildPageView(context, state),
        );
    }
  }

  Widget _buildLoadingUI() {
    return const Center(child: AdaptiveLoadingIndicator());
  }

  Widget _buildPageView(BuildContext context, StoryPageViewStateReady state) {
    return PageView.builder(
      controller: state.pageController,
      itemCount: state.storyGroupList.length,
      itemBuilder: (_, index) {
        return BlocBuilder<StoryPageViewBloc, StoryPageViewState>(
          builder: (_, StoryPageViewState innerState) {
            return _buildPageViewItem(
              StoryGroupView(
                scaffoldState: Scaffold.of(context),
                userModel: state.storyGroupList[index],
                groupIndex: index,
                initialPage: state.storyGroupHistoryIndexList[index],
              ),
              index,
              state.pageController.position.haveDimensions
                  ? (state.pageController.page?.floor() ?? 0)
                  : 0,
              (innerState is StoryPageViewStateDeltaUpdate
                  ? innerState.delta
                  : 0.0),
            );
          },
        );
      },
    );
  }

  Widget _buildPageViewItem(
    Widget page,
    int pageViewIndex,
    int currentPage,
    double pageDelta,
  ) {
    final matrixWithEntry = Matrix4.identity()..setEntry(3, 2, 0.001);
    if (pageViewIndex == currentPage) {
      return Transform(
        alignment: Alignment.centerRight,
        transform: matrixWithEntry..rotateY(math.pi / 2 * pageDelta),
        child: page,
      );
    } else if (pageViewIndex == currentPage + 1) {
      return Transform(
        alignment: Alignment.centerLeft,
        transform: matrixWithEntry..rotateY(-math.pi / 2 * (1 - pageDelta)),
        child: page,
      );
    } else {
      return page;
    }
  }
}
