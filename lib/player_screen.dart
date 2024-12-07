import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';

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
    "assets/music/tere-liye-song-with-lyrics-veer-zaara-shah-rukh-khan-preity-zinta-javed-akhtar-madan-mohan-128-ytshorts.savetube.me.mp3",
    "assets/music/music 1.m4a",
    "assets/music/videoplayback (1).m4a",
    "assets/music/videoplayback (1).m4a",
    "assets/music/samjhawan-lyric-video-humpty-sharma-ki-dulhania-varun-alia-arijit-singh-shreya-ghoshal-128-ytshorts.savetube.me.mp3",
    "assets/music/kisi-se-tum-pyar-karo-kisii-se-tum-pyaar-kro-andaaz.mp3",
    "assets/music/dhadhang-dhang-full-video-rowdy-rathore-akshay-sonakshi-shreya-ghoshal-sajid-wajid-128-ytshorts.savetube.me.mp3" ,
    "assets/music/ikko-mikke-sanu-ajkal-sheesha-bada-ched.mp3",
    "assets/music/aaj-se-teri-lyrical-padman-akshay-kumar-radhika-apte-arijit-singh-amit-trivedi-128-ytshorts.savetube.me.mp3",
    "assets/music/sanam re .mp3"
  ];

  final AudioPlayer audioPlayer = AudioPlayer();

  /// current song
  int currentSong = 0;

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

  /// HERE WE CREATE FUNCTION FOR NEXT SONG

  Future<void> nextSong() async {
    if (isSuf) {
      /// Generate a random song index that is different from the current song
      /// know check the nextSong function all error is solve
      final random = Random();
      int newIndex;
      do {
        newIndex = random.nextInt(songList.length);
      } while (newIndex == currentSong);

      currentSong = newIndex;
    } else {
      /// Sequentially play the next song
      currentSong = (currentSong + 1) % songList.length;
    }
    final String audioPath = songList[currentSong];
    await audioPlayer.setAsset(audioPath);
    await audioPlayer.play();

    setState(() {
      isPlaying = true;
    });
  }

  /// HERE WE CREATE FUNCTION FOR PREVIOUS SONG
  Future<void> previousSong() async {
    setState(() {
      currentSong = (currentSong - 1 + songList.length) % songList.length;
    });

    final String audioPath = songList[currentSong];
    await audioPlayer.setAsset(audioPath);
    await audioPlayer.play();
    setState(() {
      isPlaying = true;
    });
  }

  /// HERE WE CREATE FUNCTION FOR SEEK BAR

  Future<void> seekChange(double second) async {
    await audioPlayer.seek(Duration(seconds: second.toInt()));
  }

  /// according to time seekbar move
  late StreamSubscription<Duration> positionSubscription;
  late StreamSubscription<Duration?> durationSubscription;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    /// CHECK THIS AND CORRECT
    positionSubscription = audioPlayer.positionStream.listen((position) {
      setState(() {
        currentPosition = position;
        sliderValue = currentPosition.inSeconds.toDouble();
      });
    });

    durationSubscription = audioPlayer.durationStream.listen((duration) {
      setState(() {
        totalDuration = duration ?? Duration.zero;
      });
    });

    /// here we write code for go to next song automatic when song is end
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        nextSong();
      } else if (state.playing) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  /// HERE WE CREATE FUNCTION FOR DURATION TIME SHOW
  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final second = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$second";
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                              onTap: () async {
                                                setState(() {
                                                  currentSong = index;
                                                });

                                                final String audioPath =
                                                    songList[currentSong];
                                                await audioPlayer
                                                    .setAsset(audioPath);
                                                await audioPlayer.play();

                                                Navigator.of(context).pop();
                                                setState(() {
                                                  isPlaying = true;
                                                });
                                              },
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
              height: 20,
            ),

            /// MUSIC NAME SHOW SHARE
            SizedBox(
              height: 30,
              child: Marquee(
                blankSpace: 50,
                startPadding: 10,
                velocity: 30,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "primary",
                ),
                text: songList[currentSong].split('/').last,
              ),
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
                            audioPlayer.setLoopMode(
                                isRepeat ? LoopMode.one : LoopMode.off);

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
                      min: 0.0,
                      max: totalDuration.inSeconds > 0
                          ? totalDuration.inSeconds.toDouble()
                          : 1.0,
                      activeColor: Colors.redAccent,
                      inactiveColor: Colors.black38,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;

                          /// here we call seekChange function
                          seekChange(value);
                        });
                      }),

                  /// DURATION SHOW HERE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// HERE WE CALL FORMAT DURATION
                        Text(
                          formatDuration(currentPosition),
                          style: const TextStyle(
                              fontSize: 18, fontFamily: "primary"),
                        ),
                        Text(
                          formatDuration(totalDuration),
                          style: const TextStyle(
                              fontSize: 18, fontFamily: "primary"),
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
                        onPressed: () {
                          /// HERE WE CALL THIS PREVIOUS SONG FUNCTION
                          previousSong();
                        },
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
                              isPlaying = !isPlaying;
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
                        onPressed: () {
                          /// here we call nextSong function
                          nextSong();
                        },
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
/// NEXT SONG => fUNCTION CREATE => DONE , WORK SUCCESSFULLY
/// BACK SONG => function CREATE => DONE , WORK SUCCESSFULLY
/// SEEK BAR OPERATION => DONE ,
/// CURRENT SONG NAME SHOW => DONE
/// Long song name is automatic scrolling => DONE
/// SEEK BAR MOVE ACCORDING TO TIME AND MUSIC DURATION SHOW  => DONE
/// play song when click on list of song => DONE , CHECK
/// WHEN SONG IS END THEN GO TO NEXT SONG => DONE ,
/// Repeat operation => DONE ,
/// SUFFERING OPERATION =>  DONE ,
/// WE ADD MORE SONG => CHECK COMPLETE CODE
/// FINAL CHECK
/// THANKS
/// source code in description box ========//////////////////////
/// =---------------------------------------THANKS ALL OF YOU ----------------------------------------------=//////