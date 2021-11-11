import 'dart:convert';

import 'package:cns/database/entity/generic_table.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../appdatabase.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class GenericModel with ChangeNotifier{
  final String GenericID;
  final String GenericName;
  final String Description;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;


  GenericModel({
    required this.GenericID,
    required this.GenericName,
    required this.Description,
    required this.Active,
    required this.CreatedBy,
    required this.CreatedOn,
    required this.ModifiedBy,
    required this.ModifiedOn,
    required this.LastAction
  });

  factory GenericModel.fromJSON(Map<String, dynamic> json) {

    List<GenericModel> genericList = [];

    return GenericModel(
        GenericID: json['GenericID']==null? "-": json['GenericID'],
        GenericName: json['GenericName']==null? "-": json['GenericName'],
        Description: json['Description']==null? "-": json['Description'],
        Active: json['Active']==null? "-": json['Active'].toString(),
        CreatedBy: json['CreatedBy']==null? "-": json['CreatedBy'],
        CreatedOn: json['CreatedOn']==null? "-": json['CreatedOn'],
        ModifiedBy: json['ModifiedBy']==null? "": json['ModifiedBy'],
        ModifiedOn: json['ModifiedOn']==null? "": json['ModifiedOn'],
        LastAction: json['LastAction']==null? "-": json['LastAction']
    );
  }
}

class GenericProvider with ChangeNotifier{
  List<GenericModel> _genericList = [];
  String responseCode = "";
  String responseMessage = "";
  String modifyOn = "";

  Future<void> callGenericDownload(String sign) async {
    final database = await Common.instance.getAppDatabase();

    List<GenericTable> generics = await database.genericDao.getAllGeneric();
    if(generics.length>0){
      modifyOn = generics[0].ModifiedOn;
    }

    List<GenericModel> dataList = [];
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAll_Generic xmlns="http://tempuri.org/">
      <sign>1B2M2Y8AsgTpgAmY7PhCfg==</sign>
      <modifiedOn>$modifyOn</modifiedOn>
    </GetAll_Generic>
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
      Map genericMap = json.decode(parsedXml.text);
      print("DATAUser=" + genericMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAGeneric =" + jsonData.toString());

      print("DATAGeneric=" + result.toString());
      print("DATAGenericSize=" + result.length.toString());
      if (result.length > 0) {

        for (int i = 0; i < result.length; i++) {
          Map<String, dynamic> map = result[i];

          var postData = GenericModel.fromJSON(map);
          dataList.add(postData);

          /*String GenericID = json['GenericID']==null? "-": json['GenericID'];
          String GenericName = json['GenericName']==null? "-": json['GenericName'];
          String Description = json['Description']==null? "-": json['Description'];
          String Active = json['Active']==null? "-": json['Active'].toString();
          String CreatedBy = json['CreatedBy']==null? "-": json['CreatedBy'];
          String CreatedOn = json['CreatedOn']==null? "-": json['CreatedOn'];
          String ModifiedBy = json['ModifiedBy']==null? "": json['ModifiedBy'];
          String ModifiedOn = json['ModifiedOn']==null? "": json['ModifiedOn'];
          String LastAction = json['LastAction']==null? "-": json['LastAction'];*/

          await database.genericDao.addGeneric(
              GenericTable(
                  postData.GenericID,
                  postData.GenericName,
                  postData.Description,
                  postData.Active,
                  postData.CreatedBy,
                  postData.CreatedOn,
                  postData.ModifiedBy,
                  postData.ModifiedOn,
                  postData.LastAction
              ));

        }

        List<GenericTable> generics = await database.genericDao.getAllGeneric();

        print("GenecicList :"+ generics.length.toString());

        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];

        if(responseMessage=='Success'){
          Fluttertoast.showToast(
              msg: 'Generic download success',
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