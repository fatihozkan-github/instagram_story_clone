import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/story_page_view/story_page_view_bloc.dart';
import 'core/constants/app_constants.dart';
import 'presentation/pages/story_page.dart';

void main() {
  runApp(const InstagramStoryClone());
}

class InstagramStoryClone extends StatelessWidget {
  const InstagramStoryClone({super.key});

  StoryPageViewBloc _createPageViewBloc(BuildContext context) {
    return StoryPageViewBloc()..add(StoryPageViewEventInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: _createPageViewBloc),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        home: StoryPageView(),
      ),
    );
  }
}
