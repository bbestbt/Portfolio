import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loggedInScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

var emailTemp;
var returnScreen;

class PhoneAndOtpScreen extends StatefulWidget {
  static String routeName = "/login";
  PhoneAndOtpScreen({Key key}) : super(key: key);

  @override
  _PhoneAndOtpScreenState createState() => _PhoneAndOtpScreenState();
}

class _PhoneAndOtpScreenState extends State<PhoneAndOtpScreen> {
  String error = "";

  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController numberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  // @override
  // void initState() {
  //   if (_auth.currentUser != null) {
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => LoggedInScreen(),
  //       ),
  //       (route) => false,
  //     );
  //   }
  //   super.initState();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the Widget is disposed
  //   numberController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      returnScreen = returnOTPScreenEmail();
    } else {
      returnScreen = returnLoginScreen();
    }
    return isOTPScreen ? returnOTPScreen() : returnScreen;
  }

  Widget returnLoginScreen() {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(children: [
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            "Phone number",
                            style: TextStyle(
                                fontFamily: 'Century Gothic',
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Color.fromRGBO(9, 29, 103, 1)),
                          ),
                          SizedBox(height: 50),
                          // Container(
                          //     child: Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 10.0, horizontal: 10.0),
                          //   child: TextFormField(
                          //     enabled: !isLoading,
                          //     controller: numberController,
                          //     keyboardType: TextInputType.phone,
                          //     decoration:
                          //         InputDecoration(labelText: 'Phone Number'),
                          //     validator: (value) {
                          //       if (value.isEmpty) {
                          //         return 'Please enter phone number';
                          //       }
                          //     },
                          //   ),
                          // )),
                          TextFormField(
                            enabled: !isLoading,
                            controller: numberController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter phone number';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "phone number",
                              hintText: "enter your phone number",
                              filled: true,
                              fillColor: Color(0xFFFFECDF),
                              prefixIcon: Icon(Icons.lock_outlined),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 42, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Color(0xFF757575),
                                ),
                                gapPadding: 10,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          // Container(
                          //     margin: EdgeInsets.only(top: 40, bottom: 5),
                          //     child: Padding(
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 10.0),
                          //         child: !isLoading
                          //             ? new ElevatedButton(
                          //                 onPressed: () async {
                          //                   if (!isLoading) {
                          //                     if (_formKey.currentState
                          //                         .validate()) {
                          //                       displaySnackBar('Please wait...');
                          //                       await login();
                          //                     }
                          //                   }
                          //                 },
                          //                 child: Container(
                          //                     padding: const EdgeInsets.symmetric(
                          //                       vertical: 15.0,
                          //                       horizontal: 15.0,
                          //                     ),
                          //                     child: new Row(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.center,
                          //                       children: <Widget>[
                          //                         Expanded(
                          //                             child: Text(
                          //                           "Sign In",
                          //                           textAlign: TextAlign.center,
                          //                         )),
                          //                       ],
                          //                     )),
                          //               )
                          //             : CircularProgressIndicator(
                          //                 backgroundColor:
                          //                     Theme.of(context).primaryColor,
                          //               ))),
                          RaisedButton(
                            onPressed: () async {
                              if (!isLoading) {
                                if (_formKey.currentState.validate()) {
                                  displaySnackBar('Please wait...');
                                  await login();
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            color: Color.fromRGBO(255, 149, 24, 0.89),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 10, bottom: 10),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Century Gothic',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color.fromRGBO(9, 29, 103, 1),
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //     margin: EdgeInsets.only(top: 15, bottom: 5),
                          //     alignment: AlignmentDirectional.center,
                          //     child: Padding(
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 10.0),
                          //         child: Row(
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Padding(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0),
                          //                 child: Text(
                          //                   "No Account ?",
                          //                 )),
                          //             InkWell(
                          //               child: Text(
                          //                 'Sign up',
                          //               ),
                          //               onTap: () => {
                          //                 Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             RegisterScreen()))
                          //               },
                          //             ),
                          //           ],
                          //         )))
                        ],
                      ))
                ],
              )
            ]),
          ),
        ));
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(children: [
              Form(
                key: _formKeyOTP,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                                !isLoading
                                    ? "Enter OTP from SMS"
                                    : "Sending OTP code SMS",
                                style: TextStyle(
                                    fontFamily: 'Century Gothic',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: Color.fromRGBO(9, 29, 103, 1)),
                                textAlign: TextAlign.center))),
                    !isLoading
                        ? Container(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: null,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'OTP',
                                  labelStyle: TextStyle(color: Colors.black)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter OTP';
                                }
                              },
                            ),
                          ))
                        : Container(),
                    !isLoading
                        ? Container(
                            margin: EdgeInsets.only(top: 40, bottom: 5),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: new ElevatedButton(
                                  onPressed: () async {
                                    if (_formKeyOTP.currentState.validate()) {
                                      // If the form is valid, we want to show a loading Snackbar
                                      // If the form is valid, we want to do firebase signup...
                                      setState(() {
                                        isResend = false;
                                        isLoading = true;
                                      });
                                      try {
                                        await _auth
                                            .signInWithCredential(
                                                PhoneAuthProvider.credential(
                                                    verificationId:
                                                        verificationCode,
                                                    smsCode: otpController.text
                                                        .toString()))
                                            .then((user) async => {
                                                  //sign in was success
                                                  if (user != null)
                                                    {
                                                      //store registration details in firestore database
                                                      setState(() {
                                                        isLoading = false;
                                                        isResend = false;
                                                      }),
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              LoggedInScreen(),
                                                        ),
                                                        (route) => false,
                                                      )
                                                    }
                                                })
                                            .catchError((error) => {
                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = true;
                                                  }),
                                                });
                                        setState(() {
                                          isLoading = true;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                fontFamily: 'Century Gothic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color.fromRGBO(
                                                    9, 29, 103, 1)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )
                                  ].where((c) => c != null).toList(),
                                )
                              ]),
                    isResend
                        ? Container(
                            margin: EdgeInsets.only(top: 40, bottom: 5),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: new ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isResend = false;
                                      isLoading = true;
                                    });
                                    await login();
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "Resend Code",
                                            style: TextStyle(
                                                fontFamily: 'Century Gothic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color.fromRGBO(
                                                    9, 29, 103, 1)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                        : Column()
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  Widget returnOTPScreenEmail() {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(children: [
              Form(
                key: _formKeyOTP,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                                !isLoading
                                    ? "Enter OTP from Email"
                                    : "Sending OTP code Email",
                                style: TextStyle(
                                    fontFamily: 'Century Gothic',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: Color.fromRGBO(9, 29, 103, 1)),
                                textAlign: TextAlign.center))),
                    !isLoading
                        ? Container(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: TextFormField(
                              enabled: !isLoading,
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: null,
                              autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'OTP',
                                  labelStyle: TextStyle(color: Colors.black)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter OTP';
                                }
                              },
                            ),
                          ))
                        : Container(),
                    !isLoading
                        ? Container(
                            margin: EdgeInsets.only(top: 40, bottom: 5),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: new ElevatedButton(
                                  onPressed: () {
                                    verify();
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                fontFamily: 'Century Gothic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color.fromRGBO(
                                                    9, 29, 103, 1)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    )
                                  ].where((c) => c != null).toList(),
                                )
                              ]),
                    isResend
                        ? Container(
                            margin: EdgeInsets.only(top: 40, bottom: 5),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: new ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isResend = false;
                                      isLoading = true;
                                    });
                                    await login();
                                  },
                                  child: new Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                      horizontal: 15.0,
                                    ),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: Text(
                                            "Resend Code",
                                            style: TextStyle(
                                                fontFamily: 'Century Gothic',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color.fromRGBO(
                                                    9, 29, 103, 1)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )))
                        : Column()
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  // void sendOtp() async {
  //   emailTemp = await getValue();
  //
  //   ///Accessing the EmailAuth class from the package
  //   EmailAuth.sessionName = "Sample";
  //
  //   ///a boolean value will be returned if the OTP is sent successfully
  //   var data = await EmailAuth.sendOtp(receiverMail: emailTemp);
  //   if (data) {
  //     print("OTP sent");
  //   } else {
  //     print("Could not sent OTP");
  //   }
  // }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login() async {
    print("pressed login");
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+27 ' + numberController.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = numberController.text.trim();

    await _firestore
        .collection('users')
        .where('cellnumber', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      if (kIsWeb) {
        // sendOtp();
        // ConfirmationResult confirmationResult =
        //     await _auth.signInWithPhoneNumber(phoneNumber);

        // running on the web!
      } else {
        var verifyPhoneNumber = _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) {
            //auto code complete (not manually)
            _auth
                .signInWithCredential(phoneAuthCredential)
                .then((user) async => {
                      if (user != null)
                        {
                          //redirect
                          setState(() {
                            isLoading = false;
                            isOTPScreen = false;
                          }),
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoggedInScreen(),
                            ),
                            (route) => false,
                          )
                        }
                    });
          },
          verificationFailed: (FirebaseAuthException error) {
            displaySnackBar('Validation error, please try again later');
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (verificationId, [forceResendingToken]) {
            setState(() {
              isLoading = false;
              verificationCode = verificationId;
              isOTPScreen = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              isLoading = false;
              verificationCode = verificationId;
            });
          },
          timeout: Duration(seconds: 60),
        );
        await verifyPhoneNumber;
        // NOT running on the web! You can check for additional platforms here.
      }
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('Number not found, please sign up first');
    }
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('key');
    return stringValue;
  }

  void verify() {
    var res = EmailAuth.validate(
        receiverMail: emailTemp, //to make sure the email ID is not changed
        userOTP: otpController.value.text);

    if (res) {
      print("OTP verified");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoggedInScreen()),
      );
    } else {
      print("invalid OTP");
    }

    ///This will return you a bool, and you can proceed further after that, add a fail case and a success case (result will be true/false)
  }
  //
  // void processLogin() async {
  //   var testUser = _auth.;
  //   var user = _auth.currentUser;
  //   var test = true;
  //
  //   // if (user == null) {
  //
  //   if (test == true) {
  //     FirebaseAuthUi.instance()
  //         .launchAuth([AuthProvider.phone()]).then((fbUser) {
  //       setState(() {
  //         error = "";
  //       });
  //     }).catchError((e) {
  //       if (e is PlatformException) {
  //         setState(() {
  //           if (e.code == FirebaseAuthUi.kUserCancelledError) {
  //             error = "User cancelled login";
  //           } else {
  //             error = e.message ?? 'Unk error';
  //           }
  //         });
  //       }
  //     });
  //   } else {
  //     //user already has logged in
  //     // await FirebaseAuthUi.instance().logout();
  //     // setState(() {});
  //     print("In Else");
  //   }
  // }
}
