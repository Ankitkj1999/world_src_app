import 'dart:convert';
import 'loading_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:world_src_app/MyTheme.dart';

main() {
  runApp(mainPage());
}

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.dark,
      ScaffoldBackground: Color(0xFF0B0424),
      builder: (context, _brightness) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Color(0xFF0B0424),
            scaffoldBackgroundColor: _brightness == Brightness.dark
                ? Color(0xFF0B0424)
                : Colors.white,
            brightness: _brightness,
            fontFamily: "Montserrat",
            //0xFF0B0424
            //           scaffoldBackgroundColor: Color(0xFF0B0424),
          ),
          home: (GetTokenHomepage()),
        );
      },
    );
  }
}

//
//debugShowCheckedModeBanner: false,
//theme: ThemeData.light(),
//darkTheme: ThemeData.dark(),
//themeMode: currentTheme.currentTheme(),

//var movieName = data[index]['movie_name'];
//              var year = data[index]['year'];
//              var image = data[index]['image'];
//              var imdbRate = data[index]['imdb_rate'];
//              print("$movieName  $year   $image  $imdbRate");

//0B0424
