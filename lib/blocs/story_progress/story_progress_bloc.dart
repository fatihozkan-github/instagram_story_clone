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
    on<StoryProgressEventRefresh>(_onData);
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
