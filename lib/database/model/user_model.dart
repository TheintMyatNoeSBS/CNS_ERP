import 'dart:convert';

import 'package:cns/database/entity/user_table.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

import '../appdatabase.dart';

class UserModel with ChangeNotifier{
  final String UserID;
  final String UserCode;
  final String UserName;
  final String LastLogin;
  final String Password;
  final String Note;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;
  final String EnableTouch;
  final String CreatedByCode;
  final String CreatedByName;
  final String ModifedByCode;
  final String ModifiedByName;
  final String DepartmentID;
  final String LandingPage;
  final String AllowArrival;
  final String AllowBlackList;
  final String AllowDeparture;
  final String AllowInterpol;
  final String AllowCenter;
  final String DepartmentCode;
  final String DepartmentName;
  final String RoleID;
  final String RoleName;
  final String Email;
  final String PositionName;
  final String PositionID;
  final String StationID;

  UserModel({required this.UserID, required this.UserCode, required this.UserName, required this.LastLogin,
    required this.Password, required this.Note,required this.Active, required this.CreatedBy, required this.CreatedOn,
    required this.ModifiedBy, required this.ModifiedOn, required this.LastAction, required this.EnableTouch,
    required this.CreatedByCode, required this.CreatedByName, required this.ModifedByCode,
    required this.ModifiedByName, required this.DepartmentID, required this.LandingPage,
    required this.AllowArrival, required this.AllowBlackList, required this.AllowDeparture,
    required this.AllowInterpol, required this.AllowCenter, required this.DepartmentCode,
    required this.DepartmentName, required this.RoleID, required this.RoleName, required this.Email,
    required this.PositionName, required this.PositionID,required this.StationID});

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    /*if (json == null) {
      return json['UserID'];
    } else*/
    return UserModel(
        UserID : json['UserID'] == null? "": json['UserID'],
        UserCode : json['UserCode'] == null? "": json['UserCode'],
        LastLogin : json['LastLogin'] == null? "": json['LastLogin'],
        UserName : json['UserName'] == null? "": json['UserName'],
        Password : json['Password'] == null? "": json['Password'],
        Note : json['Note'] == null? "": json['Note'],
        Active : json['Active'] == null? "": json['Active'].toString(),
        CreatedBy : json['CreatedBy'] == null? "": json['CreatedBy'],
        CreatedOn : json['CreatedOn'] == null? "": json['CreatedOn'],
        ModifiedBy : json['ModifiedBy'] == null? "": json['ModifiedBy'],
        ModifiedOn : json['ModifiedOn'] == null? "": json['ModifiedOn'],
        LastAction : json['LastAction'] == null? "": json['LastAction'],
        EnableTouch : json['EnableTouch'] == null? "": json['EnableTouch'].toString(),
        CreatedByCode : json['CreatedByCode'] == null? "": json['CreatedByCode'],
        CreatedByName : json['CreatedByName'] == null? "": json['CreatedByName'],
        ModifedByCode : json['ModifedByCode'] == null? "": json['ModifedByCode'],
        ModifiedByName : json['ModifiedByName'] == null? "": json['ModifiedByName'],
        DepartmentID : json['DepartmentID'] == null? "": json['DepartmentID'],
        LandingPage : json['LandingPage'] == null? "": json['LandingPage'],
        AllowArrival : json['AllowArrival'] == null? "": json['AllowArrival'].toString(),
        AllowBlackList : json['AllowBlackList'] == null? "": json['AllowBlackList'].toString(),
        AllowDeparture : json['AllowDeparture'] == null? "": json['AllowDeparture'].toString(),
        AllowInterpol : json['AllowInterpol'] == null? "": json['AllowInterpol'].toString(),
        AllowCenter : json['AllowCenter'] == null? "": json['AllowCenter'].toString(),
        DepartmentCode : json['DepartmentCode'] == null? "": json['DepartmentCode'],
        DepartmentName : json['DepartmentName'] == null? "": json['DepartmentName'],
        RoleID : json['RoleID'] == null? "": json['RoleID'],
        RoleName : json['RoleName'] == null? "": json['RoleName'],
        Email : json['Email'] == null? "": json['Email'],
        PositionName : json['PositionName'] == null? "": json['PositionName'],
        PositionID : json['PositionID'] == null? "": json['PositionID'],
        StationID : json['StationID'] == null? "": json['StationID']);

  }
}

