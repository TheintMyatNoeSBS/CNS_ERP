import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/login_user_table.dart';
import 'package:cns/database/entity/program_table.dart';
import 'package:cns/database/entity/user_table.dart';
import 'package:cns/screen/about_us_screen.dart';
import 'package:cns/screen/inventory_screen.dart';
import 'package:cns/screen/login_screen.dart';
import 'package:cns/screen/ordering_list_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static final String routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  String userID = "";
  var responseMessage = "";
  var responseCode = "";
  String userName="";
  String password="";

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();

    Common.instance
        .getStringValue(Constants.user_id)
        .then((value) => setState(() {
      userID = value;
      getUserInfo(userID);
    }));

  }

  void getUserInfo(String userID) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();

    List<LoginUserTable> userInfo = await database.loginUserDao.getUserByUserId(userID);
    print("UserInfo"+userInfo.length.toString());
    setState(() {
      if(userInfo.length>0){
        userName = userInfo[0].UserCode;
        password = userInfo[0].Password;
      }
    });
  }

  void checkPermission(String programCode,String route) async{
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    List<ProgramTable> programs = await database.programDao.getPermission(userID,programCode);
    print('Program'+programs.length.toString());
    if(programs.length>0){
      setState(() {
        Navigator.of(context).pushNamed(route);
      });
    }
    else{
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.only(left: 10,right: 10),
            title: Text('Access Denied!'),
            content: Text('You are not allowed'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('OK',style: TextStyle(color: Colors.blue),),
              ),
            ],
          )
      );
    }
  }


  void goto(int index){
    if(index==0){
      checkPermission("STOCK-BALANCE", InventoryScreen.routeName);
      /*setState(() {
        Navigator.of(context).pushNamed(InventoryScreen.routeName);
      });*/
    }
    else if(index == 1){
      checkPermission("MR", OrderListScreen.routeName);
      /*setState(() {
        Navigator.of(context).pushNamed(OrderListScreen.routeName);
      });*/
    }
    else if(index == 2){
      setState(() {
        Navigator.of(context).pushNamed(AboutUsScreen.routeName);
      });
    }
    else if(index == 3){
      setState(() {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.only(left: 10,right: 10),
              title: Text('Logout'),
              content: Text('Are you sure, you want to logout?'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel',style: TextStyle(color: Colors.blue),),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      Common.instance.check().then((intenet) {
                        if (intenet != null && intenet) {
                          callLogoutApi(userName,password,"1B2M2Y8AsgTpgAmY7PhCfg==");

                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Connection Fail!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1);
                        }
                      });
                    });
                  },
                  child: Text('Logout',style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
        );
      });
    }
  }

  Future<void> callLogoutApi(String userName,String password,String sign) async {
    print("Username"+userName);
    print("Password"+password);
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <DoSignOut xmlns="http://tempuri.org/">
      <usercode>$userName</usercode>
      <password>$password</password>
      <sign>$sign</sign>
    </DoSignOut>
  </soap:Body>
</soap:Envelope>
''';

      http.Response response = await http.post(
          Uri.parse('http://43.228.125.94:2026/WebService/WebService_System.asmx'),
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
          },
          body: envelope);

      var rawXmlResponse = response.body;

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);

      print("DATAResult=" + response.body);
      //parse the string and return the json object =>json.decode
      Map cityMap = json.decode(parsedXml.text);
      print("DATAUser=" + cityMap.toString());


      var jsonData = jsonDecode(parsedXml.text);

      print("jsonData"+jsonData["ResponseData"]);
      var result;
      if(jsonData["ResponseData"] != ""){
        result = jsonDecode(jsonData["ResponseData"]);
      }
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUser =" + jsonData.toString());

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];

      }

      if(responseMessage == 'Success'){
        setState(() {
          Common.instance.setStringValue(Constants.user_id, "");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginScreen()
              ),
              ModalRoute.withName(LoginScreen.routeName));
        });
      }
      else{
        setState(() {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: responseMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        });
      }

    }catch (error) {
      setState(() {
        Navigator.pop(context);

      });
      print(error);
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      throw (error);
    }

  }


  @override
  Widget build(BuildContext context) {

    final List<MenuData> menu = [
      MenuData('assets/image/inventory.png', 'Inventory'),
      MenuData('assets/image/box.png', 'Ordering'),
      MenuData('assets/image/teamwork.png', 'About Us'),
      MenuData('assets/image/exit.png', 'Logout'),
    ];

    precacheImage(new AssetImage("assets/image/cns_logo.jpg"),context);
    precacheImage(new AssetImage("assets/image/1.jpg"),context);

    return Scaffold(
      backgroundColor: Color(0xffE2E4F7),
      body: Stack(
        children: [
          Container(
//            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/3.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 15,top: 30,right: 15,bottom: 15),
                        physics: BouncingScrollPhysics(),
                        itemCount: menu.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5/2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 0.2,
                            margin: EdgeInsets.only(left: 8,right: 8),
                            color: Color(0xffc4ddeb),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xff0D77B3)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: InkWell(
                              onTap: (){
                                goto(index);
                              },
                              child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10))
                                      )
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8,right: 8),
                                    decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.red,
                                          width: 7.0
                                      )
                                  )
                              ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                       Image.asset(
                                         menu[index].icon,
                                          width: 40,
                                        height: 40,
                                      ),
                                      SizedBox(height: 5),
                                     Text(
                                    menu[index].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  )
                                ],
                              ),
                          ),
                              ),
                            )
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Platform.isIOS?FractionalOffset.bottomCenter:FractionalOffset.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 5.0),
                      child: Text(
                        '© 2021 SYSTEMATIC Business Solution Co.,Ltd.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
class MenuData {
  MenuData(this.icon, this.title);
  final String icon;
  final String title;
}
