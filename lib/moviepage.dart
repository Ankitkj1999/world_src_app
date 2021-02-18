import 'dart:math';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:world_src_app/MyTheme.dart';
import 'package:world_src_app/apk_page.dart';
import 'package:world_src_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_src_app/models/databaseHelper.dart';
import 'package:world_src_app/models/movie.dart';
import 'package:world_src_app/musicpage.dart';
import 'package:world_src_app/search_page.dart';
import 'networking.dart';
import 'loading_page.dart';
import 'homepage.dart';
import 'package:loading/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moviesDetailPage.dart';

class loadingScreenMovies extends StatefulWidget {
  @override
  _loadingScreenMoviesState createState() => _loadingScreenMoviesState();
}

class _loadingScreenMoviesState extends State<loadingScreenMovies> {
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
    print(token1);
    NetworkHelper networkHelper = NetworkHelper(
        'https://www.worldsrc.net/apps_1/movies_home_1?m=1&t=$token1');

    var controlData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MoviesListPage(
        moviesControl: controlData,
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

class MoviesListPage extends StatefulWidget {
  final moviesControl;
  MoviesListPage({this.moviesControl});

  @override
  _MoviesListPageState createState() => _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage>
    with TickerProviderStateMixin {
  bool isSearching = false;
  FancyDrawerController _controller;
  TabController _tabControl;
  dynamic data1;
  String typeSection = "movie";
  bool isSaved = false;
  int selectedIndex;
  bool changeBrightness = false;
  bool touch = false;
  var _selectedIndex = 0;

  DatabaseHelper db = new DatabaseHelper();
  List<Movie> items = new List();
  @override
  void initState() {
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    _tabControl = TabController(length: 3, vsync: this);
    data1 = widget.moviesControl;
    //print(data1.length);
    // TODO: implement initState

    db.getAllmovies().then((movies) {
      setState(() {
        movies.forEach((movie) {
          items.add(Movie.fromMap(movie));
        });
      });
    });
    //print(items[0].imdb);
    super.initState();
  }

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
                  ? Text("Movies")
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
                        hintText: "Search Movie....",
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
                      CarouselSlider.builder(
                        itemCount: 14,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MoviesDetail(
                                  data1: data1,
                                  index: index + 15,
                                  url: data1[index + 15]['url_download'],
                                  imageName: data1[index + 15]['image'],
                                  mName: data1[index + 15]['movie_name'],
                                  des: data1[index + 15]['descrption'],
                                  rating: data1[index + 15]['imdb_rate'],
                                  year: data1[index + 15]['year'],
                                  quality: data1[index + 15]['quality'],
                                  size: data1[index + 15]['size'],
                                  country: data1[index + 15]['country'],
                                  language: data1[index + 15]['language'],
                                  altDown: data1[index + 15]['alt_download'],
                                  t720p: data1[index + 15]['torrent_720_down'],
                                  t1080p: data1[index + 15]
                                      ['torrent_1080_down'],
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
                                      data1[index + 15]['image'],
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
                                          data1[index + 15]['movie_name'],
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
                                      data1[index + 15]['imdb_rate'] + " ⭐",
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
                                      data1[index + 15]['year'],
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
                        height: 275,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 15,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MoviesDetail(
                                        data1: data1,
                                        index: index + 30,
                                        url: data1[index + 30]['url_download'],
                                        imageName: data1[index + 30]['image'],
                                        mName: data1[index + 30]['movie_name'],
                                        des: data1[index + 30]['descrption'],
                                        rating: data1[index + 30]['imdb_rate'],
                                        year: data1[index + 30]['year'],
                                        quality: data1[index + 30]['quality'],
                                        size: data1[index + 30]['size'],
                                        country: data1[index + 30]['country'],
                                        language: data1[index + 30]['language'],
                                        altDown: data1[index + 30]
                                            ['alt_download'],
                                        t720p: data1[index + 30]
                                            ['torrent_720_down'],
                                        t1080p: data1[index + 30]
                                            ['torrent_1080_down'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    //color: Color(0xFF2B2B2B),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                data1[index + 30]['image'],
                                                height: 200.0,
                                                width: 135.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    data1[index + 30]
                                                            ['imdb_rate'] +
                                                        "⭐",
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            Colors.green),
                                                  ),
                                                  SizedBox(
                                                    width: 54,
                                                  ),
                                                  Text(
                                                    data1[index + 30]['year'],
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
                                            data1[index + 30]['movie_name'],
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
                        height: 275,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 15,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MoviesDetail(
                                        data1: data1,
                                        index: index + 45,
                                        url: data1[index + 45]['url_download'],
                                        imageName: data1[index + 45]['image'],
                                        mName: data1[index + 45]['movie_name'],
                                        des: data1[index + 45]['descrption'],
                                        rating: data1[index + 45]['imdb_rate'],
                                        year: data1[index + 45]['year'],
                                        quality: data1[index + 45]['quality'],
                                        size: data1[index + 45]['size'],
                                        country: data1[index + 45]['country'],
                                        language: data1[index + 45]['language'],
                                        altDown: data1[index + 45]
                                            ['alt_download'],
                                        t720p: data1[index + 45]
                                            ['torrent_720_down'],
                                        t1080p: data1[index + 45]
                                            ['torrent_1080_down'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    //color: Color(0xFF2B2B2B),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                data1[index + 45]['image'],
                                                height: 200.0,
                                                width: 135.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    data1[index + 45]
                                                            ['imdb_rate'] +
                                                        "⭐",
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            Colors.green),
                                                  ),
                                                  SizedBox(
                                                    width: 54,
                                                  ),
                                                  Text(
                                                    data1[index + 45]['year'],
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
                                            data1[index + 45]['movie_name'],
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
                        height: 275,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 15,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MoviesDetail(
                                        data1: data1,
                                        index: index + 60,
                                        url: data1[index + 60]['url_download'],
                                        imageName: data1[index + 60]['image'],
                                        mName: data1[index + 60]['movie_name'],
                                        des: data1[index + 60]['descrption'],
                                        rating: data1[index + 60]['imdb_rate'],
                                        year: data1[index + 60]['year'],
                                        quality: data1[index + 60]['quality'],
                                        size: data1[index + 60]['size'],
                                        country: data1[index + 60]['country'],
                                        language: data1[index + 60]['language'],
                                        altDown: data1[index + 60]
                                            ['alt_download'],
                                        t720p: data1[index + 60]
                                            ['torrent_720_down'],
                                        t1080p: data1[index + 60]
                                            ['torrent_1080_down'],
                                      );
                                    }));
                                  },
                                  child: Container(
                                    //color: Color(0xFF2B2B2B),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                data1[index + 60]['image'],
                                                height: 200.0,
                                                width: 135.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    data1[index + 60]
                                                            ['imdb_rate'] +
                                                        "⭐",
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            Colors.green),
                                                  ),
                                                  SizedBox(
                                                    width: 54,
                                                  ),
                                                  Text(
                                                    data1[index + 60]['year'],
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
                                            data1[index + 60]['movie_name'],
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
                    ],
                  ),
                ),
                ListView.builder(
                    //physics: ClampingScrollPhysics(),
                    //shrinkWrap: true,
                    //scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
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
                                                MainAxisAlignment.spaceBetween,
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
                                                      data1[index]
                                                              ['imdb_rate'] +
                                                          " ⭐",
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                        data1[index]['year']),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isSaved &&
                                                          selectedIndex == index
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isSaved &&
                                                          selectedIndex == index
                                                      ? Colors.red
                                                      : null,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isSaved) {
                                                      selectedIndex = index;
                                                      isSaved = false;
                                                    } else {
                                                      db.savemovie(Movie(
                                                        data1[index]
                                                            ['movie_name'],
                                                        data1[index]
                                                            ['descrption'],
                                                        data1[index]
                                                            ['url_download'],
                                                        data1[index]
                                                            ['imdb_rate'],
                                                        data1[index]['year'],
                                                        data1[index]['image'],
                                                        data1[index][
                                                            'torrent_1080_down'],
                                                        data1[index][
                                                            'torrent_720_down'],
                                                        data1[index]['country'],
                                                        data1[index]['quality'],
                                                        data1[index]
                                                            ['language'],
                                                        data1[index]['size'],
                                                        data1[index]
                                                            ['alt_download'],
                                                      ));
                                                      selectedIndex = index;
                                                      isSaved = true;
                                                    }
                                                  });
                                                },
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
                    }),
                //////
                items.length == 0
                    ? Center(
                        child: Text("Your Favorites"),
                      )
                    : SizedBox(
                        height: 230,
                        child: ListView.builder(
                            //physics: ClampingScrollPhysics(),
                            //shrinkWrap: true,
                            //scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          borderRadius:
                                              BorderRadius.circular(3),
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
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                      width: 200.0,
                                                      child: Text(
                                                        items[index].movieName,
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
                                                          child: Text(
                                                            items[index].imdb +
                                                                " ⭐",
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                              items[index]
                                                                  .year),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
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
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.network(
                                              items[index].image == null
                                                  ? "https//i.pinimg.com/originals/aa/f7/05/aaf705e06726ce3881288ae4be3ac5fe.jpg"
                                                  : items[index].image,
                                              height: 140.0,
                                              width: 100.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                //////////
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
                    icon: Icon(FontAwesomeIcons.film),
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
