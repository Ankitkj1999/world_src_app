import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;
  final Color ScaffoldBackground;

  ThemeBuilder({this.builder, this.defaultBrightness, this.ScaffoldBackground});
  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();
  static _ThemeBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_ThemeBuilderState>());
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness _brightness;
  Color ScaffoldBackground;
  @override
  void initState() {
    _brightness = widget.defaultBrightness;
    ScaffoldBackground = widget.ScaffoldBackground;
    if (mounted) {
      setState(() {});
    }
    // TODO: implement initState
    super.initState();
  }

  void changeTheme() {
    setState(() {
      _brightness =
          _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
      ScaffoldBackground =
          _brightness == Brightness.dark ? Color(0xFF0B0424) : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
