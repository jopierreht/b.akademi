import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter/material.dart';
import 'package:webinar/common/common.dart';

class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const PodVideoPlayerDev(this.url, this.type, this.routeObserver, {super.key});

  @override
  State<PodVideoPlayerDev> createState() => _PodVideoPlayerDevState();
}

class _PodVideoPlayerDevState extends State<PodVideoPlayerDev> with RouteAware {
  late YoutubePlayerController _youtubeController;
  bool isYouTube = false;

  @override
  void initState() {
    super.initState();

    if (widget.type == 'youtube') {
      isYouTube = true;

      // Extract YouTube Video ID from the full URL
      final videoId = YoutubePlayerController.convertUrlToId(widget.url);

      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId ?? '',
        autoPlay: true, // Autoplay as required
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    _youtubeController.close();
    super.dispose();
  }

  @override
  void didPushNext() {
    _youtubeController.pause(); // Use pause from the YoutubePlayerController
  }

  @override
  void didPopNext() {
    _youtubeController.play(); // Use play from the YoutubePlayerController
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: borderRadius(),
        child: SizedBox(
          width: getSize().width,
          child: isYouTube
              ? YoutubePlayer(
            controller: _youtubeController,
            aspectRatio: 16 / 9,
          )
              : const Center(
            child: Text('Non-YouTube video type not supported.'),
          ),
        ),
      ),
    );
  }
}

extension on YoutubePlayerController {
  void play() {}

  void pause() {}
}