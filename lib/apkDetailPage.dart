import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:world_src_app/models/apk.dart';
import 'package:world_src_app/models/databaseHelperApk.dart';

class ApkDetailPage extends StatefulWidget {
  final dUrl,
      icon,
      developer,
      version,
      appname,
      downloads,
      fileSize,
      graphicImage,
      image1,
      image2,
      description;

  ApkDetailPage(
      {this.dUrl,
      this.graphicImage,
      this.description,
      this.image2,
      this.image1,
      this.downloads,
      this.icon,
      this.fileSize,
      this.developer,
      this.version,
      this.appname});

  @override
  _ApkDetailPageState createState() => _ApkDetailPageState();
}

class _ApkDetailPageState extends State<ApkDetailPage> {
  String icon,
      dUrl,
      image1,
      description,
      image2,
      developer,
      version,
      appname,
      downloads,
      fileSize,
      graphicImage;

  bool isSaved = false;
  DatabaseHelperApk db = new DatabaseHelperApk();

  void _launchURLBrowser(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld);
    } else {
      throw 'could not launch url';
    }
  }

  @override
  void initState() {
    dUrl = widget.dUrl;
    description = widget.description;
    image2 = widget.image2;
    image1 = widget.image1;
    graphicImage = widget.graphicImage;
    fileSize = widget.fileSize;
    downloads = widget.downloads;
    appname = widget.appname;
    icon = widget.icon;
    developer = widget.developer;
    version = widget.version;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appname),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: 220.0,
                                    child: Text(
                                      appname,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              developer,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "V " + version,
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isSaved
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isSaved ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isSaved) {
                                            isSaved = false;
                                          } else {
                                            isSaved = true;
                                            db.saveapk(Apk(
                                                appname,
                                                description,
                                                dUrl,
                                                image2,
                                                icon,
                                                developer,
                                                graphicImage,
                                                version,
                                                fileSize,
                                                downloads,
                                                image1));
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
                          padding: const EdgeInsets.all(7.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              icon,
                              height: 90.0,
                              width: 90.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IntrinsicHeight(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.download_sharp),
                            Text(
                              fileSize,
                              style: TextStyle(),
                            )
                          ],
                        ),
                        VerticalDivider(
                          //color: Colors.white54,
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(downloads),
                            Text(
                              "Downloads",
                              style: TextStyle(),
                            )
                          ],
                        ),
                        VerticalDivider(
                          //color: Colors.white54,
                          width: 20,
                        ),
                        Column(
                          children: [
                            Icon(Icons.settings_applications),
                            Container(
                              width: 60,
                              child: Text(
                                "V " + version,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ButtonTheme(
                minWidth: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      _launchURLBrowser(dUrl);
                    },
                    color: Colors.green,
                    child: Text("APK Download"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    //physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(graphicImage)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(image1)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(image2)),
                      ),
                    ],
                  ),
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
                          "About this app",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      //color: Colors.white54,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Container(
                  child: Text(
                    description,
                    style: TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
