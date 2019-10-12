import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:version_beta/pages/login.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController _mapController;

  double initialOffset;
  double sheetHeight;

  int _bottomIndex = 0;
  List<Widget> bodyList = List<Widget>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn;

  static LocationData currentLocation;
  var location = Location();
  BitmapDescriptor currentLocationMarker;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  @override
  void initState() {
    getLocation();
    getLoginStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sheetHeight = MediaQuery.of(context).size.height/6;
    super.didChangeDependencies();
  }

  void getLocation() async {
    try {
      location.getLocation().then((loc) {
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(loc.latitude, loc.longitude), 12));
        setState(() {});
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("current_location"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
      ),
    ].toSet();
  }

  Future getLoginStatus() async {
    await _auth.currentUser().then((FirebaseUser user) {
      if (user==null) {
        setState(() {
          isLoggedIn = false;
        });
      } else {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  void incrementIndex(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }



  Widget profile(BuildContext context) {
    return isLoggedIn==null?Center(child: CircularProgressIndicator()):isLoggedIn?Container(
      color: Colors.amber,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    ):Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.person_outline),
        RaisedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> Login())),
          child: Text('Login'),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget map(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            child: Center(
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (controller) {_mapController = controller;},
                  markers: currentLocation==null?null:_createMarker(),
                )
            ),
          ),
          _bottomIndex==0?Positioned(bottom:0.0, height: sheetHeight,child: DecoratedBox(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: Offset(0.0, -5.0),
                  blurRadius: 10.0,
                  color: Colors.black12),
            ], borderRadius: BorderRadius.only(
                topLeft:
                Radius.circular(MediaQuery.of(context).size.width / 20),
                topRight:
                Radius.circular(MediaQuery.of(context).size.width / 20))),
            child: Material(
              borderRadius: BorderRadius.only(
                  topLeft:
                  Radius.circular(MediaQuery.of(context).size.width / 20),
                  topRight:
                  Radius.circular(MediaQuery.of(context).size.width / 20)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height/6,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onVerticalDragStart: (details) {
                          setState(() {
                            initialOffset = details.globalPosition.dy;
                          });
                        },
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            if (sheetHeight>=MediaQuery.of(context).size.height/6) {
                              sheetHeight = (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6) + initialOffset -
                                  details.globalPosition.dy;
                            }
                          });
                        },
                        onVerticalDragEnd: (details) {
                          if (sheetHeight<MediaQuery.of(context).size.height/6) {
                            setState(() {
                              sheetHeight = MediaQuery.of(context).size.height/6;
                            });
                          } else if (sheetHeight>MediaQuery.of(context).size.height/4) {
                            setState(() {
                              sheetHeight = MediaQuery.of(context).size.height/2;
                            });
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height/12,
                          child: Text(
                            'You are safe.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width/18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )):null,
        ],
      );
    }
    bodyList = [map(context), profile(context)];
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Flood Map'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
        onTap: (index) {
          print(isLoggedIn);
          incrementIndex(index);
        },
      ),
      body: bodyList[_bottomIndex]
    );
  }
}
