import 'dart:math';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:world_src_app/apkDetailPage.dart';
import 'package:world_src_app/apk_page.dart';
import 'package:world_src_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_src_app/moviepage.dart';
import 'package:world_src_app/musicDetailPage.dart';
import 'package:world_src_app/musicpage.dart';
import 'package:world_src_app/search_page.dart';
import 'networking.dart';
import 'loading_page.dart';
import 'homepage.dart';
import 'package:loading/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moviesDetailPage.dart';

class loadingSearch extends StatefulWidget {
  final searchKeyword, type;
  loadingSearch({this.type, this.searchKeyword});
  @override
  _loadingSearchState createState() => _loadingSearchState();
}

class _loadingSearchState extends State<loadingSearch> {
  String token1;
  String searchKeyword, type;
  @override
  void initState() {
    searchKeyword = widget.searchKeyword;
    type = widget.type;
    print(searchKeyword);
    print(type);
    getTokenForAPI().then((value) {
      token1 = value.toString();
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
        'https://www.worldsrc.net/apps_1/search?t=$type&s=$searchKeyword&f=$token1');

    var controlData = await networkHelper.getData();
    print(controlData.length);
    if (controlData.length == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SearchNotFound(
          keyword: searchKeyword,
        );
      }));
      print(controlData.length);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SearchPage(
          searchControl: controlData,
          keyword: searchKeyword,
          type: type,
        );
      }));
    }
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

class SearchPage extends StatefulWidget {
  final searchControl;
  final keyword;
  final type;
  SearchPage({this.searchControl, this.keyword, this.type});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  dynamic data1;
  String keyword;
  String type;
  @override
  void initState() {
    keyword = widget.keyword;
    data1 = widget.searchControl;
    type = widget.type;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search Results"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (type == "movie") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return loadingScreenMovies();
                }));
              }
              if (type == "music") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return loadingScreenMusic();
                }));
              }
              if (type == "apk") {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return loadingScreenAPK();
                }));
              }
            },
          ),
        ),
        body: data1.length != 0
            ? ListView.builder(
                //physics: ClampingScrollPhysics(),
                //shrinkWrap: true,
                //scrollDirection: Axis.horizontal,
                itemCount: data1.length,
                itemBuilder: (BuildContext context, int index) {
                  if (type == "movie") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MoviesDetail(
                              data1: data1,
                              index: index,
                              url: data1[index]['url_download'],
                              imageName: data1[index]['image'],
                              mName: data1[index]['movie_name'],
                              des: data1[index]['descrption'],
                              rating: data1[index]['imdb_rate'],
                              year: data1[index]['year'],
                              quality: data1[index]['quality'],
                              size: data1[index]['size'],
                              country: data1[index]['country'],
                              language: data1[index]['language'],
                              altDown: data1[index]['alt_download'],
                              t720p: data1[index]['torrent_720_down'],
                              t1080p: data1[index]['torrent_1080_down'],
                            );
                          }));
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 115.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                              width: 200.0,
                                              child: Text(
                                                data1[index]['movie_name'],
                                                overflow: TextOverflow.ellipsis,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    data1[index]['imdb_rate'] +
                                                        " ⭐",
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                      data1[index]['year']),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      data1[index]['image'],
                                      height: 140.0,
                                      width: 100.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (type == "music") {
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
                                    height: 75,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF242A39),
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
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        data1[index]['artist'],
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                  }
                  if (type == "apk") {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApkDetailPage(
                              fileSize: data1[index]['size'],
                              downloads: data1[index]['download_number'],
                              icon: data1[index]['icon'],
                              developer: data1[index]['developer'],
                              version: data1[index]['version'],
                              appname: data1[index]['apk_name'],
                              graphicImage: data1[index]['graphic'],
                              image1: data1[index]['screenshots'][0],
                              image2: data1[index]['screenshots'][1],
                              description: data1[index]['descrption'],
                              dUrl: data1[index]['download'],
                            );
                          }));
                        },
                        child: Container(
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: <Widget>[
                              Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFF242A39),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 115.0,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                              width: 200.0,
                                              child: Text(
                                                data1[index]['apk_name'],
                                                overflow: TextOverflow.ellipsis,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(
                                                      " V" +
                                                          data1[index]
                                                              ['version'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color:
                                                              Colors.white38),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      data1[index]['icon'],
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                })
            : Center(
                child: Text(
                "Your Search Result \' $keyword \' not found ",
                style: TextStyle(color: Colors.blue),
              )),
      ),
    );
  }
}

class SearchNotFound extends StatelessWidget {
  final keyword;
  SearchNotFound({this.keyword});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search Result"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return loadingScreen();
              }));
            },
          ),
        ),
        body: Container(
          child: Center(
              child:
                  Text("Your Search Keyword \' $keyword \' is not found !!!")),
        ),
      ),
    );
  }
}
