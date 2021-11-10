import 'dart:async';

import 'package:cns/screen/home_screen.dart';
import 'package:cns/screen/login_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static final String routeName = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userID = "" ;
  var alreadyLogin = false;

  void isAlreadyLogin(){
    Common.instance
        .getStringValue(Constants.user_id)
        .then((value) => setState(() {
      userID = value;
      print("userID :"+userID);
    }));

    setState(() {

      Timer(
          Duration(seconds: 3),
              (){
            print('AlreadyLogin$alreadyLogin');

            if(userID!=""){
              setState(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));

              });
            }
            else{
              setState(() {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));

              });
            }
          });

//      if(staffId!=""){
//        alreadyLogin = true;
//      }
//      else{
//        alreadyLogin = false;
//      }
    });

  }

  @override
  void initState() {
    super.initState();
    isAlreadyLogin();


  }

  @override
  Widget build(BuildContext context) {
    precacheImage(new AssetImage("assets/image/1.jpg"),context);
    precacheImage(new AssetImage("assets/image/3.jpg"),context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/2.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            '© 2021 SYSTEMATIC Business Solution Co.,Ltd.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ),

    );
  }
}
