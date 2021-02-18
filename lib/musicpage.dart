import 'dart:math';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_src_app/MyTheme.dart';
import 'package:world_src_app/apk_page.dart';
import 'package:world_src_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_src_app/models/databaseHelperMusic.dart';
import 'package:world_src_app/models/music.dart';
import 'package:world_src_app/moviepage.dart';
import 'package:world_src_app/search_page.dart';
import 'networking.dart';
import 'loading_page.dart';
import 'package:loading/loading.dart';
import 'musicDetailPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class loadingScreenMusic extends StatefulWidget {
  @override
  _loadingScreenMusicState createState() => _loadingScreenMusicState();
}

class _loadingScreenMusicState extends State<loadingScreenMusic> {
  String token1;

  @override
  void initState() {
    getTokenForAPI().then((value) {
      token1 = value.toString();
      print(value.runtimeType);
      print(value);
      print(token1);
      getLocationData();
    });
    super.initState();
  }

  getTokenForAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token0 = prefs.getString('token');
    return token0;
  }

  void getLocationData() async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://www.worldsrc.net/apps_1/music_home?m=1&t=$token1');

    var controlData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MusicsListPage(
        MusicsControl: controlData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.grey,
          size: 50.0,
        ),
      ),
    );
  }
}

class MusicsListPage extends StatefulWidget {
  final MusicsControl;
  MusicsListPage({this.MusicsControl});

  @override
  _MusicsListPageState createState() => _MusicsListPageState();
}

