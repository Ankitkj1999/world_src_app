import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:world_src_app/models/databaseHelperMusic.dart';
import 'package:world_src_app/models/music.dart';
import 'package:flutter_glow/flutter_glow.dart';

class MusicsDetail extends StatefulWidget {
  final songName;
  final mp3url;
  final imageName;
  final artistName;
  final year;
  final listenNumbers;
  final alt_download;
  final lyrics;
  MusicsDetail(
      {this.mp3url,
      this.lyrics,
      this.imageName,
      this.artistName,
      this.year,
      this.alt_download,
      this.listenNumbers,
      this.songName});

  @override
  _MusicsDetailState createState() => _MusicsDetailState();
}

class _MusicsDetailState extends State<MusicsDetail> {
  String mp3url;
  String lyrics;
  String songName;
  String imageName;
  String artistName;
  String year;
  String listenNumbers;
  String alt_download;
  DatabaseHelperMusic db = new DatabaseHelperMusic();

  List<Music> items = new List();
  bool isSaved = false;
  ////
  String url;
// String initUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4";
// String initUrl = "/storage/emulated/0/Download/Test.mp4";
// String initUrl = "/sdcard/Download/Test.mp4";

  String changeUrl;
  //  "http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_30fps_normal.mp4";

  Uint8List image;
  VlcPlayerController _videoViewController;
  bool isPlaying = true;
  double sliderValue = 0.0;
  double currentPlayerTime = 0;
  double volumeValue = 100;
  String position = "";
  String duration = "";
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool isBuffering = true;
  bool getCastDeviceBtnEnabled = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  ////
  void _launchURLBrowser(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld);
    } else {
      throw 'could not launch url';
    }
  }

  void _launchURLApp(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'could not launch url';
    }
  }

  @override
  void initState() {
    db.getAllmusics().then((musics) {
      setState(() {
        musics.forEach((music) {
          items.add(Music.fromMap(music));
        });
      });
    });

    lyrics = widget.lyrics;
    songName = widget.songName;
    mp3url = widget.mp3url;
    imageName = widget.imageName;
    artistName = widget.artistName;
    year = widget.year;
    listenNumbers = widget.listenNumbers;
    alt_download = widget.alt_download;
//////
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    url = widget.mp3url;
    changeUrl = url;
    print("helloooooooooo");
    print(url);
    ///////
    _videoViewController = new VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
    _videoViewController.addListener(() {
      if (!this.mounted) return;
      if (_videoViewController.initialized) {
        var oPosition = _videoViewController.position;
        var oDuration = _videoViewController.duration;
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
        }
        sliderValue = _videoViewController.position.inSeconds.toDouble();
        numberOfCaptions = _videoViewController.spuTracksCount;
        numberOfAudioTracks = _videoViewController.audioTracksCount;

        switch (_videoViewController.playingState) {
          case PlayingState.PAUSED:
            setState(() {
              isBuffering = false;
            });
            break;

          case PlayingState.STOPPED:
            setState(() {
              isPlaying = false;
              isBuffering = false;
            });
            break;
          case PlayingState.BUFFERING:
            setState(() {
              isBuffering = true;
            });
            break;
          case PlayingState.PLAYING:
            setState(() {
              isBuffering = false;
            });
            break;
          case PlayingState.ERROR:
            setState(() {});
            print("VLC encountered error");
            break;
          default:
            setState(() {});
            break;
        }
      }
    });
    ///////
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
/////////////////////
    bool checkHeart() {
      bool chec = false;
      for (int i = 0; i < items.length; i++) {
        if (items[i].musicName == songName) {
          chec = true;
          break;
        } else {
          chec = false;
        }
      }
      return chec;
    }

    // print(items.length);
    // print(checkHeart());
    //print(items[0].musicName);
    isSaved = checkHeart();
    ///////////////
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.6,
              child: Stack(
                //alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Container(
                    height: size.height * 1.3 - 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageName),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0B0424).withOpacity(0.4),
                          Color(0xFF0B0424),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            songName,
                            style: TextStyle(
                                //color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              artistName,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              " | " + year,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isSaved ? Colors.red : Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isSaved) {
                                    isSaved = false;
                                  } else {
                                    db.savemusic(Music(
                                      songName,
                                      lyrics,
                                      mp3url,
                                      artistName,
                                      year,
                                      imageName,
                                      alt_download,
                                    ));
                                    isSaved = true;
                                  }
                                });
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                _launchURLBrowser(alt_download);
                              },
                              icon: Icon(
                                Icons.file_download,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          //inactiveTrackColor: Color(0xFF8D8E98),
                                          //activeTrackColor: Colors.white,
                                          //thumbColor: Color(0xFF52C9DD),
                                          overlayColor: Color(0x2952C9DD),
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 5.0),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 25.0),
                                          trackHeight: 2,
                                        ),
                                        child: Slider(
                                          //inactiveColor: Colors.white54,
                                          activeColor: Colors.red,
                                          value: sliderValue,
                                          min: 0.0,
                                          max: _videoViewController.duration ==
                                                  null
                                              ? (sliderValue + 1)
                                              : _videoViewController
                                                  .duration.inSeconds
                                                  .toDouble(),
                                          onChanged: (progress) {
                                            setState(() {
                                              sliderValue =
                                                  progress.floor().toDouble();
                                            });
                                            //convert to Milliseconds since VLC requires MS to set time
                                            _videoViewController.setTime(
                                                sliderValue.toInt() * 1000);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(position),
                            SizedBox(
                              width: 27,
                            ),
                            Text(duration),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fast_rewind,
                              color: Colors.red.shade100,
                              size: 35,
                            ),
                            Center(
                              child: FlatButton(
                                  child: isPlaying
                                      ? Icon(
                                          Icons.pause_circle_filled,
                                          size: 70,
                                          //glowColor: Colors.redAccent.shade100,
                                          color: Colors.red,
                                          //blurRadius: 11,
                                        )
                                      : Icon(
                                          Icons.play_circle_filled,
                                          size: 70,
                                          //  glowColor: Colors.redAccent.shade100,
                                          color: Colors.red,
                                          //blurRadius: 11,
                                          //color: Colors.redAccent,
                                        ),
                                  onPressed: () => {playOrPauseVideo()}),
                            ),
                            Icon(
                              Icons.fast_forward,
                              color: Colors.red.shade100,
                              size: 35,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 23.0,
                        ),
                        FlatButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Lyrics(
                                      lyricsDes: lyrics,
                                    ));
                          },
                          child: Container(
                            width: 80,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(.3),
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text("Lyrics"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Center(
                            child: new VlcPlayer(
                              aspectRatio: 2 / 1,
                              url: changeUrl,
                              isLocalMedia: false,
                              controller: _videoViewController,
                              // Play with vlc options
                              options: [
                                '--quiet',
// '-vvv',
                                '--no-drop-late-frames',
                                '--no-skip-frames',
                                '--rtsp-tcp',
                              ],
                              hwAcc: HwAcc.DISABLED,
                              // or {HwAcc.AUTO, HwAcc.DECODING, HwAcc.FULL}
                              placeholder: Container(
                                height: 250.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  /////////

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoViewController.dispose();
    super.dispose();
  }

  void playOrPauseVideo() {
    String state = _videoViewController.playingState.toString();

    if (state == "PlayingState.PLAYING") {
      _videoViewController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      _videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _getSubtitleTracks() async {
    if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
      return;

    Map<dynamic, dynamic> subtitleTracks =
        await _videoViewController.getSpuTracks();
    //
    if (subtitleTracks != null && subtitleTracks.length > 0) {
      int selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Subtitle"),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: subtitleTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < subtitleTracks.keys.length
                            ? subtitleTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedSubId != null)
        await _videoViewController.setSpuTrack(selectedSubId);
    }
  }

  void _getAudioTracks() async {
    if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
      return;

    Map<dynamic, dynamic> audioTracks =
        await _videoViewController.getAudioTracks();
    //
    if (audioTracks != null && audioTracks.length > 0) {
      int selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Audio"),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: audioTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < audioTracks.keys.length
                          ? audioTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < audioTracks.keys.length
                            ? audioTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedAudioTrackId != null)
        await _videoViewController.setAudioTrack(selectedAudioTrackId);
    }
  }

  void _getCastDevices() async {
    Map<dynamic, dynamic> castDevices =
        await _videoViewController.getCastDevices();
    //
    if (castDevices != null && castDevices.length > 0) {
      String selectedCastDeviceName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Cast Device"),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: castDevices.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < castDevices.keys.length
                          ? castDevices.values.elementAt(index).toString()
                          : 'Disconnect',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < castDevices.keys.length
                            ? castDevices.keys.elementAt(index)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _videoViewController.startCasting(
        selectedCastDeviceName,
      );
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("No Cast Device Found!")));
    }
  }

  void _createCameraImage() async {
    Uint8List file = await _videoViewController.takeSnapshot();
    setState(() {
      image = file;
    });
  }
///////////
}

class Lyrics extends StatelessWidget {
  final lyricsDes;
  Lyrics({this.lyricsDes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lyrics",
          style: TextStyle(fontSize: 30, color: Colors.red),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Text(
                lyricsDes == "" ? " No Lyrics" : lyricsDes,
                style: TextStyle(color: Colors.red.shade200),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
