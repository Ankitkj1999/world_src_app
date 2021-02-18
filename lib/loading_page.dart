import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:world_src_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'networking.dart';
import 'package:loading/loading.dart';

class GetTokenHomepage extends StatefulWidget {
  @override
  _GetTokenHomepageState createState() => _GetTokenHomepageState();
}

class _GetTokenHomepageState extends State<GetTokenHomepage> {
  String getToken;
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    NetworkHelper networkHelper =
        NetworkHelper('https://www.worldsrc.net/apps_1/get_token');

    var controlData = await networkHelper.getData();
    print(controlData[0]['token']);
    getToken = controlData[0]['token'];
    setTokenForAPI();
    //print(controlData.toString());
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CheckVersion();
    }));
  }

//loadingScreen()
  setTokenForAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'token',
      getToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Loading(
            indicator: BallPulseIndicator(),
            size: 50.0,
            color: Colors.white,
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CheckVersion extends StatefulWidget {
  @override
  _CheckVersionState createState() => _CheckVersionState();
}

class _CheckVersionState extends State<CheckVersion> {
  dynamic data2;
  String status;
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void _launchURLBrowser(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld);
    } else {
      throw 'could not launch url';
    }
  }

  void getLocationData() async {
    NetworkHelper networkHelper =
        NetworkHelper('https://www.worldsrc.net/apps_1/check_version');

    var controlData = await networkHelper.getData();
    status = controlData[0]['status'];

    if (status == "0") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return loadingScreen();
      }));
    }

    if (status == "1") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Version Update",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      "Version: " + controlData[0]['versions'],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Release at: " + controlData[0]['release_at'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "What's New:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "- " + controlData[0]['new'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _launchURLBrowser(
                      controlData[0]['link_download'],
                    );
                  },
                ),
                FlatButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return loadingScreen();
                    }));
                  },
                ),
              ],
            );
          });
    }
    //print(data2[0]['status']);
    //print(controlData[0]["year"]);
//    Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return homepage(
//        homepageControl: controlData,
//      );
//    }));
  }

  @override
  Widget build(BuildContext context) {
    print(status);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(),
      ),
    );
  }
}

class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  String token1;

  @override
  void initState() {
    getTokenForAPI().then((value) {
      token1 = value.toString();
      print(value.runtimeType);
      print(value);
      print(token1);
      print("https://www.worldsrc.net/apps_1/home?m=1&t=$token1");
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
    //print(token0[0]['token']);
    //String token1 = "Fe193C37823f458A79E81B5eee5B9392e50";
    print("https://www.worldsrc.net/apps_1/home?m=1&t=$token1");
    NetworkHelper networkHelper =
        NetworkHelper('https://www.worldsrc.net/apps_1/home?m=1&t=$token1');
    // print("https://www.worldsrc.net/apps_1/home?m=1&t=$token1");
    var controlData = await networkHelper.getData();

    //print(controlData[0]["year"]);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return homepage(
        homepageControl: controlData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    //print(token0[0]['token']);
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
