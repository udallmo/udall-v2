import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:udall_sound/sounds.dart';
import 'package:udall_sound/get_location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'This is Udall'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AudioCache audioCache;
  AudioPlayer audioPlayer;
  int indexIsPlaying;

  final List _wows = WowSounds().wows;

  List<String> _headshots = [
    'assets/images/owen1.png',
    'assets/images/owen2.png',
    'assets/images/owen3.png',
    'assets/images/owen4.png',
    'assets/images/owen5.png',
    'assets/images/owen6.png',
    'assets/images/owen7.png',
    'assets/images/owen8.png',
    'assets/images/owen9.png',
    'assets/images/owen10.png',
    'assets/images/owen11.png',
    'assets/images/owen12.png',
  ];

  @override
  void initState() {
    super.initState();
    initSounds();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initSounds() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioCache.loadAll(_wows);
  }

  void playSound(wow) async {
    var fileName = wow;
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      audioPlayer.stop();
    }
    audioPlayer = await audioCache.play(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GetLocation(),
                ),
                GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 24,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    child: AnimatedContainer(
                      width: indexIsPlaying == index ? 120 : 80,
                      height: indexIsPlaying == index ? 120 : 80,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      decoration: BoxDecoration(
                        color: indexIsPlaying == index
                            ? Colors.white
                            : Colors.blue[500],
                        borderRadius: new BorderRadius.circular(100.0),
                        image: new DecorationImage(
                          image: new AssetImage(_headshots[index % 12]),
                          fit: BoxFit.fill,
                        ),
                        border: new Border.all(
                            color: indexIsPlaying == index
                                ? Colors.lightBlueAccent
                                : Colors.transparent,
                            width: 2.0,
                            style: BorderStyle.solid),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: Offset(0, 10.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          playSound(_wows[index]);
                          indexIsPlaying = index;
                        });
                      }
                    },
                  ),
                  padding: const EdgeInsets.all(30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
