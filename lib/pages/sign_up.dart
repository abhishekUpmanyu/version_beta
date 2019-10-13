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

  final _formKey = GlobalKey<FormState>();
  String _name, _phoneNumber;

  bool validate = false;

  TextEditingController _controller = TextEditingController(text: '+91');

  Future _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _userCollection.document(widget._uid).setData({
        'name': _name,
        'phone': widget._phone,
        'emergency': _phoneNumber
      }).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _submit,
          label: Text('Submit', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Colors.teal),
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        centerTitle: true,
        title: Text('Sign Up', style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
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
                        border: Border.all(width: 0.5, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(
                            MediaQuery.of(context).size.width))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 30),
                      child: TextFormField(

                        style: TextStyle(color: Colors.black54),
                        onChanged: (value) => setState(() {}),
                        validator: (value) =>
                            value.isEmpty ? 'Please enter your name' : null,
                        onSaved: (value) {
                          _name = value;
                        },
                        decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20.0,
                                color: Colors.teal),
                            labelText: 'Name',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 40,
                        vertical: MediaQuery.of(context).size.width / 40),
                  ),
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
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Emergency Contact Number',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
