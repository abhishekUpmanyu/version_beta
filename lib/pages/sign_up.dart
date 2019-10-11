import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  final String _uid;
  final String _phone;
  SignUp(this._uid, this._phone);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CollectionReference _userCollection = Firestore.instance.collection('users');

  FocusNode _node1, _node2, _node3, _node4;

  final _formKey = GlobalKey<FormState>();
  String _name, _s1='', _s2='', _s3='', _s4='';

  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _userCollection.document(widget._uid).setData({
        'name': _name,
        'schNumber': '19U0$_s1$_s2$_s3$_s4',
        'phone': widget._phone
      }).then((value) {
        Firestore.instance.collection('start').document('start').get().then((snapshot) {
          //TODO: add navigation to main page after sign up
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _submit,
          label: Text('Submit'),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Color(0xfff6a800)),
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text('Sign Up'),
        backgroundColor: Color(0xff302b2f),
      ),
      body: Stack(
        children: <Widget>[
          Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/sign_up_pattern.jpg'),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height),
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Color(0xfff6a800)),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width / 30),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) => setState(() {}),
                            validator: (value) =>
                            value.isEmpty ? 'Please enter your name' : null,
                            onSaved: (value) {
                              _name = value;
                            },
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.white38),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 40,
                            vertical: MediaQuery.of(context).size.width / 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 200),
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Color(0xfff6a800))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              42),
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            20,
                                        child: Center(
                                          child: Text('1',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'NovaMono',
                                                  fontSize:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      25)),
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 200),
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Color(0xfff6a800))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              42),
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            20,
                                        child: Center(
                                          child: Text('9',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'NovaMono',
                                                  fontSize:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      25)),
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 200),
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Color(0xfff6a800))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              42),
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            20,
                                        child: Center(
                                          child: Text('U',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'NovaMono',
                                                  fontSize:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      25)),
                                        ),
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width / 200),
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width)),
                                        border: Border.all(
                                            width: 0.5,
                                            color: Color(0xfff6a800))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width /
                                              42),
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            20,
                                        child: Center(
                                          child: Text('0',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontFamily: 'NovaMono',
                                                  fontSize:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      25)),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 200),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: _s1.length==1?Color(0xfff6a800):Colors.white54),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width))),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            40,
                                        child: TextFormField(
                                          focusNode: _node1,
                                          onChanged: (value) {
                                            _s1 = value;
                                            if (value.length==1) {
                                              FocusScope.of(context).requestFocus(_node2);
                                            }
                                          },
                                          validator: (value) => value.isEmpty
                                              ? 'Please enter your scholar number'
                                              : null,
                                          onSaved: (value) {
                                            _s1 = value;
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1)
                                          ],
                                          keyboardType:
                                          TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: '-',
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'NovaMono',
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 200),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: _s2.length==1?Color(0xfff6a800):Colors.white54),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width))),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            40,
                                        child: TextFormField(
                                          focusNode: _node2,
                                          onChanged: (value) {
                                            _s2 = value;
                                            if (value.length==1) {
                                              FocusScope.of(context).requestFocus(_node3);
                                            } else {
                                              FocusScope.of(context).requestFocus(_node1);
                                            }
                                          },
                                          validator: (value) => value.isEmpty
                                              ? 'Please enter your scholar number'
                                              : null,
                                          onSaved: (value) {
                                            _s2 = value;
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1)
                                          ],
                                          keyboardType:
                                          TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: '-',
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'NovaMono',
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 200),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: _s3.length==1?Color(0xfff6a800):Colors.white54),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width))),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            40,
                                        child: TextFormField(
                                          focusNode: _node3,
                                          onChanged: (value) {
                                            _s3 = value;
                                            if (value.length==1) {
                                              FocusScope.of(context).requestFocus(_node4);
                                            } else {
                                              FocusScope.of(context).requestFocus(_node2);
                                            }
                                          },
                                          validator: (value) => value.isEmpty
                                              ? 'Please enter your scholar number'
                                              : null,
                                          onSaved: (value) {
                                            _s3 = value;
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1)
                                          ],
                                          keyboardType:
                                          TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: '-',
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'NovaMono',
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width / 200),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: _s4.length==1?Color(0xfff6a800):Colors.white54),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width))),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            40,
                                        child: TextFormField(
                                          focusNode: _node4,
                                          onChanged: (value) {
                                            _s4 = value;
                                            if (value.length==0) {
                                              FocusScope.of(context).requestFocus(_node3);
                                            }
                                          },
                                          validator: (value) => value.isEmpty
                                              ? 'Please enter your scholar number'
                                              : null,
                                          onSaved: (value) {
                                            _s4 = value;
                                          },
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(1)
                                          ],
                                          keyboardType:
                                          TextInputType.numberWithOptions(),
                                          decoration: InputDecoration(
                                              hintText: '-',
                                              hintStyle: TextStyle(
                                                  color: Colors.white54),
                                              border: InputBorder.none),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'NovaMono',
                                              fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
