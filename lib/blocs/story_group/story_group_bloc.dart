import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/story_constants.dart';
import '../../core/enums/enums.dart';

part 'story_group_event.dart';
part 'story_group_state.dart';

class StoryGroupBloc extends Bloc<StoryGroupEvent, StoryGroupState> {
  StoryGroupBloc() : super(StoryGroupStateInitial()) {
    on<StoryGroupEventInitialize>(_onInit);
    on<StoryGroupEventScreenTapped>(_onScreenTapped);
    on<StoryGroupEventStoryPlayerPlay>(_onStoryPlayerReady);
    on<StoryGroupEventScreenStoryStart>(_onStoryPlayerStart);
    on<StoryGroupEventScreenStoryPaused>(_onStoryPaused);
    on<StoryGroupEventScreenStoryResumed>(_onStoryResumed);
  }

  late int _itemCount;
  late PageController _controller;

  AnimationController? _currentStoryProgressAnimationController;

  AnimationController? get currentStoryProgressAnimationController =>
      _currentStoryProgressAnimationController;

  FutureOr<void> _onInit(
    StoryGroupEventInitialize event,
    Emitter<StoryGroupState> emit,
  ) {
    _itemCount = event.itemCount;
    _controller = PageController(initialPage: event.initialPage);
    emit(StoryGroupStateReady(cont: _controller));
  }

  FutureOr<void> _onScreenTapped(
    StoryGroupEventScreenTapped event,
    Emitter<StoryGroupState> emit,
  ) async {
    final tappedLeft = event.storyScreenTapRegion == StoryScreenTapRegion.left;
    final nextIndexPredicate =
        (_controller.page ?? 0).toInt() + (tappedLeft ? -1 : 1);
    if (0 <= nextIndexPredicate && nextIndexPredicate < _itemCount) {
      await _controller.animateToPage(
        nextIndexPredicate,
        duration: StoryConstants.storyTransitionDuration,
        curve: Curves.linear,
      );
      emit(StoryGroupStatePageChange(newPage: _controller.page?.toInt() ?? 0));
    } else if (nextIndexPredicate <= 0) {
      emit(
        StoryGroupStateSendNavigationNotification(
          navigationAction: NavigationAction.pop,
        ),
      );
    } else if (nextIndexPredicate >= _itemCount) {
      emit(
        StoryGroupStateSendNavigationNotification(
          navigationAction: NavigationAction.push,
        ),
      );
    }
  }

  FutureOr<void> _onStoryPlayerReady(
    StoryGroupEventStoryPlayerPlay event,
    Emitter<StoryGroupState> emit,
  ) {
    emit(
      StoryGroupStateStoryPlayerReady(
        duration: event.duration,
        newPage: event.newPage,
      ),
    );
  }

  void listener() {
    if (_currentStoryProgressAnimationController?.isCompleted ?? false) {
      if (!isClosed) {
        add(
          StoryGroupEventScreenTapped(
            storyScreenTapRegion: StoryScreenTapRegion.right,
          ),
        );
      }
    }
  }

  FutureOr<void> _onStoryPlayerStart(
    StoryGroupEventScreenStoryStart event,
    Emitter<StoryGroupState> emit,
  ) {
    _currentStoryProgressAnimationController?.dispose();
    _currentStoryProgressAnimationController = null;
    _currentStoryProgressAnimationController = AnimationController(
      vsync: event.scaffoldState,
      duration: event.duration,
    );
    _currentStoryProgressAnimationController?.addListener(listener);
    _currentStoryProgressAnimationController?.forward();
    emit(StoryGroupStateScreenStoryStart(newPage: event.newProgressIndex));
  }

  FutureOr<void> _onStoryPaused(
    StoryGroupEventScreenStoryPaused event,
    Emitter<StoryGroupState> emit,
  ) {
    emit(StoryGroupStateScreenStoryPaused(storyIndex: event.storyIndex));
  }

  FutureOr<void> _onStoryResumed(
    StoryGroupEventScreenStoryResumed event,
    Emitter<StoryGroupState> emit,
  ) {
    emit(StoryGroupStateScreenStoryResumed());
  }
}
