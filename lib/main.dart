import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool isplaying = false;
  double value = 0;
  final player = AudioPlayer();
  Duration? duration= Duration(seconds: 0);

  void initPlayer() async {
    await player.setSource(AssetSource("music.mp3"));
    duration = await player.getDuration();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/boxed-water-is-better-gseALihVvQA-unsplash.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/boxed-water-is-better-gseALihVvQA-unsplash.jpg",
                  width: 250.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Winter Vibes",
                style: TextStyle(
                    color: Colors.white, fontSize: 36.0, letterSpacing: 6.0,fontFamily:"Dancing"),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()} : ${(value % 60).floor()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Slider.adaptive(
                    onChanged: (v) {
                      setState(() {
                        value = v;
                      });
                    },
                    min: 0.0,
                    value: value,
                    max: 214.0,//duration!.inSeconds.toDouble(),
                    onChangeEnd: (newValue) async{
                      setState(() {
                        value = newValue;
                        print(newValue);
                      });
                      player.pause();
                      await player.seek(Duration(seconds: newValue.toInt()));
                      await player.resume();
                    },
                    activeColor: Colors.white,
                  ),
                  Text(
                    "${duration!.inMinutes} : ${duration!.inSeconds % 60}",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    color: Colors.black87,
                    border: Border.all(color: Colors.pink)),
                child: InkWell(
                  onTap: () async {
                   if(isplaying)
                     {
                      await player.pause();
                      setState(() {
                        isplaying = false;
                      });
                     }
                   else{
                     setState(() {
                       isplaying = true;
                     });
                     await player.resume();
                     player.onPositionChanged.listen(
                             (position) {
                           setState(() {
                             value = position.inSeconds.toDouble();
                           });
                         }
                     );

                   }
                  },
                  child: Icon(
                    isplaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
