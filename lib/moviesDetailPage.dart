import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'moviePlayer.dart';

class MoviesDetail extends StatefulWidget {
  final url, gener1, gener2, index;
  final imageName;
  final mName;
  final des;
  final rating;
  final year;
  final quality;
  final size;
  final country;
  final language;
  final data1;
  final altDown, t720p, t1080p;
  MoviesDetail(
      {this.url,
      this.data1,
      this.index,
      this.gener2,
      this.gener1,
      this.imageName,
      this.mName,
      this.des,
      this.rating,
      this.quality,
      this.year,
      this.size,
      this.country,
      this.language,
      this.altDown,
      this.t720p,
      this.t1080p});

  @override
  _MoviesDetailState createState() => _MoviesDetailState();
}

class _MoviesDetailState extends State<MoviesDetail> {
  var urlname;
  int index;
  dynamic data1;
  String gener2, gener1;
  String image;
  String movieName;
  String description;
  String imdb;
  String year;
  String quality;
  String sizefile, country, language, altDown, t720p, t1080p;

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
    index = widget.index;
    data1 = widget.data1;
    gener2 = widget.gener2;
    gener1 = widget.gener1;
    urlname = widget.url;
    print(urlname);
    image = widget.imageName;
    movieName = widget.mName;
    print(movieName);
    description = widget.des;
    imdb = widget.rating;
    year = widget.year;
    quality = widget.quality;
    sizefile = widget.size;
    country = widget.country;
    language = widget.language;
    altDown = widget.altDown;
    print(altDown);
    t1080p = widget.t1080p;
    t720p = widget.t720p;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.6,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    height: size.height * 0.8 - 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //_launchURLBrowser(urlname);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyAppScaffold(
                          videoUrl: urlname,
                        );
                      }));
                    },
                    child: Icon(
                      Icons.play_arrow,
                      size: 60,
                      semanticLabel: 'play button',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 300,
                              child: Text(
                                movieName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 30),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Container(
                                width: 30,
                                color: Colors.red,
                                child: Column(
                                  children: [
                                    Text(
                                      "⭐",
                                    ),
                                    Text(
                                      imdb,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Releasing Year: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      year,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "File Size: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      sizefile,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Quality: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      quality,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Country: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 200,
                                      child: Text(
                                        country == "" ? "N/A" : country,
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 30,
                            child: ListView.builder(
                                //physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data1[index]['gener'].length,
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  print(data1[index]['gener'][index1]);
                                  return Flexible(
                                    child: Container(
                                      width: 120,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(.3),
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child:
                                            Text(data1[index]['gener'][index1]),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        ////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      //_launchURLBrowser(altDown);
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              BottomDownloadList(
                                                download: altDown,
                                                t720p: t720p,
                                                t1080p: t1080p,
                                              ));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.arrow_downward),
                                        Text(
                                          "Download",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              BottomSubtitleButton(
                                                data2: data1,
                                                index2: index,
                                              ));
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.arrow_downward),
                                        Text(
                                          "Subtitle",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Overview ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 23),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Container(
                            child: Text(
                              description,
                              style: TextStyle(),
                            ),
                          ),
                        ),
                        //////
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                                //physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data1[index]['screenshot'].length,
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  print(data1[index]['screenshot'][index1]);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          data1[index]['screenshot'][index1],
                                        )),
                                  );
                                }),
                          ),
                        ),
                        //////
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
}

class BottomDownloadList extends StatefulWidget {
  final download;
  final t720p;
  final t1080p;

  BottomDownloadList({this.download, this.t720p, this.t1080p});

  @override
  _BottomDownloadListState createState() => _BottomDownloadListState();
}

class _BottomDownloadListState extends State<BottomDownloadList> {
  String download;
  String t720p;
  String t1080p;

  @override
  void initState() {
    download = widget.download;
    t720p = widget.download;
    t1080p = widget.t1080p;
    // TODO: implement initState
    super.initState();
  }

  void _launchURLBrowser(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld);
    } else {
      throw 'could not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DOWNLOADS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  _launchURLBrowser(download);
                },
                child: ListTile(
                  title: Text("Direct Download"),
                  trailing: Icon(Icons.arrow_downward),
                ),
              ),
              Divider(),
              FlatButton(
                onPressed: () {
                  _launchURLBrowser(t720p);
                },
                child: ListTile(
                  title: Text("Torrent 720p"),
                  trailing: Icon(Icons.arrow_downward),
                ),
              ),
              Divider(),
              FlatButton(
                onPressed: () {
                  _launchURLBrowser(t1080p);
                },
                child: ListTile(
                  title: Text("Torrent 1080p"),
                  trailing: Icon(Icons.arrow_downward),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSubtitleButton extends StatefulWidget {
  final data2, index2;
  BottomSubtitleButton({this.data2, this.index2});
  @override
  _BottomSubtitleButtonState createState() => _BottomSubtitleButtonState();
}

class _BottomSubtitleButtonState extends State<BottomSubtitleButton> {
  void _launchURLBrowser(String url) async {
    String urld = url;
    if (await canLaunch(urld)) {
      await launch(urld);
    } else {
      throw 'could not launch url';
    }
  }

  dynamic data1;
  int index1;

  @override
  void initState() {
    data1 = widget.data2;
    index1 = widget.index2;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUBTITLES"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 200,
          child: data1[index1]['subtitles'].length == 0
              ? Center(
                  child: Text(
                  "No Subtitles",
                  textAlign: TextAlign.center,
                ))
              : ListView.builder(
                  itemCount: data1[index1]['subtitles'].length,
                  itemBuilder: (BuildContext context, int index) {
                    print(data1[index1]['subtitles'][index]);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonTheme(
                        minWidth: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              _launchURLBrowser(
                                  data1[index1]['subtitles_link'][index]);
                            },
                            color: Colors.blue,
                            child: Text(data1[index1]['subtitles'][index]),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
