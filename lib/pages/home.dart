import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:version_beta/pages/login.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  String message = '';

  static LocationData currentLocation;
  var location = Location();
  LocationData _currentLocation;
  BitmapDescriptor currentLocationMarker;

  static CameraPosition _india = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};

  CollectionReference _polygonsCollection = Firestore.instance.collection('polygons');
  CollectionReference _users = Firestore.instance.collection('users');

  String username;
  String number;
  String emergency;

  @override
  void initState() {
    getLoginStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getLoginStatus();
    sheetHeight = MediaQuery.of(context).size.height / 6;
    super.didChangeDependencies();
  }

  void _isInside(QuerySnapshot polygonsSnapshots) {
    for (int i=0; i<polygonsSnapshots.documents.length; ++i) {
      List coordinates = polygonsSnapshots.documents[i].data['polygon'];
      double elevation = polygonsSnapshots.documents[i].data['elevation'];
      print(pointInTriangle(_currentLocation, coordinates[0], coordinates[1], coordinates[2]));
      if (pointInTriangle(_currentLocation, coordinates[0], coordinates[1], coordinates[2])) {
        if (elevation>520) {
          message = 'You are in safe region';
        } else if (elevation>480) {
          message = 'You are in low danger region';
        } else {
          message = 'You are in high danger region.';
        }
      }
    }
  }

  double sign (LocationData p1, GeoPoint p2, GeoPoint p3)
  {
    return (p1.latitude - p3.latitude) * (p2.longitude - p3.longitude) - (p2.latitude - p3.latitude) * (p1.longitude - p3.longitude);
  }

  bool pointInTriangle (LocationData pt, GeoPoint v1, GeoPoint v2, GeoPoint v3)
  {
    double d1, d2, d3;
    bool hasNeg, hasPos;

    d1 = sign(pt, v1, v2);
    d2 = sign(pt, v2, v3);
    d3 = sign(pt, v3, v1);

    hasNeg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    hasPos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(hasNeg && hasPos);
  }

  void loadPolygons() {
    _polygonsCollection.getDocuments().then((QuerySnapshot querySnapshot) {
      _add(querySnapshot);
      _isInside(querySnapshot);
    });
  }

  void _add(QuerySnapshot polygonsSnapshots) {
    for (int i=0; i<polygonsSnapshots.documents.length; ++i) {
      List coordinates = polygonsSnapshots.documents[i].data['polygon'];
      double elevation = polygonsSnapshots.documents[i].data['elevation'];
      final List<LatLng> points = <LatLng>[];
      final PolygonId polygonId = PolygonId(i.toString());

      for (int j=0; j<coordinates.length; ++j) {
        points.add(_createLatLng(coordinates[j].latitude, coordinates[j].longitude));
      }

      final Polygon polygon = Polygon(
        polygonId: polygonId,
        consumeTapEvents: true,
        strokeColor: elevation>520?Colors.transparent:elevation>480?Colors.orange:Colors.red,
        strokeWidth: 1,
        fillColor: elevation>520?Colors.black.withOpacity(0.2):elevation>480?Colors.orange.withOpacity(0.2):Colors.red.withOpacity(0.2),
        points: points,
      );

      polygons[polygonId] = polygon;
    }
    setState(() {});
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Future getLocation() async {
    try {
      await location.getLocation().then((loc) {
        _currentLocation = loc;
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(loc.latitude, loc.longitude), 12));
        _india = CameraPosition(
            target: LatLng(loc.latitude, loc.longitude), zoom: 12);
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
      if (user == null) {
        setState(() {
          isLoggedIn = false;
        });
      } else {
        _users.document(user.uid).get().then((snapshot) {
          setState(() {
            username = snapshot.data['name'];
            number = snapshot.data['phone'];
            emergency = snapshot.data['emergency'];
            isLoggedIn = true;
          });
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
    return isLoggedIn == null
        ? Center(child: CircularProgressIndicator(backgroundColor: Colors.black,))
        : isLoggedIn
            ? Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    username==null?CircularProgressIndicator():Text(username, style: TextStyle(fontSize: MediaQuery.of(context).size.width/20)),
                    number==null?Container():Text(number),
                    Padding(padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/40)),
                    emergency==null?Container():Text('Emergency Contant Number', style: TextStyle(color: Colors.red, fontSize: MediaQuery.of(context).size.width/26, fontWeight: FontWeight.w500)),
                    emergency==null?Container():Text(emergency)
                  ],
                ),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 12),
                      child: Text('Sign in',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width / 20))),
                  Material(
                      elevation: 6.0,
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width / 6)),
                      color: Colors.indigo,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width / 6)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width / 20),
                          child: Icon(Icons.person_outline,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width / 5),
                        ),
                      )),
                ],
              ));
  }

  Widget map(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: Center(
              child: GoogleMap(
            initialCameraPosition: _india,
            onMapCreated: (controller) {
              _mapController = controller;
              getLocation().then((value) {
                loadPolygons();
              });
            },
            markers: currentLocation == null ? null : _createMarker(),
                polygons: Set<Polygon>.of(polygons.values),
          )),
        ),
        _bottomIndex == 0
            ? Positioned(
                bottom: 0.0,
                height: sheetHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0, -5.0),
                            blurRadius: 10.0,
                            color: Colors.black12),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width / 20),
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width / 20))),
                  child: Material(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            MediaQuery.of(context).size.width / 20),
                        topRight: Radius.circular(
                            MediaQuery.of(context).size.width / 20)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
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
                                  sheetHeight =
                                      (MediaQuery.of(context).size.height / 6) +
                                          initialOffset -
                                          details.globalPosition.dy;
                                });
                              },
                              onVerticalDragEnd: (details) {
                                if (sheetHeight <
                                    MediaQuery.of(context).size.height / 6) {
                                  setState(() {
                                    sheetHeight =
                                        MediaQuery.of(context).size.height / 6;
                                  });
                                } else if (sheetHeight >
                                    MediaQuery.of(context).size.height / 4) {
                                  setState(() {
                                    sheetHeight =
                                        MediaQuery.of(context).size.height / 2;
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 12,
                                child: Text(
                                  message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width / 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: bodyList[_bottomIndex]);
  }
}
