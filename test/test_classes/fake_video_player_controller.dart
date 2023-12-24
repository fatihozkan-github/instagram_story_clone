import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';

class FakeVideoPlayerController extends ValueNotifier<CachedVideoPlayerValue>
    implements CachedVideoPlayerController {
  FakeVideoPlayerController()
      : super(CachedVideoPlayerValue(duration: Duration.zero));

  FakeVideoPlayerController.value(super.value);

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  int textureId = -1;

  @override
  String get dataSource => '';

  @override
  Map<String, String> get httpHeaders => <String, String>{};

  @override
  DataSourceType get dataSourceType => DataSourceType.file;

  @override
  String get package => '';

  @override
  Future<Duration> get position async => value.position;

  @override
  Future<void> seekTo(Duration moment) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {}

  @override
  Future<void> setLooping(bool looping) async {}

  @override
  VideoFormat? get formatHint => null;

  @override
  Future<ClosedCaptionFile> get closedCaptionFile => throw UnimplementedError();

  @override
  VideoPlayerOptions? get videoPlayerOptions => null;
}
