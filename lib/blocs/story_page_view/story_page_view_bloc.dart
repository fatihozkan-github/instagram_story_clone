import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/story_constants.dart';
import '../../core/enums/enums.dart';
import '../../data/models/story_group_model.dart';
import '../../data/repositories/story_repository.dart';

part 'story_page_view_event.dart';
part 'story_page_view_state.dart';

class StoryPageViewBloc extends Bloc<StoryPageViewEvent, StoryPageViewState> {
  StoryPageViewBloc() : super(StoryPageViewStateInitial()) {
    on<StoryPageViewEventInitialize>(_onInit);
    on<StoryPageViewEventDeltaUpdate>(_onDeltaUpdate);
    on<StoryPageViewEventUpdateHistory>(_onUpdateHistory);
    on<StoryPageViewEventNavigate>(_onNavigate);
    on<StoryPageViewEventDispose>(_onDispose);
  }

  /// Personally, I prefer not to keep any controller inside Blocs as it
  /// conflicts with the separation of concerns and makes testing much more
  /// difficult. You can see more at bloc tests.
  ///
  /// Since it is clearly stated that I can't use [StatefulWidget]s,
  /// I will proceed as it is.
  ///
  /// In this case, we need a tree building process to use [PageController]
  /// methods.
  late PageController _pageController;

  List<int> _storyGroupHistoryIndexList = [];

  final _storyRepository = StoryRepository();

  List<int> get storyGroupHistoryIndexList => _storyGroupHistoryIndexList;

  int get _itemCount => storyGroupHistoryIndexList.length;

  FutureOr<void> _onInit(
    StoryPageViewEventInitialize event,
    Emitter<StoryPageViewState> emit,
  ) async {
    final storyGroupList = await _storyRepository.fetchNewStories();
    _pageController = PageController(initialPage: 0);
    _storyGroupHistoryIndexList = List.generate(
      storyGroupList.length,
      (index) => 0,
    );
    emit(
      StoryPageViewStateReady(
        pageController: _pageController,
        storyGroupList: storyGroupList,
        storyGroupHistoryIndexList: _storyGroupHistoryIndexList,
      ),
    );
  }

  FutureOr<void> _onDeltaUpdate(
    StoryPageViewEventDeltaUpdate event,
    Emitter<StoryPageViewState> emit,
  ) {
    emit(StoryPageViewStateDeltaUpdate(delta: event.delta));
  }

  FutureOr<void> _onDispose(
    StoryPageViewEventDispose event,
    Emitter<StoryPageViewState> emit,
  ) {
    _pageController.dispose();
  }

  FutureOr<void> _onNavigate(
    StoryPageViewEventNavigate event,
    Emitter<StoryPageViewState> emit,
  ) async {
    final currentPage = _pageController.page!.floor();
    if (event.navigationAction == NavigationAction.pop) {
      if (currentPage > 0) {
        await _pageController.animateToPage(
          currentPage - 1,
          curve: Curves.linear,
          duration: StoryConstants.storyGroupTransitionDuration,
        );
        emit(StoryPageViewStatePageChanged());
      }
    } else {
      if (currentPage < _itemCount) {
        await _pageController.animateToPage(
          currentPage + 1,
          curve: Curves.linear,
          duration: StoryConstants.storyGroupTransitionDuration,
        );
        emit(StoryPageViewStatePageChanged());
      }
    }
  }

  FutureOr<void> _onUpdateHistory(
    StoryPageViewEventUpdateHistory event,
    Emitter<StoryPageViewState> emit,
  ) {
    _storyGroupHistoryIndexList[event.groupIndex] = event.newInitialPage;
  }
}
