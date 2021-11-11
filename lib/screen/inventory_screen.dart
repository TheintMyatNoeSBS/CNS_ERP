import 'dart:convert';
import 'dart:io';

import 'package:cns/database/model/item_detail_model.dart';
import 'package:cns/database/model/item_list_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:cns/widget/barcode_card.dart';
import 'package:cns/widget/item_detail.dart';
import 'package:cns/widget/item_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class InventoryScreen extends StatefulWidget {
  static final String routeName = '/inventory_screen';

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<ItemListModel> dataList = [];
  List<ItemDetailModel> itemlist = [];
  final _searchText = TextEditingController();
  final _searchFocusNode = FocusNode();

  var responseCode = "";
  var responseMessage = "";
  bool _isSearching = false;
  bool _hasdata = false;

  @override
  void initState() {
    _hasdata = false;
    _isSearching = false;
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();

    _searchFocusNode.addListener(() {
      if(_searchFocusNode.hasFocus) {
        _searchText.selection = TextSelection(baseOffset: 0, extentOffset: _searchText.text.length);
      }
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


  Future<void> callGetInvItemApi(String name,String sign) async {
    /*var info = await PackageInfo.fromPlatform();
    var sign = Common.instance.getSignKey(context,info.packageName);
    print("Sign :$sign");*/

    /*print("Username :$userName");
    final database = await Common.instance.getAppDatabase();*/
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Get_INV_ItemList xmlns="http://tempuri.org/">
      <name>$name</name>
      <sign>1B2M2Y8AsgTpgAmY7PhCfg==</sign>
    </Get_INV_ItemList>
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
      print("DATAItem=" + cityMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAItem =" + jsonData.toString());

      print("DATAResult=" + result.toString());
      print("DATAResultSize=" + result.length.toString());
      if (result.length > 0) {

        dataList.clear();
        for (int i = 0; i < result.length; i++) {
          Map<String, dynamic> map = result[i];
          print("ItemList=" + result.length.toString());

          var postData = ItemListModel.fromJSON(map);
          dataList.add(postData);

        }

        setState(() {
          _hasdata = true;
          if(result2.length>0){
            responseCode = result2['Code'];
            responseMessage = result2['Message'];
          }

          if(responseMessage == 'Success'){
            setState(() {
              Navigator.pop(context);
              setState(() {
                FocusScope.of(context).unfocus();
              });
            });
          }
          else{
            setState(() {
              Navigator.pop(context);
              _hasdata = false;
              Fluttertoast.showToast(
                  msg: responseMessage.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1
              );
              setState(() {
                FocusScope.of(context).unfocus();
              });
            });
          }

        });

      }
      else{
        setState(() {
          /*_hasdata = false;
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );*/
          callGetInvItemDetailApi(name, sign);
        });
      }

      /*else{
        setState(() {
          Navigator.pop(context);
          _hasdata = false;
          Fluttertoast.showToast(
              msg: responseMessage.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
          setState(() {
            FocusScope.of(context).unfocus();
          });
        });
      }*/

    }catch (error) {
      setState(() {
        _hasdata = false;
        Navigator.pop(context);
        setState(() {
          FocusScope.of(context).unfocus();
        });
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

  Future<void> callGetInvItemDetailApi(String name,String sign) async {
    print("Barcode :$name");
    /*print("Username :$userName");
    final database = await Common.instance.getAppDatabase();*/
    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Get_INV_ItemDetail xmlns="http://tempuri.org/">
      <barcode>$name</barcode>
      <sign>$sign</sign>
    </Get_INV_ItemDetail>
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
      print("DATAItem=" + cityMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAItem =" + jsonData.toString());

      if (result.length > 0) {

        dataList.clear();

        var list = result['Item_Detail'] as List;

        print("List"+list.toString());

        var totalQty=0.0;

        if(list.length>0){
          itemlist.clear();
          totalQty=0.0;
          for(int i=0;i<list.length;i++){
            Map<String, dynamic> map = list[i];
            var postData = ItemDetailModel.fromJSON(map);
            itemlist.add(postData);

            totalQty+= double.parse(postData.Balance);
          }
        }

        var str = totalQty.toString();

        var parts = str.split('.');
        var prefix = parts[0].trim();

        setState(() {
          dataList.add(ItemListModel(
              ItemName: result['ItemName'] == null? "-": result['ItemName'],
              GenericName: result['GenericName'] == null? "-": result['GenericName'],
              RefNo: result['RefNo'] == null? "": result['RefNo'],
              Manufacture: result['Manufacture'] == null? "-": result['Manufacture'],
              TotalQty: prefix,
              Country: result['Country'] == null? "-": result['Country'],
              BarCode: name,
              Item_Detail: itemlist
          ));
        });
        setState(() {
          _hasdata = true;
        });

      }
      else{
        setState(() {
          _hasdata = false;
          Fluttertoast.showToast(
              msg: "No Data",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        });
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage == 'Success'){
        setState(() {
//          _hasdata = true;
          Navigator.pop(context);
          setState(() {
            FocusScope.of(context).unfocus();
          });
        });
      }
      else{
        setState(() {
          _hasdata = false;
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: responseMessage.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
          setState(() {
            FocusScope.of(context).unfocus();
          });
        });
      }

    }catch (error) {
      setState(() {
        _hasdata = false;
        Navigator.pop(context);
        setState(() {
          FocusScope.of(context).unfocus();
        });
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
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(new AssetImage("assets/image/1.jpg"),context);
    precacheImage(new AssetImage("assets/image/cns_logo.jpg"),context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Platform.isIOS? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('CNS Inventory System'),
      ) : AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('CNS Inventory System'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Image.asset(
                        'assets/image/qr_code_scan.png',
                        height: 60,
                        width: 60,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10),
                          child: TextField(
                            controller: _searchText,
                            maxLines: null,
                            focusNode: _searchFocusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Trade Name or Generic Name...",
                              contentPadding: const EdgeInsets.fromLTRB(6, 6, 0, 10), // 48 -> icon width
                            ),
                            onChanged: (_txt){

                              if(_txt.length>0){
                                setState(() {
                                  _isSearching = true;
                                });
                              }
                              else{
                                setState(() {
                                  _isSearching = false;
                                });
                              }

                              if(_txt.contains('\n')){
                                showLoaderDialog(context);
                                String _search = _searchText.text.trim();
                                _searchText.text = _search;
                                Common.instance.check().then((intenet) {
                                  if (intenet != null && intenet) {
                                    setState(() {
                                      callGetInvItemApi(_search, "1B2M2Y8AsgTpgAmY7PhCfg==");
                                    });
                                  }
                                  else{
                                    Fluttertoast.showToast(
                                        msg: "No Internet!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1);
                                    Navigator.pop(context);

                                  }
                                });

                                /*setState(() {
                                  FocusScopeNode currentFocus = FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                });*/
                              }
                            },
                          ),
                        ),
                        _isSearching? IconButton(
                            onPressed: (){
                              setState(() {
                                _isSearching = false;
                                _searchText.text = "";
                              });
                            },
                            icon: Icon(Icons.clear)): Container(
                          padding: EdgeInsets.only(left: 5),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                              if(_searchText.text.isNotEmpty){
                                Common.instance.check().then((intenet) {
                                  if (intenet != null && intenet) {
                                    setState(() {
                                      showLoaderDialog(context);
                                      callGetInvItemApi(_searchText.text, "1B2M2Y8AsgTpgAmY7PhCfg==");
                                      setState(() {
                                        FocusScopeNode currentFocus = FocusScope.of(context);

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      });
                                    });
                                  }
                                  else{
                                    setState(() {
                                      Fluttertoast.showToast(
                                          msg: "No Internet!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1);
                                    });

                                  }
                                });
                              }
                              else{
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: "No search data",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1);
                                });
                              }},
                        ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            dataList.length>1? Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 17,bottom: 10),
                child: Text(
                  'Total Count : ${dataList.length}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ):Container(),
            Expanded(
              child: ListView(
                children: [

                  _hasdata? ItemList(dataList):BarcodeCard(),
                ],
              ),
            ),
            Align(
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

          ],
        ),
      ),
    );
  }
}
