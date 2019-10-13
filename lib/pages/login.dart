import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:version_beta/pages/sign_up.dart';

class Login extends StatefulWidget {
  void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode _otpFocusNode1;
  FocusNode _otpFocusNode2;
  FocusNode _otpFocusNode3;
  FocusNode _otpFocusNode4;
  FocusNode _otpFocusNode5;
  FocusNode _otpFocusNode6;
  TextEditingController _otpPart1;
  TextEditingController _otpPart2;
  TextEditingController _otpPart3;
  TextEditingController _otpPart4;
  TextEditingController _otpPart5;
  TextEditingController _otpPart6;
  String _phoneNumber;
  String _verificationId;
  TextEditingController _controller;
  bool errorLogin = false;
  bool validate = false;
  bool loggingIn = false;

  @override
  void initState() {
    super.initState();
    _otpFocusNode1 = FocusNode();
    _otpFocusNode2 = FocusNode();
    _otpFocusNode3 = FocusNode();
    _otpFocusNode4 = FocusNode();
    _otpFocusNode5 = FocusNode();
    _otpFocusNode6 = FocusNode();
    _otpPart1 = TextEditingController();
    _otpPart2 = TextEditingController();
    _otpPart3 = TextEditingController();
    _otpPart4 = TextEditingController();
    _otpPart5 = TextEditingController();
    _otpPart6 = TextEditingController();
    _otpFocusNode2.addListener(() {
      if (_otpFocusNode2.hasFocus) {
        if (_otpPart1.text.length == 0) {
          widget.requestFocus(context, _otpFocusNode1);
        }
      }
    });
    _otpFocusNode3.addListener(() {
      if (_otpFocusNode3.hasFocus) {
        if (_otpPart2.text.length == 0) {
          widget.requestFocus(context, _otpFocusNode2);
        }
      }
    });
    _otpFocusNode4.addListener(() {
      if (_otpFocusNode4.hasFocus) {
        if (_otpPart3.text.length == 0) {
          widget.requestFocus(context, _otpFocusNode3);
        }
      }
    });
    _otpFocusNode5.addListener(() {
      if (_otpFocusNode5.hasFocus) {
        if (_otpPart4.text.length == 0) {
          widget.requestFocus(context, _otpFocusNode4);
        }
      }
    });
    _otpFocusNode6.addListener(() {
      if (_otpFocusNode6.hasFocus) {
        if (_otpPart5.text.length == 0) {
          widget.requestFocus(context, _otpFocusNode5);
        }
      }
    });
    _controller = TextEditingController(text: '+91');
  }

  @override
  void dispose() {
    _otpFocusNode1.dispose();
    _otpFocusNode2.dispose();
    _otpFocusNode3.dispose();
    _otpFocusNode4.dispose();
    _otpFocusNode5.dispose();
    _otpFocusNode6.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 0.5,
                          color: _controller.text.length == 13
                              ? Colors.teal
                              : Colors.black54),
                      borderRadius: BorderRadius.all(Radius.circular(
                          MediaQuery.of(context).size.width))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 30),
                    child: TextField(
                      style: TextStyle(color: Colors.black54),
                      cursorColor: Colors.black54,
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Phone number',
                          errorText: validate
                              ? 'Phone number should be 10 chararters'
                              : null,
                          errorStyle: TextStyle(color: Colors.redAccent),
                          icon: Icon(Icons.call, color: Colors.teal),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20.0,
                              color: Colors.teal)),
                      onChanged: (value) {
                        if (!value.startsWith('+91')) {
                          _controller.text =
                              '+91' + _controller.text.substring(2);
                        }
                        setState(() {
                          this._phoneNumber = value;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                    child: FloatingActionButton(
                      backgroundColor: _controller.text.length == 13
                          ? Colors.teal
                          : Colors.grey,
                      onPressed: () {
                        verifyPhone();
                        setState(() {
                          _controller.text.length < 13
                              ? validate = true
                              : validate = false;
                        });
                      },
                      child: loggingIn?CircularProgressIndicator():Icon(Icons.done),
                      elevation: _controller.text.length == 13 ? 4.0 : 0.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    setState(() {
      loggingIn = true;
    });
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      _verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      _verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedNumber =
        (AuthCredential credential) {
      print('Verified');
    };
    final PhoneVerificationFailed phoneVerificationFailed =
        (AuthException exception) {
      print('${exception.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedNumber,
        verificationFailed: phoneVerificationFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);

  }

  Future<bool> smsCodeDialog(BuildContext context) {
    setState(() {
      loggingIn = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart1,
                                focusNode: _otpFocusNode1,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode2);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart2,
                                focusNode: _otpFocusNode2,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode1);
                                  }
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode3);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart3,
                                focusNode: _otpFocusNode3,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode2);
                                  }
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode4);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart4,
                                focusNode: _otpFocusNode4,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode3);
                                  }
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode5);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart5,
                                focusNode: _otpFocusNode5,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode4);
                                  }
                                  if (value.length == 1) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode6);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width / 200),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5, color: Colors.black54),
                                borderRadius: BorderRadius.all(Radius.circular(
                                    MediaQuery.of(context).size.width))),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 40,
                              child: TextField(
                                controller: _otpPart6,
                                focusNode: _otpFocusNode6,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                    hintText: '-',
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'NovaMono',
                                    fontSize: MediaQuery.of(context).size.width / 25),
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.length == 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_otpFocusNode5);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.done),
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) {
                      if (user == null) {
                        signIn();
                      }
                    });
                  },
                )
              ],
            ),
            contentPadding: EdgeInsets.all(9.0),
            backgroundColor: Colors.white,
            actions: <Widget>[
              errorLogin
                  ? Text(
                'Invalid Sms Code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent),
              )
                  : Container()
            ],
          );
        });
  }

  signIn() async {
    print('signin');
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: '${_otpPart1.text}${_otpPart2.text}${_otpPart3.text}${_otpPart4.text}${_otpPart5.text}${_otpPart6.text}',
      );

      FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((AuthResult authResult) {
        Firestore.instance.collection('users').document(authResult.user.uid).get().then((snapshot) {
          if (snapshot.exists) {
            Navigator.of(context).pop();
              Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SignUp(authResult.user.uid, _phoneNumber)));
          }
        });
      });
    } catch (e) {
      setState(() {
        errorLogin = true;
      });

      print('Error : $e');
    }
  }
}
