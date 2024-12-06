import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double sliderValue = 30;
  bool isPlaying = false;

  ///  for suffixing
  bool isSuf = false;

  /// for Repeat
  bool isRepeat = false;

  /// here we create music list
  /// you can add more music here
  /// according to you requirement

  List<String> songList = [
    "assets/music/music 1.m4a",
    "assets/music/kisi-se-tum-pyar-karo-kisii-se-tum-pyaar-kro-andaaz.mp3",
    "assets/music/ikko-mikke-sanu-ajkal-sheesha-bada-ched.mp3",
  ];

  final AudioPlayer audioPlayer = AudioPlayer() ;

  /// current song
  int currentSong = 0 ;

  /// here we create function for play music
  Future<void> myAudioPlay() async {
    final String audioPath = songList[currentSong];

    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.setAsset(audioPath);
      await audioPlayer.play();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent.shade100,
        title: const Text(
          "Lyric Wave",
          style: TextStyle(
              fontSize: 25,
              fontFamily: "secondary",
              fontWeight: FontWeight.bold,
              color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            /// LOTTIE ANIMATION SHOW
            LottieBuilder.asset("assets/animation/playeranim.json"),

            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/icons/low-volume.png",
                    height: 30,
                  ),

                  ///  music list ----> open bottom for show music list
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 1,
                                    )
                                  ]),

                              /// Music List show here
                              child: Column(
                                children: [
                                  const Text(
                                    "Music List",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: "primary",
                                        color: Colors.orange,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 2,
                                              offset: Offset(1.0, 1.5))
                                        ]),
                                  ),

                                  /// MUSIC LIST Show Here
                                  Expanded(
                                      child: ListView.builder(
                                          itemCount: songList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                maxLines: 1,
                                                songList[index].split('/').last,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              leading: const Icon(
                                                Icons.music_note,
                                                color: Colors.blueAccent,
                                                size: 25,
                                              ),
                                            );
                                          }))
                                ],
                              ),
                            );
                          });
                    },
                    child: Image.asset(
                      "assets/icons/list-text.png",
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "Music name show here",
              style: TextStyle(fontSize: 25, fontFamily: "primary"),
            ),

            const Spacer(),

            Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.blueAccent.shade100,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 3, spreadRadius: 1)
                  ]),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Suffixing  ---> Button
                        InkWell(
                          onTap: () {
                            setState(() {
                              isSuf = !isSuf;
                            });
                          },
                          child: isSuf
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      "assets/icons/suffle.png",
                                      height: 30,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    "assets/icons/suffle.png",
                                    height: 30,
                                  ),
                                ),
                        ),

                        ///  Repeat -----> Button
                        InkWell(
                          onTap: () {
                            isRepeat = !isRepeat;
                            setState(() {});
                          },
                          child: isRepeat
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset(
                                      "assets/icons/rotate.png",
                                      height: 30,
                                    ),
                                  ),
                                )
                               : Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    "assets/icons/rotate.png",
                                    height: 30,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  /// ------------------------ slider ---------------------------///
                  Slider(
                      value: sliderValue,
                      min: 0,
                      divisions: 100,
                      max: 100,
                      activeColor: Colors.redAccent,
                      inactiveColor: Colors.black38,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      }),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "0.00",
                          style: TextStyle(fontSize: 18, fontFamily: "primary"),
                        ),
                        Text(
                          "5.00",
                          style: TextStyle(fontSize: 18, fontFamily: "primary"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// -------------------- BACK BUTTON ------------------------///
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/icons/left-arrow.png",
                          height: 50,
                        ),
                      ),

                      /// ----------------------- PLAY BUTTON ---------------------///
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: IconButton(
                          onPressed: () {
                            /// here we call myAudioPlayer function
                            myAudioPlay();
                            setState(() {
                              isPlaying = !isPlaying ;
                            });
                          },

                          icon: isPlaying
                              ? Image.asset(
                                  "assets/icons/pause.png",
                                  height: 50,
                                )
                              : Image.asset(
                                  "assets/icons/play.png",
                                  height: 60,
                                ),
                        ),
                      ),

                      /// ---------------------------------------NEXT BUTTON ----------------------------------------///
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/icons/right-arrow.png",
                          height: 50,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// player UI =>    START
/// player UI =>    Complete
/// add some functionality =>   toggling , button operation
/// play , pause => Done ,
/// create music folder , and past your music ,
/// bottom sheet open for music list => Start , END ;
/// sufficing  and repeat toggling  => Start ,
/// MUSIC list show in bottom navigation , => Start , END
/// MUSIC PLAY => START ,  is it working ===> Working successfully  , FINAL CHECK PLAY AND PAUSE  => Done

