import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:world_src_app/MyTheme.dart';
//import 'package:world_src_app/SearchTest.dart';
import 'package:world_src_app/apkDetailPage.dart';
import 'package:world_src_app/musicDetailPage.dart';
import 'package:world_src_app/networking.dart';
import 'package:world_src_app/search_page.dart';
import 'apk_page.dart';
import 'moviepage.dart';
import 'musicpage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moviesDetailPage.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
//import 'videoplayer.dart';

class homepage extends StatefulWidget {
  final homepageControl;
  homepage({this.homepageControl});

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage>
    with SingleTickerProviderStateMixin {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldStatei>();
  FancyDrawerController _controller;
  dynamic data1;
  bool changeBrightness = false;
  String typeSection = "movie";
  bool isSearching = false;
  List<bool> isSelected;
  bool isSwitched = false;
  @override
  void initState() {
    isSelected = [true, false];
    data1 = widget.homepageControl;
    //////////
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool isDarkModeEnabled = false;

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
          //ThemeBuilder.of(context).changeTheme();
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
                      // color: Color(0xFFBDDFF8),
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
                      //color: Color(0xFFBDDFF8),
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
                  ? Text(
                      "WorldSrc",
                      style: TextStyle(fontSize: 25.0),
                    )
                  : Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
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
                                hintText: "Search $typeSection....",
                                hintStyle: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              elevation: 15,
                              value: typeSection,
                              underline: Container(
                                color: Colors.transparent,
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  typeSection = value;
                                });
                              },
                              items: <String>['movie', 'music', 'apk']
                                  .map((String value) {
                                return DropdownMenuItem(
                                    child: Text(value), value: value);
                              }).toList(),
                            ),
                          ),
                        ],
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
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider.builder(
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Expanded(
                                child: Image.network(
                                  data1[index]['image'],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Center(
                              child: Container(
                                width: 300,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      data1[index]['movie_name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  data1[index]['imdb_rate'] + " ⭐",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  data1[index]['year'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      aspectRatio: 21 / 9,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      initialPage: 0,
                      viewportFraction: 0.7,
                      height: 570,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Text(
                              "New Movies",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return loadingScreenMovies();
                              }));
                            },
                            child: Text(
                              "Show All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13.0),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 280,
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MoviesDetail(
                                    data1: data1,
                                    index: index + 8,
                                    url: data1[index + 8]['url_download'],
                                    imageName: data1[index + 8]['image'],
                                    mName: data1[index + 8]['movie_name'],
                                    des: data1[index + 8]['descrption'],
                                    rating: data1[index + 8]['imdb_rate'],
                                    year: data1[index + 8]['year'],
                                    quality: data1[index + 8]['quality'],
                                    size: data1[index + 8]['size'],
                                    country: data1[index + 8]['country'],
                                    language: data1[index + 8]['language'],
                                    altDown: data1[index + 8]['alt_download'],
                                    t720p: data1[index + 8]['torrent_720_down'],
                                    t1080p: data1[index + 8]
                                        ['torrent_1080_down'],
                                  );
                                }));
                              },
                              child: Container(
                                //color: Color(0xFF2B2B2B),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 3,
                                                color: Color(0xFF242A39)),
                                          ),
                                          child: Image.network(
                                            data1[index + 8]['image'],
                                            height: 200.0,
                                            width: 135.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                data1[index + 8]['imdb_rate'] +
                                                    "⭐",
                                                style: TextStyle(
                                                    backgroundColor:
                                                        Colors.green),
                                              ),
                                              SizedBox(
                                                width: 54,
                                              ),
                                              Text(
                                                data1[index + 8]['year'],
                                                style: TextStyle(
                                                    backgroundColor:
                                                        Colors.red),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 145.0,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data1[index + 8]['movie_name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
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
                              "New Music",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return loadingScreenMusic();
                              }));
                            },
                            child: Text(
                              "Show All",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13.0),
                            )),
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
                          itemCount: 8,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MusicsDetail(
                                    lyrics: data1[index + 16]['song_lyric'],
                                    mp3url: data1[index + 16]['mp3_download'],
                                    songName: data1[index + 16]['song_name'],
                                    artistName: data1[index + 16]['artist'],
                                    year: data1[index + 16]['year'],
                                    listenNumbers: data1[index + 16]
                                        ['listen_number'],
                                    alt_download: data1[index + 16]
                                        ['alt_download'],
                                    imageName: data1[index + 16]['image'],
                                  );
                                }));
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            data1[index + 16]['image'],
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
                                              data1[index + 16]['year'],
                                              style: TextStyle(
                                                  backgroundColor: Colors.red),
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
                                        data1[index + 16]['song_name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Container(
                                      width: 158.0,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        data1[index + 16]['artist'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.grey),
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
                              "New APK",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return loadingScreenAPK();
                            }));
                          },
                          child: Text(
                            "Show All",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 13.0),
                          ),
                        ),
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
                          itemCount: 8,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ApkDetailPage(
                                    fileSize: data1[index + 24]['size'],
                                    downloads: data1[index + 24]
                                        ['download_number'],
                                    icon: data1[index + 24]['icon'],
                                    developer: data1[index + 24]['developer'],
                                    version: data1[index + 24]['version'],
                                    appname: data1[index + 24]['apk_name'],
                                    graphicImage: data1[index + 24]['graphic'],
                                    image1: data1[index + 24]['screenshots'][0],
                                    image2: data1[index + 24]['screenshots'][1],
                                    description: data1[index + 24]
                                        ['descrption'],
                                    dUrl: data1[index + 24]['download'],
                                  );
                                }));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          data1[index + 24]['icon'],
                                          height: 145.0,
                                          width: 150.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "V" + data1[index + 24]['version'],
                                          style: TextStyle(
                                              backgroundColor: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 158.0,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      data1[index + 24]['apk_name'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
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
