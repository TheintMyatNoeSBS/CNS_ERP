import 'dart:convert';
import 'dart:io';

import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/login_user_table.dart';
import 'package:cns/database/entity/program_table.dart';
import 'package:cns/database/entity/user_table.dart';
import 'package:cns/database/model/generic_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/database/model/item_unit_model.dart';
import 'package:cns/database/model/program_model.dart';
import 'package:cns/database/model/station_model.dart';
import 'package:cns/database/model/user_model.dart';
import 'package:cns/screen/home_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  static final String routeName = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCode = TextEditingController();
  final _password = TextEditingController();
  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _checkbox = false;
  bool _load = false;
  var responseMessage = "";
  var responseCode = "";
  bool _usernamevalidate = false;
  bool _passwordvalidate = false;
  bool _passwordVisible = false;
  var versionNo = "";
  var versionCode = "";
  String _deviceID = "";

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
    _passwordVisible = false;
    _usernamevalidate = false;
    _passwordvalidate = false;
    _getDeviceID();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _userFocusNode.dispose();
    _userCode.dispose();
    _password.dispose();
    super.dispose();
  }

  void _getDeviceID() async{
    _deviceID = await Common.instance.getId();
    print("DeviceID"+_deviceID);
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      versionNo = info.version;
      versionCode = info.buildNumber;
    });
  }

  void checkExitUser() async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();

    /*String usercode = _userCode.text.toLowerCase();
    String pass = _password.text;
    print('usercode'+usercode);
    print('password'+pass);*/

    List<UserTable> _userList = await database.userDao.getUserByUserCodeAndPassword(_userCode.text.toLowerCase(), _password.text);