class UserProvider with ChangeNotifier{
  List<UserModel> _users = [];
  String responseCode = "";
  String responseMessage = "";

  Future<void> callLoginApi(String userName,String password,String sign) async {
    print("Username :$userName");
    final database = await Common.instance.getAppDatabase();
    List<UserModel> dataList = [];
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <DoSignIn xmlns="http://tempuri.org/">
      <usercode>Super</usercode>
      <password>Super@CnS2021</password>
      <sign>1B2M2Y8AsgTpgAmY7PhCfg==</sign>
    </DoSignIn>
  </soap:Body>
</soap:Envelope>
''';

      http.Response response = await http.post(
          Uri.parse(Constants.url),
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
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUser =" + jsonData.toString());

      print("DATAResult=" + result.toString());
      print("DATAResultSize=" + result.length.toString());
      if (result.length > 0) {
        var body="";
        if(result["AllowCenter"]==null){
           body = "";
        }
        else{
          body = result["AllowCenter"];
        }

        String UserID = result['UserID'] == null? "": result['UserID'];
        String UserCode = result['UserCode'] == null? "": result['UserCode'];
        String LastLogin = result['LastLogin'] == null? "": result['LastLogin'];
        String UserName = result['UserName'] == null? "": result['UserName'];
        String Password = result['Password'] == null? "": result['Password'];
        String Note = result['Note'] == null? "": result['Note'];
        String Active = result['Active'] == null? "": result['Active'];
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
        String StationID = result['StationID'] == null? "": result['StationID'];

        await database.userDao.addUser(
            UserTable(
                UserID, UserCode, UserName, LastLogin, Password, Note,
                Active, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
                LastAction, EnableTouch, CreatedByCode, CreatedByName, ModifedByCode,
                ModifiedByName, DepartmentID, LandingPage, AllowArrival, AllowBlackList,
                AllowDeparture, AllowInterpol, AllowCenter, DepartmentCode,
                DepartmentName, RoleID, RoleName, Email, PositionName,
                PositionID,StationID
            ));


        List<UserTable> users = await database.userDao.getAllUser();

        print("DATAusers=" + users.length.toString());

        Common.instance.setStringValue(Constants.user_id, UserID);

        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      Fluttertoast.showToast(
          msg: responseMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );

    }catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
      throw (error);
    }

  }

  Future<void> callDownloadUserApi(String sign) async {
    final database = await Common.instance.getAppDatabase();
    List<UserModel> dataList = [];
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Get_ApprovedByUser xmlns="http://tempuri.org/">
      <sign>$sign</sign>
    </Get_ApprovedByUser>
  </soap:Body>
</soap:Envelope>
''';

      http.Response response = await http.post(
          Uri.parse(Constants.url),
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
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUser =" + jsonData.toString());

      print("DATAResult=" + result.toString());
      print("DATAResultSize=" + result.length.toString());
      if (result.length > 0) {
        for (int i = 0; i < result.length; i++) {
          Map<String, dynamic> map = result[i];

          var postData = UserModel.fromJSON(map);
          dataList.add(postData);

          await database.userDao.addUser(
              UserTable(
                  postData.UserID, postData.UserCode, postData.UserName, postData.LastLogin, postData.Password, postData.Note,
                  postData.Active, postData.CreatedBy, postData.CreatedOn, postData.ModifiedBy, postData.ModifiedOn,
                  postData.LastAction, postData.EnableTouch, postData.CreatedByCode, postData.CreatedByName, postData.ModifedByCode,
                  postData.ModifiedByName, postData.DepartmentID, postData.LandingPage, postData.AllowArrival, postData.AllowBlackList,
                  postData.AllowDeparture, postData.AllowInterpol, postData.AllowCenter, postData.DepartmentCode,
                  postData.DepartmentName, postData.RoleID, postData.RoleName, postData.Email, postData.PositionName,
                  postData.PositionID,postData.StationID
              ));
        }

        List<UserTable> users = await database.userDao.getAllUser();

        print("DATAusers=" + users.length.toString());


        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
        if(responseMessage=='Success'){
          Fluttertoast.showToast(
              msg: 'Users download success',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
        else{
          Fluttertoast.showToast(
              msg: responseMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
      }

    }catch (error) {
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


}