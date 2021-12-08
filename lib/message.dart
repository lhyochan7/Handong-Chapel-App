import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:handong_chapel_app/main.dart';
import 'main.dart';

class messagePage extends StatefulWidget {
  const messagePage({Key? key, required this.messageOfTheDay})
      : super(key: key);

  final List<messageOfTheDayInfo> messageOfTheDay;

  @override
  _messagePageState createState() => _messagePageState();
}

class _messagePageState extends State<messagePage> {
  DateTime now = new DateTime.now();

  Duration _duration = new Duration();
  Duration _position = new Duration();

  String currentTime = "00:00";
  String completeTime = "00:00";

  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() async {
    super.dispose();
    await advancedPlayer.dispose();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration;
      });
    });

    advancedPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
  }

  late String localFilePath;

  Widget _tab(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children
            .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
            .toList(),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: ElevatedButton(
          child: Text(
            txt,
            style: TextStyle(color: Colors.black),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ));
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        value: double.parse(_position.inSeconds.toString()),
        min: 0.0,
        max: double.parse(_duration.inSeconds.toString()),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  Widget localAsset() {
    return _tab([
      _btn('Play', () => audioCache.play('music.mp3')),
      _btn('Pause', () => advancedPlayer.pause()),
      slider(),
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = new DateTime(now.year, now.month, now.day);
    String messageDate = date.year.toString() +
        ':' +
        date.month.toString() +
        ':' +
        date.day.toString();


    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Today\'s Reading'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    for (var message in widget.messageOfTheDay)
                      if (messageDate == message.timestamp)
                        Text(message.message)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                children: [localAsset()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
AudioWidget.assets(
        path: "assets/waymaker.wav",
        play: _play,
        child: Center(
          child: ElevatedButton(
              child: Text(
                _play ? "pause" : "play",
              ),
              onPressed: () {
                setState(() {
                  _play = !_play;
                });
              }),
        ),
        onReadyToPlay: (duration) {
          //onReadyToPlay
        },
        onPositionChanged: (current, duration) {
          //onPositionChanged
        },
      ),

 */

/*
 Duration _duration = new Duration();
  Duration _position = new Duration();

  String currentTime = "00:00";
  String completeTime = "00:00";

  //double _duration = 0.0;
  //double _position = 0.0;

  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        _position = duration;
      });
    });

    advancedPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
  }

  late String localFilePath;

  Widget _tab(List<Widget> children) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: children
              .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
              .toList(),
        ),
      ),
    );
  }

  Widget _btn(String txt, VoidCallback onPressed) {
    return ButtonTheme(
        minWidth: 48.0,
        child: ElevatedButton(
          child: Text(
            txt,
            style: TextStyle(color: Colors.black),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(primary: Colors.white),
        ));
  }

  Widget slider() {
    return Slider(
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        value: double.parse(_position.inSeconds.toString()),
        min: 0.0,
        max: double.parse(_duration.inSeconds.toString()),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  Widget localAsset() {
    return _tab([
      Text('Waymaker\:'),
      _btn('Play', () => audioCache.play('waymaker.wav')),
      _btn('Pause', () => advancedPlayer.pause()),
      _btn('Stop', () => advancedPlayer.stop()),
      slider(),
    ]);
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('audioplayers Example'),
        ),
        body: Column(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Psalm 23: \n"
                  "1 The Lord is my shepherd, I lack nothing.\n "
                  "2     He makes me lie down in green pastures,\n"
                  "he leads me beside quiet waters,"),
            )),
            Flexible(
              child: TabBarView(
                children: [localAsset()],
              ),
            ),
          ],
        ),
      ),
    );
  }
 */