//    List<UserTable> _userList = await database.userDao.getUserByUserCode(_userCode.text);
    print('ExitUser'+_userList.length.toString());

    setState(() {
      print('ExitUser'+_userList.length.toString());

      if(_userList.length>0){
        setState(() {
          Common.instance.setStringValue(Constants.user_id, _userList[0].UserID);
          Common.instance.setStringValue(Constants.user_name, _userList[0].StationID);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()
              ),
              ModalRoute.withName(HomeScreen.routeName));


/*
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
*/
        });

      }
      else{
        setState(() {
          Common.instance.check().then((intenet) {
            if (intenet != null && intenet) {
              callLoginApi(_userCode.text, _password.text, "1B2M2Y8AsgTpgAmY7PhCfg==");
            }
            else{
              Fluttertoast.showToast(
                  msg: "No Internet!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1);
              Navigator.pop(context);

            }
          });
        });
      }
    });
  }


  Future<void> callLoginApi(String userName,String password,String sign) async {
    print("Username :$userName");
    print("password :$password");
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    List<UserModel> dataList = [];
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <DoSignIn xmlns="http://tempuri.org/">
      <usercode>$userName</usercode>
      <password>$password</password>
      <sign>$sign</sign>
      <deviceName>$_deviceID</deviceName>
    </DoSignIn>
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

      if (result!=null) {
        print("DATAResult=" + result.toString());
        if(result.length > 0){

          String UserID = result['UserID'] == null? "": result['UserID'];
          String UserCode = result['UserCode'] == null? "": result['UserCode'];
          String LastLogin = result['LastLogin'] == null? "": result['LastLogin'];
          String UserName = result['UserName'] == null? "": result['UserName'];
          String Password = result['Password'] == null? "": result['Password'];
          String Note = result['Note'] == null? "": result['Note'];
          String Active = result['Active'] == null? "": result['Active'].toString();
          String CreatedBy = result['CreatedBy'] == null? "": result['CreatedBy'];
          String CreatedOn = result['CreatedOn'] == null? "": result['CreatedOn'];
          String ModifiedBy = result['ModifiedBy'] == null? "": result['ModifiedBy'];
          String ModifiedOn = result['ModifiedOn'] == null? "": result['ModifiedOn'];
          String LastAction = result['LastAction'] == null? "": result['LastAction'];
          String EnableTouch = result['EnableTouch'] == null? "": result['EnableTouch'].toString();
          String CreatedByCode = result['CreatedByCode'] == null? "": result['CreatedByCode'];
          String CreatedByName = result['CreatedByName'] == null? "": result['CreatedByName'];
          String ModifedByCode = result['ModifedByCode'] == null? "": result['ModifedByCode'];
          String ModifiedByName = result['ModifiedByName'] == null? "": result['ModifiedByName'];
          String DepartmentID = result['DepartmentID'] == null? "": result['DepartmentID'];
          String LandingPage = result['LandingPage'] == null? "": result['LandingPage'];
          String AllowArrival = result['AllowArrival'] == null? "": result['AllowArrival'].toString();
          String AllowBlackList = result['AllowBlackList'] == null? "": result['AllowBlackList'].toString();
          String AllowDeparture = result['AllowDeparture'] == null? "": result['AllowDeparture'].toString();
          String AllowInterpol = result['AllowInterpol'] == null? "": result['AllowInterpol'].toString();
          String AllowCenter = result['AllowCenter'] == null? "": result['AllowCenter'].toString();
          String DepartmentCode = result['DepartmentCode'] == null? "": result['DepartmentCode'];
          String DepartmentName = result['DepartmentName'] == null? "": result['DepartmentName'];
          String RoleID = result['RoleID'] == null? "": result['RoleID'];
          String RoleName = result['RoleName'] == null? "": result['RoleName'];
          String Email = result['Email'] == null? "": result['Email'];
          String PositionName = result['PositionName'] == null? "": result['PositionName'];
          String PositionID = result['PositionID'] == null? "": result['PositionID'];
          String StationID = result['StationID'] == null? "": result['StationID'];

          var list = result['ProgramList'] as List;

          print("List"+list.toString());
          print("UserID"+UserID);
          print("UserName"+userName);

          var totalQty=0.0;

          if(list.length>0){
//            itemlist.clear();
//            totalQty=0.0;
            for(int i=0;i<list.length;i++){
              Map<String, dynamic> map = list[i];
              var postData = ProgramList.fromJSON(map);
              await database.programDao.addStation(
                  ProgramTable(postData.SysProgramId,
                      postData.ProgramCode,
                      postData.ProgramName,
                      postData.SystemgroupID,
                      UserID
                  )
              );

//              totalQty+= double.parse(postData.Balance);
            }
          }

          try{
            await database.loginUserDao.addUser(
                LoginUserTable(
                    UserID, UserCode, UserName, LastLogin, _password.text, Note,
                    Active, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
                    LastAction, EnableTouch, CreatedByCode, CreatedByName, ModifedByCode,
                    ModifiedByName, DepartmentID, LandingPage, AllowArrival, AllowBlackList,
                    AllowDeparture, AllowInterpol, AllowCenter, DepartmentCode,
                    DepartmentName, RoleID, RoleName, Email, PositionName,
                    PositionID,StationID
                ));
          }
          catch(error){
            print("Error"+error.toString());
          }
          Common.instance.setStringValue(Constants.user_name,StationID);
          Common.instance.setStringValue(Constants.user_id, UserID);
        }

      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];

      }

      Fluttertoast.showToast(
          msg: responseMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );

      if(responseMessage == 'Success'){
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen()
              ),
              ModalRoute.withName(HomeScreen.routeName));
          /*Provider.of<GenericProvider>(context,listen: false)
              .callGenericDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
              .then((_){
            setState(() {
              callItemDownload();
            });
            print("Item Download Success");
          });*/

        });
      }
      else{
        setState(() {
          Navigator.pop(context);

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

  void callItemDownload() async{
    print("callItemTypeDownload");
    Provider.of<ItemProvider>(context,listen: false)
        .callItemDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
        .then((_) {
      callStationDownload();
    });
  }

  void callStationDownload() async{
    Provider.of<StationProvider>(context,listen: false)
        .callStationDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
        .then((_) {
      callUserDownload();
    });
  }

  void callUserDownload() async{
    Provider.of<UserProvider>(context,listen: false)
        .callDownloadUserApi("1B2M2Y8AsgTpgAmY7PhCfg==")
        .then((_) {
      callItemUnitDownload();
    });
  }

  void callItemUnitDownload() async{
    Provider.of<ItemUnitProvider>(context,listen: false)
        .callItemUnitDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
        .then((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()
          ),
          ModalRoute.withName(HomeScreen.routeName));
    });
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    precacheImage(new AssetImage("assets/image/3.jpg"),context);

    Widget loadingIndicator =_load? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ):new Container();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/1.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: Align(
                alignment: Alignment.center,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  children: [
                    SizedBox(height: 170,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(bottom: 8),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            margin: EdgeInsets.only(top:20,left:16,right: 16),
                            child: TextFormField(
                              controller: _userCode,
                              focusNode: _userFocusNode,
                              onFieldSubmitted: (_){
                                FocusScope.of(context).requestFocus(_passwordFocusNode);
                              },
                              validator: (value){
                                if(value!.isNotEmpty){
                                  return 'User Name is required!';
                                }
                              },
                              onChanged: (value){
                                if(value.length>0){
                                  setState(() {
                                    _usernamevalidate = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                errorText: _usernamevalidate ? 'User Name is required!' : null,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          Container(
                            height: 70,
                            margin: EdgeInsets.only(left:16,right: 16,top: 10),
                            child: TextFormField(
                              controller: _password,
                              focusNode: _passwordFocusNode,
                              obscureText: !_passwordVisible,

                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Password is required!';
                                }
                              },
                              onChanged: (value){
                                if(value.length>0){
                                  setState(() {
                                    _passwordvalidate = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                errorText: _passwordvalidate ? 'Password is required!' : null,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.lightBlue,
                                  ),
                                ),

                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          SizedBox(height: 5,),
                          InkWell(
                            onTap: (){
                              /*setState((){
                                _load=true;
                              });
                              checkExitUser();*/

                              setState(() {

//                          _password.text.isEmpty ? _validate = true : _validate = false;

                                if(_userCode.text.isEmpty || _password.text.isEmpty){
                                  if(_userCode.text.isEmpty){
                                    setState(() {
                                      _usernamevalidate = true;
                                      return;
                                    });
                                  }
//                            else{
//                              _validate = false;
//                            }

                                  if(_password.text.isEmpty){
                                    setState(() {
                                      _passwordvalidate = true;
                                      return;
                                    });
                                  }
//                            else{
//                              _validate = false;
//                            }

                                }
                                else if(_userCode.text.isNotEmpty && _password.text.isNotEmpty){
                                  setState(() {
                                    showLoaderDialog(context);
                                    checkExitUser();
                                  });
                                }
                              });

                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width/2.5,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Theme.of(context).primaryColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15)
                                  )
                              ),
                              child: Center(
                                child: Text('Login'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: Text(
                              'Version : $versionNo ($versionCode)' ,
                              style: TextStyle(color: Colors.blue),),
                          ),

                        ],
                      ),
                    ),

                  ],
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
    );
  }
}
