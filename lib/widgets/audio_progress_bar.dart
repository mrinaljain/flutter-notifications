import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:notification_course/get_it.dart';
import 'package:notification_course/notifiers/progress_notifier.dart';
import 'package:notification_course/services/page_manager.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: ValueListenableBuilder<ProgressBarState>(
        valueListenable: pageManager.progressNotifier,
        builder: (_, value, __) {
          return ProgressBar(
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: pageManager.seek,
          );
        },
      ),
    );
  }
}
