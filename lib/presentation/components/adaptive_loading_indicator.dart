import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveLoadingIndicator extends StatelessWidget {
  const AdaptiveLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? const CircularProgressIndicator(color: Colors.white)
        : const CupertinoActivityIndicator(color: Colors.white);
  }
}
