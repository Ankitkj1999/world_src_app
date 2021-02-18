import 'dart:math';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_src_app/MyTheme.dart';
import 'package:world_src_app/apkDetailPage.dart';
import 'package:world_src_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_src_app/models/apk.dart';
import 'package:world_src_app/models/databaseHelperApk.dart';
import 'package:world_src_app/moviepage.dart';
import 'package:world_src_app/musicpage.dart';
import 'package:world_src_app/search_page.dart';
import 'networking.dart';
import 'loading_page.dart';
import 'homepage.dart';
import 'package:loading/loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'moviesDetailPage.dart';

class loadingScreenAPK extends StatefulWidget {
  @override
  _loadingScreenAPKState createState() => _loadingScreenAPKState();
}

class _loadingScreenAPKState extends State<loadingScreenAPK> {
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
    NetworkHelper networkHelper =
        NetworkHelper('https://www.worldsrc.net/apps_1/apk_home?m=1&t=$token1');

    var controlData = await networkHelper.getData();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return APKListPage(
        APKControl: controlData,
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

class APKListPage extends StatefulWidget {
  final APKControl;
  APKListPage({this.APKControl});

  @override
  _APKListPageState createState() => _APKListPageState();
}

class _APKListPageState extends State<APKListPage>
    with TickerProviderStateMixin {
  FancyDrawerController _controller;
  bool isSearching = false;
  String typeSection = "apk";
  TabController _tabControl;
  dynamic data1;
  bool isSaved = false;
  int selectedIndex;
  DatabaseHelperApk db = new DatabaseHelperApk();
  List<Apk> items = new List();

  bool touch = false;
  var _selectedIndex = 0;

  @override
  void initState() {
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    db.getAllapks().then((apks) {
      setState(() {
        apks.forEach((apk) {
          items.add(Apk.fromMap(apk));
        });
      });
    });

    print(items.length);

    _tabControl = TabController(length: 3, vsync: this);
    data1 = widget.APKControl;
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
                  ? Text("APK")
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
                        hintText: "Search APK....",
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
                        itemCount: 8,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      data1[index]['graphic'],
                                      //height: 130.0,
                                      //width: 300.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "V" + data1[index]['version'],
                                      style: TextStyle(
                                          backgroundColor: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 250.0,
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  data1[index]['apk_name'],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.blue.withOpacity(0.5),
                                  ),
                                  //overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                        options: CarouselOptions(
                          //aspectRatio: 21 / 14,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          initialPage: 0,
                          viewportFraction: 0.8,
                          height: 230,
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
                                  "Top Paid",
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
                        height: 230,
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApkDetailPage(
                                        fileSize: data1[index + 8]['size'],
                                        downloads: data1[index + 8]
                                            ['download_number'],
                                        icon: data1[index + 8]['icon'],
                                        developer: data1[index + 8]
                                            ['developer'],
                                        version: data1[index + 8]['version'],
                                        appname: data1[index + 8]['apk_name'],
                                        graphicImage: data1[index + 8]
                                            ['graphic'],
                                        image1: data1[index + 8]['screenshots']
                                            [0],
                                        image2: data1[index + 8]['screenshots']
                                            [1],
                                        description: data1[index + 8]
                                            ['descrption'],
                                        dUrl: data1[index + 8]['download'],
                                      );
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              data1[index + 8]['icon'],
                                              height: 145.0,
                                              width: 150.0,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "V" + data1[index + 8]['version'],
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
                                          data1[index + 8]['apk_name'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
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
                        height: 230,
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
                                        fileSize: data1[index + 16]['size'],
                                        downloads: data1[index + 16]
                                            ['download_number'],
                                        icon: data1[index + 16]['icon'],
                                        developer: data1[index + 16]
                                            ['developer'],
                                        version: data1[index + 16]['version'],
                                        appname: data1[index + 16]['apk_name'],
                                        graphicImage: data1[index + 16]
                                            ['graphic'],
                                        image1: data1[index + 16]['screenshots']
                                            [0],
                                        image2: data1[index + 16]['screenshots']
                                            [1],
                                        description: data1[index + 16]
                                            ['descrption'],
                                        dUrl: data1[index + 16]['download'],
                                      );
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              data1[index + 16]['icon'],
                                              height: 145.0,
                                              width: 150.0,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "V" +
                                                  data1[index + 16]['version'],
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
                                          data1[index + 16]['apk_name'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
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
                        height: 230,
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
                                        developer: data1[index + 24]
                                            ['developer'],
                                        version: data1[index + 24]['version'],
                                        appname: data1[index + 24]['apk_name'],
                                        graphicImage: data1[index + 24]
                                            ['graphic'],
                                        image1: data1[index + 24]['screenshots']
                                            [0],
                                        image2: data1[index + 24]['screenshots']
                                            [1],
                                        description: data1[index + 24]
                                            ['descrption'],
                                        dUrl: data1[index + 24]['download'],
                                      );
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              "V" +
                                                  data1[index + 24]['version'],
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
                ListView.builder(
                    //physics: ClampingScrollPhysics(),
                    //shrinkWrap: true,
                    //scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ApkDetailPage(
                                fileSize: data1[index + 24]['size'],
                                downloads: data1[index + 24]['download_number'],
                                icon: data1[index + 24]['icon'],
                                developer: data1[index + 24]['developer'],
                                version: data1[index + 24]['version'],
                                appname: data1[index + 24]['apk_name'],
                                graphicImage: data1[index + 24]['graphic'],
                                image1: data1[index + 24]['screenshots'][0],
                                image2: data1[index + 24]['screenshots'][1],
                                description: data1[index + 24]['descrption'],
                                dUrl: data1[index + 24]['download'],
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
//                                    color: Color(0xFF242A39),
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
                                                  data1[index + 24]['apk_name'],
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
                                                    child: Container(
                                                      width: 200,
                                                      child: Text(
                                                        " V" +
                                                            data1[index + 24]
                                                                ['version'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                        data1[index + 24]['icon'],
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
                    }),
                items.length == 0
                    ? Center(
                        child: Text("Your Favorites"),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ApkDetailPage(
                                    fileSize: items[index].fileSize,
                                    downloads: items[index].downloads,
                                    icon: items[index].icon,
                                    developer: items[index].developer,
                                    version: items[index].version,
                                    appname: items[index].apkName,
                                    graphicImage: items[index].graphicImage,
                                    image1: items[index].image1,
                                    image2: items[index].image2,
                                    description: items[index].description,
                                    dUrl: items[index].dUrl,
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
//                                        color: Color(0xFF242A39),
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
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                    width: 200.0,
                                                    child: Text(
                                                      items[index].apkName,
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
                                                            " V" +
                                                                items[index]
                                                                    .version,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .white38),
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
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.network(
                                            items[index].icon,
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
                        }),
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
                    icon: Icon(FontAwesomeIcons.android),
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