class _MusicsListPageState extends State<MusicsListPage>
    with TickerProviderStateMixin {
  FancyDrawerController _controller;
  DatabaseHelperMusic db = new DatabaseHelperMusic();
  List<Music> items = new List();

  bool isSearching = false;
  String typeSection = "music";
  dynamic data1;
  TabController _tabControl;
  @override
  void initState() {
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    _tabControl = TabController(length: 3, vsync: this);
    data1 = widget.MusicsControl;

    db.getAllmusics().then((musics) {
      setState(() {
        musics.forEach((music) {
          items.add(Music.fromMap(music));
        });
      });
    });
    print(items.length);

    // TODO: implement initState
    super.initState();
  }

  bool changeBrightness = false;
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FancyDrawerWrapper(
        backgroundColor: Color(0xFF2196F3),
        controller: _controller,
        drawerItems: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Row(
              children: [
                Text(
                  changeBrightness ? "Light Mode: " : "Dark Mode: ",
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
                IconButton(
                    icon: Icon(changeBrightness
                        ? FontAwesomeIcons.solidSun
                        : FontAwesomeIcons.solidMoon),
                    onPressed: () {
                      setState(() {
                        if (changeBrightness) {
                          changeBrightness = false;
                        } else {
                          changeBrightness = true;
                        }
                      });
                      ThemeBuilder.of(context).changeTheme();
                    }),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/dicon.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return loadingScreen();
              }));
              //Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.home,
                    size: 27.0,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      //color: Color(0xFFBDDFF8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return loadingScreenMovies();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.film,
                    size: 27.0,
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    "Movies",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      //color: Color(0xFFBDDFF8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //////
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return loadingScreenMusic();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.music,
                    size: 27.0,
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    "Music",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return loadingScreenAPK();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.android,
                    size: 27.0,
                  ),
                  SizedBox(
                    width: 18.0,
                  ),
                  Text(
                    "APK",
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            //key: _scaffoldKey,
            appBar: AppBar(
              title: !isSearching
                  ? Text("Music")
                  : TextField(
                      onSubmitted: (String str) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return loadingSearch(
                            searchKeyword: str,
                            type: typeSection,
                          );
                        }));
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search Music....",
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
              centerTitle: true,
              titleSpacing: 2.0,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  //_scaffoldKey.currentState.openDrawer();
                  _controller.toggle();
                },
              ),
              actions: [
                isSearching
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            this.isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            this.isSearching = true;
                          });
                        },
                      ),
              ],
            ),
            /////////////////////
            body: TabBarView(
              controller: _tabControl,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                child: Text(
                                  "Most Popular",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 240,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MusicsDetail(
                                        lyrics: data1[index]['song_lyric'],
                                        mp3url: data1[index]['mp3_download'],
                                        songName: data1[index]['song_name'],
                                        artistName: data1[index]['artist'],
                                        year: data1[index]['year'],
                                        listenNumbers: data1[index]
                                            ['listen_number'],
                                        alt_download: data1[index]
                                            ['alt_download'],
                                        imageName: data1[index]['image'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color(0xFF242A39)),
                                              ),
                                              child: Image.network(
                                                data1[index]['image'],
                                                height: 145.0,
                                                width: 150.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.album,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                ),
                                                Text(
                                                  data1[index]['year'],
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            data1[index]['song_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data1[index]['artist'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      //////////
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                child: Text(
                                  "Top 2020",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 240,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MusicsDetail(
                                        lyrics: data1[index + 10]['song_lyric'],
                                        mp3url: data1[index + 10]
                                            ['mp3_download'],
                                        songName: data1[index + 10]
                                            ['song_name'],
                                        artistName: data1[index + 10]['artist'],
                                        year: data1[index + 10]['year'],
                                        listenNumbers: data1[index + 10]
                                            ['listen_number'],
                                        alt_download: data1[index + 10]
                                            ['alt_download'],
                                        imageName: data1[index + 10]['image'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color(0xFF242A39)),
                                              ),
                                              child: Image.network(
                                                data1[index + 10]['image'],
                                                height: 145.0,
                                                width: 150.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.album,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                ),
                                                Text(
                                                  data1[index + 10]['year'],
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            data1[index + 10]['song_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data1[index + 10]['artist'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      ////////////
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Expanded(
                                child: Text(
                                  "Most Downloaded",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 240,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MusicsDetail(
                                        lyrics: data1[index + 17]['song_lyric'],
                                        mp3url: data1[index + 17]
                                            ['mp3_download'],
                                        songName: data1[index + 17]
                                            ['song_name'],
                                        artistName: data1[index + 17]['artist'],
                                        year: data1[index + 17]['year'],
                                        listenNumbers: data1[index + 17]
                                            ['listen_number'],
                                        alt_download: data1[index + 17]
                                            ['alt_download'],
                                        imageName: data1[index + 17]['image'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Color(0xFF242A39)),
                                              ),
                                              child: Image.network(
                                                data1[index + 17]['image'],
                                                height: 145.0,
                                                width: 150.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.album,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                ),
                                                Text(
                                                  data1[index + 17]['year'],
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.red),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            data1[index + 17]['song_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        Container(
                                          width: 158.0,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data1[index + 17]['artist'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    //physics: ClampingScrollPhysics(),
                    //shrinkWrap: true,
                    //scrollDirection: Axis.horizontal,
                    itemCount: 24,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MusicsDetail(
                                lyrics: data1[index]['song_lyric'],
                                mp3url: data1[index]['mp3_download'],
                                songName: data1[index]['song_name'],
                                artistName: data1[index]['artist'],
                                year: data1[index]['year'],
                                listenNumbers: data1[index]['listen_number'],
                                alt_download: data1[index]['alt_download'],
                                imageName: data1[index]['image'],
                              );
                            }));
                          },
                          child: Expanded(
                            child: Container(
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 85,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade700,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 90.0,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                    width: 180.0,
                                                    child: Text(
                                                      data1[index]['song_name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Container(
                                                          width: 200,
                                                          child: Text(
                                                            data1[index]
                                                                ['artist'],
                                                            style: TextStyle(
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: Text(
                                                          data1[index]['year'],
                                                          style: TextStyle(
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 35.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          data1[index]['image'],
                                          height: 70.0,
                                          width: 70.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                //////favorites
                items.length == 0
                    ? Center(
                        child: Text("Your Favorites"),
                      )
                    : ListView.builder(
                        //physics: ClampingScrollPhysics(),
                        //shrinkWrap: true,
                        //scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(items.length);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MusicsDetail(
                                    lyrics: items[index].songLyrics,
                                    mp3url: items[index].mp3Download,
                                    songName: items[index].musicName,
                                    artistName: items[index].artistName,
                                    year: items[index].year,
                                    alt_download: items[index].altdown,
                                    imageName: items[index].image,
                                  );
                                }));
                              },
                              child: Expanded(
                                child: Container(
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 85,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            //color: Color(0xFF242A39),
                                            color: Colors.grey.shade700,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 90.0,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                        width: 180.0,
                                                        child: Text(
                                                          items[index]
                                                              .musicName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Container(
                                                              width: 200,
                                                              child: Text(
                                                                items[index]
                                                                    .artistName,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              items[index].year,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  size: 35.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              items[index].image,
                                              height: 70.0,
                                              width: 70.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                ////////
              ],
            ),
            bottomNavigationBar: Material(
              color: Color(0xFF0B0424),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabControl,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                    text: "Home",
                  ),
                  Tab(
                    icon: Icon(FontAwesomeIcons.music),
                    text: "New",
                  ),
                  Tab(
                    icon: Icon(Icons.favorite_border),
                    text: "Favorites",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
