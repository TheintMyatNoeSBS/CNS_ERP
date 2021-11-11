import 'dart:convert';

import 'package:cns/database/entity/station_entity.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../appdatabase.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class StationModel with ChangeNotifier{
  final String StationID;
  final String StationName;
  final String Address;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;
  final String StationCode;
  final String Remark;
  final String CreatedByCode;
  final String ModifiedByCode;

  StationModel({
    required this.StationID, required this.StationName,
    required this.Address, required this.Active,
    required this.CreatedBy, required this.CreatedOn,
    required this.ModifiedBy, required this.ModifiedOn,
    required this.LastAction, required this.StationCode,
    required this.Remark, required this.CreatedByCode,
    required this.ModifiedByCode,
  });

  factory StationModel.fromJSON(Map<String, dynamic> json) {

    List<StationModel> stationList = [];

    return StationModel(
    StationID: json['StationID']==null? "": json['StationID'],
    StationName: json['StationName']==null? "": json['StationName'],
    Address: json['Address']==null? "": json['Address'],
    Active: json['Active']==null? "": json['Active'].toString(),
    CreatedBy: json['CreatedBy']==null? "": json['CreatedBy'],
    CreatedOn: json['CreatedOn']==null? "": json['CreatedOn'],
    Remark: json['Remark']==null? "": json['Remark'],
    ModifiedBy: json['ModifiedBy']==null? "": json['ModifiedBy'],
    ModifiedOn: json['ModifiedOn']==null? "": json['ModifiedOn'],
    LastAction: json['LastAction']==null? "": json['LastAction'],
    StationCode: json['StationCode']==null? "": json['StationCode'],
    CreatedByCode: json['CreatedByCode']==null? "": json['CreatedByCode'],
    ModifiedByCode: json['ModifiedByCode']==null? "": json['ModifiedByCode']
    );
  }
}
class StationProvider with ChangeNotifier{
  List<StationModel> stationList = [];
  String responseCode = "";
  String responseMessage = "";

  Future<void> callStationDownload(String sign) async {
    final database = await Common.instance.getAppDatabase();

    List<StationModel> dataList = [];
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAll_Station xmlns="http://tempuri.org/">
      <searchText></searchText>
      <sign>$sign</sign>
    </GetAll_Station>
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

          var postData = StationModel.fromJSON(map);
          dataList.add(postData);

          await database.stationDao.addStation(
              StationTable(
                  postData.StationID,
                  postData.StationName,
                  postData.Address,
                  postData.Active,
                  postData.CreatedBy,
                  postData.CreatedOn,
                  postData.ModifiedBy,
                  postData.ModifiedOn,
                  postData.LastAction,
                  postData.StationCode,
                  postData.Remark,
                  postData.CreatedByCode,
                  postData.ModifiedByCode
              ));

        }

        List<StationTable> stations = await database.stationDao.getAllStation();

        print("StationsList :"+ stations.length.toString());

        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
        if(responseMessage=='Success'){
          Fluttertoast.showToast(
              msg: 'Station download success',
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

//      Fluttertoast.showToast(
//          msg: responseMessage,
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIosWeb: 1
//      );

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