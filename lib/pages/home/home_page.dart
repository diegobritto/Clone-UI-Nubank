import 'package:flutter/material.dart';
import 'package:nubank/pages/home/widgets/menu_app.dart';
import 'package:nubank/pages/home/widgets/my_app_bar.dart';
import 'package:nubank/pages/home/widgets/my_dots_app.dart';
import 'package:nubank/pages/home/widgets/page_view_app.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showMenu;
  int _currentIndex;
  double _yPosition;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    if (_yPosition == null) {
      _yPosition = _screenHeight * .24;
    }
    return Scaffold(
      backgroundColor: Colors.purple[800],
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          MyAppBar(
            showMenu: _showMenu,
            onTap: () {
              setState(() {
                _showMenu = !_showMenu;
                _yPosition = _showMenu ? _screenHeight * .75 : _screenHeight * .24;
              });
            },
          ),
          MenuApp(top: _screenHeight*.20,showMenu: _showMenu,),
          PageViewApp(
            showMenu: _showMenu,
            top: _yPosition,
            onChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onPanUpdate: (details) {
              double positionBottomLimit = _screenHeight * .75;
              double positionTopLimit = _screenHeight * .24;
              double middlePosition = (positionBottomLimit - positionTopLimit)/2;
              setState(() {
                _yPosition += details.delta.dy;
                if(_yPosition != positionBottomLimit && details.delta.dy >  0){
                  _yPosition =  _yPosition > positionTopLimit + middlePosition - 50
                      ? positionBottomLimit
                      : _yPosition;
                }
                if(_yPosition != positionTopLimit && details.delta.dy < 0){
                  _yPosition =  _yPosition < positionBottomLimit - middlePosition
                      ? positionTopLimit
                      : _yPosition;
                }
                if(_yPosition == positionBottomLimit){
                  _showMenu = true;
                }else if(_yPosition ==positionTopLimit){
                  _showMenu = false;
                }
              });
            },
          ),
          MyDotsApp(currentIndex: _currentIndex, top: _screenHeight * .70, showMenu: _showMenu,),
        ],
      ),
    );
  }
}
