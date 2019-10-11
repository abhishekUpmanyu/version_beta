import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback _showBottomSheetCallback;

  int _bottomIndex = 0;

  @override
  void initState() {
    _showBottomSheetCallback = _showBottomSheet;
    super.initState();
  }

  void incrementIndex(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  void _showBottomSheet() {
    setState(() { // disable the button
      _showBottomSheetCallback = null;
    });
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      final ThemeData themeData = Theme.of(context);
      return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: themeData.disabledColor))
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text('This is a Material persistent bottom sheet. Drag downwards to dismiss it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeData.accentColor,
              fontSize: 24.0,
            ),
          ),
        ),
      );
    })
        .closed.whenComplete(() {
      if (mounted) {
        setState(() { // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Flood Map')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile')
          )
        ],
        onTap: (index) {incrementIndex(index);},
      ),
    );
  }
}
