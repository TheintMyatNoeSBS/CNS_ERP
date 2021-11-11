import 'dart:convert';

import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/user_table.dart';
import 'package:cns/screen/login_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  static final String routeName = '/change_password';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _oldPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var responseMessage = "";
  var responseCode = "";
  bool _oldvalidate = false;
  bool _newvalidate = false;
  bool _confirmvalidate = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isSame = false;
  bool _load = false;

  String userID = "";

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
  void initState() {
    super.initState();
    Common.instance
        .getStringValue(Constants.user_id)
        .then((value) => setState(() {
      userID = value;
//      print("StaffID"+staffId);
    }));
    _isSame = false;
  }

  @override
  void dispose() {
    super.dispose();
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
  }

  void checkPassword() async{
    final database = await Common.instance.getAppDatabase();

    List<UserTable> _userList = await database.userDao.getUserByUserId(userID);

    print("OldPass"+_userList[0].Password);
    print("OldPass"+_oldPassword.text);

    if(_userList[0].Password != _oldPassword.text){
      setState(() {

        Fluttertoast.showToast(
            msg: "Invalid Password!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
        Navigator.pop(context);
        return;
      });
    }
    else{
      setState(() {
        callChangePasswordApi(_userList[0].UserCode, _oldPassword.text, _newPassword.text, "1B2M2Y8AsgTpgAmY7PhCfg==");
      });

    }
  }

  Future<void> callChangePasswordApi(String userCode,String oldPassword,String newPassword,String sign) async {
    print("Username :$userCode");
    print("password :$oldPassword");
    print("password :$newPassword");
    final database = await Common.instance.getAppDatabase();
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <ChangePassword xmlns="http://tempuri.org/">
      <userCode>$userCode</userCode>
      <oldPassword>$oldPassword</oldPassword>
      <Password>$newPassword</Password>
      <sign>$sign</sign>
    </ChangePassword>
  </soap12:Body>
</soap12:Envelope>
''';

      http.Response response = await http.post(
          Uri.parse('http://43.228.125.24:2026/WebService/WebService_System.asmx'),
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

      /*if (result!=null) {
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
          String EnableTouch = result['EnableTouch'] == null? "": result['EnableTouch'];
          String CreatedByCode = result['CreatedByCode'] == null? "": result['CreatedByCode'];
          String CreatedByName = result['CreatedByName'] == null? "": result['CreatedByName'];
          String ModifedByCode = result['ModifedByCode'] == null? "": result['ModifedByCode'];
          String ModifiedByName = result['ModifiedByName'] == null? "": result['ModifiedByName'];
          String DepartmentID = result['DepartmentID'] == null? "": result['DepartmentID'];
          String LandingPage = result['LandingPage'] == null? "": result['LandingPage'];
          String AllowArrival = result['AllowArrival'] == null? "": result['AllowArrival'];
          String AllowBlackList = result['AllowBlackList'] == null? "": result['AllowBlackList'];
          String AllowDeparture = result['AllowDeparture'] == null? "": result['AllowDeparture'];
          String AllowInterpol = result['AllowInterpol'] == null? "": result['AllowInterpol'];
          String AllowCenter = result['AllowCenter'] == null? "": result['AllowCenter'];
          String DepartmentCode = result['DepartmentCode'] == null? "": result['DepartmentCode'];
          String DepartmentName = result['DepartmentName'] == null? "": result['DepartmentName'];
          String RoleID = result['RoleID'] == null? "": result['RoleID'];
          String RoleName = result['RoleName'] == null? "": result['RoleName'];
          String Email = result['Email'] == null? "": result['Email'];
          String PositionName = result['PositionName'] == null? "": result['PositionName'];
          String PositionID = result['PositionID'] == null? "": result['PositionID'];

          try{
            await database.userDao.addUser(
                UserTable(
                    UserID, userName, UserName, LastLogin, password, Note,
                    Active, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
                    LastAction, EnableTouch, CreatedByCode, CreatedByName, ModifedByCode,
                    ModifiedByName, DepartmentID, LandingPage, AllowArrival, AllowBlackList,
                    AllowDeparture, AllowInterpol, AllowCenter, DepartmentCode,
                    DepartmentName, RoleID, RoleName, Email, PositionName,
                    PositionID
                ));
          }
          catch(error){
            print("Error"+error.toString());
          }

          Common.instance.setStringValue(Constants.user_id, UserID);
        }

      }*/

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
          database.userDao.updatePassword(userID,_newPassword.text);
          Common.instance.setStringValue(Constants.user_id, "");

         /* Fluttertoast.showToast(
              msg: "Successfully Changed!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1);*/

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
              timeInSecForIosWeb: 1);

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
    precacheImage(new AssetImage("assets/image/1.jpg"),context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Passowrd'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: [
            Container(
              margin: EdgeInsets.only(top:10,left:16,right: 16,
                  bottom: 10),
              child: TextFormField(
                controller: _oldPassword,
                focusNode: _oldPasswordFocusNode,
                obscureText: !_oldPasswordVisible,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Old Password is required!';
                  }
                },
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_newPasswordFocusNode);
                },
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  errorText: _oldvalidate ? 'Old Password is required!' : null,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _oldPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _oldPasswordVisible = !_oldPasswordVisible;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10,left:16,right: 16,
                  bottom: 10),
              child: TextFormField(
                controller: _newPassword,
                focusNode: _newPasswordFocusNode,
                obscureText: !_newPasswordVisible,
                validator: (value){
                  if(value!.isEmpty){
                    return 'New Password is required!';
                  }
                },
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  errorText: _newvalidate ? 'New Password is required!' : null,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _newPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _newPasswordVisible = !_newPasswordVisible;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10,left:16,right: 16,
                  bottom: 10),
              child: TextFormField(
                controller: _confirmPassword,
                focusNode: _confirmPasswordFocusNode,
                obscureText: !_confirmPasswordVisible,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Confirm Password is required!';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  errorText: _confirmvalidate ? 'Confirm Password is required!' : null,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.lightBlue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            InkWell(
              onTap: (){
                if(_oldPassword.text.isNotEmpty && _newPassword.text.isNotEmpty && _confirmPassword.text.isNotEmpty){

                  if(_newPassword.text!=_confirmPassword.text){
                    setState(() {
                      Fluttertoast.showToast(
                          msg: "Password doesn't match!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                      return;
                    });
                  }
                  else{
                    setState(() {
                      showLoaderDialog(context);
                      checkPassword();

                    });
                  }
                }
                else{
                  setState(() {
                    _oldPassword.text.isEmpty ? _oldvalidate = true : _oldvalidate = false;
                    _newPassword.text.isEmpty ? _newvalidate = true : _newvalidate = false;
                    _confirmPassword.text.isEmpty ? _confirmvalidate = true : _confirmvalidate = false;

                  });
                }


              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width/5,
                margin: EdgeInsets.only(top:10,left:16,right: 16,
                      bottom: 10),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff6bceff),
                        Color(0xFF00abff),
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    )
                ),
                child: Center(
                  child: Text('Reset'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
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
