import 'package:flutter/material.dart';
import 'package:notification_course/get_it.dart';
import 'package:notification_course/services/page_manager.dart';
import 'package:notification_course/widgets/audio_control_button.dart';
import 'package:notification_course/widgets/audio_progress_bar.dart';
import 'package:notification_course/widgets/current_song_title.dart';
import 'package:notification_course/widgets/playlist.dart';


class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key,});



  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  @override
  void initState() {
    getIt<PageManager>().init();
    super.initState();
  }

  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Screen'),
      ),
      body:  const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CurrentSongTitle(),
          Playlist(),
          SizedBox(height: 20),
          AudioProgressBar(),
          AudioControlButtons(),
        ],
      ),
    );
  }
}







