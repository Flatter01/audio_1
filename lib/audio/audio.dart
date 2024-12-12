import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerUI extends StatefulWidget {
  @override
  _MusicPlayerUIState createState() => _MusicPlayerUIState();
}

class _MusicPlayerUIState extends State<MusicPlayerUI> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  double volume = 0.5;

  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
  ];

  List<Map<String, String>> tracks = [
    {
      'name': 'Song 1',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'
    },
    {
      'name': 'Song 2',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'
    },
    {
      'name': 'Song 3',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'
    },
  ];

  int currentTrackIndex = 0;
  PageController _pageController = PageController(
      viewportFraction: 0.7); // Это нужно для изменения размера контейнера

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _playNextTrack();
    });
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(tracks[currentTrackIndex]['url']!));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekTo(double seconds) async {
    await _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  void _setVolume(double value) async {
    await _audioPlayer.setVolume(value);
    setState(() {
      volume = value;
    });
  }

  void _playPreviousTrack() {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      _playTrack();
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _playNextTrack() {
    if (currentTrackIndex < tracks.length - 1) {
      currentTrackIndex++;
      _playTrack();
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _playTrack() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(tracks[currentTrackIndex]['url']!));
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PageView с настройкой для увеличения/уменьшения контейнеров
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: tracks.length,
              onPageChanged: (index) {
                setState(() {
                  currentTrackIndex = index;
                });
                _playTrack();
              },
              itemBuilder: (context, index) {
                // Это увеличивает активный контейнер и уменьшает остальные
                double scale = currentTrackIndex == index ? 0.9 : 0.8;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTrackIndex = index;
                    });
                    _playTrack();
                  },
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: EdgeInsets.only(
                          top:
                              Platform.isWindows || Platform.isMacOS ? 30 : 200,
                          bottom:
                              Platform.isWindows || Platform.isMacOS ? 10 : 60),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: colors[index],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Текст текущей песни
          Text(
            isPlaying
                ? 'Playing: ${tracks[currentTrackIndex]['name']}'
                : 'Not Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20.0),

          // Ползунок времени трека
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Slider(
                  value: currentPosition.inSeconds.toDouble(),
                  min: 0.0,
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    _seekTo(value);
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),

                // Временные метки
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(currentPosition),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                    Text(
                      _formatDuration(totalDuration),
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.0),

          // Управление воспроизведением
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:
                    Icon(Icons.skip_previous, color: Colors.white, size: 36.0),
                onPressed: _playPreviousTrack,
              ),
              SizedBox(width: 20.0),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 48.0,
                ),
                onPressed: _togglePlayPause,
              ),
              SizedBox(width: 20.0),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white, size: 36.0),
                onPressed: _playNextTrack,
              ),
            ],
          ),

          SizedBox(height: 20.0),

          // Ползунок громкости
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Row(
              children: [
                Icon(Icons.volume_down, color: Colors.white),
                Expanded(
                  child: Slider(
                    value: volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      _setVolume(value);
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
                ),
                Icon(Icons.volume_up, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
