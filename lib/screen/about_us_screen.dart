import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  static final String routeName = '/aboutus_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS?AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('About Us'),
      ):null,
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              child: Image.asset(
                'assets/image/teamwork.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'About Us',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  child: Image.asset(
                    'assets/image/globe.png',
                    color: Colors.blue,
                    width: 20,
                    height: 20,
                  ),
                ),
                Container(
                  child: Text(
                    '   https://myanmarcns.com'
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  child: Image.asset(
                    'assets/image/pin.png',
                    color: Colors.blue,
                    width: 20,
                    height: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                        'ခြံအမှတ် (1) ဆရာစံလမ်းနှင့် ပုလဲလမ်းထောင့် ၊ 27 ရပ်ကွက် ၊ မြောက်ဒဂုံ ၊ ပင်လုံအိမ်ယာ အပိုင်း 6 ။',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
