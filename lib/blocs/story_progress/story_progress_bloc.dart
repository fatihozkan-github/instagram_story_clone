import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'story_progress_event.dart';
part 'story_progress_state.dart';

class StoryProgressBloc extends Bloc<StoryProgressEvent, StoryProgressState> {
  final int initialStep;
  StoryProgressBloc(this.initialStep)
      : super(
          StoryProgressStateInitial(currentProgressIndex: initialStep),
        ) {
    on<StoryProgressEventInitial>(_onInitial);
    on<StoryProgressEventRefresh>(_onData);
  }

  FutureOr<void> _onInitial(
    StoryProgressEventInitial event,
    Emitter<StoryProgressState> emit,
  ) {
    emit(
      StoryProgressStateInitial(
        currentProgressIndex: event.newProgressIndex,
      ),
    );
  }

  FutureOr<void> _onData(
    StoryProgressEventRefresh event,
    Emitter<StoryProgressState> emit,
  ) async {
    emit(
      StoryProgressStateRefresh(
        currentProgressIndex: event.newProgressIndex,
      ),
    );
  }
}
