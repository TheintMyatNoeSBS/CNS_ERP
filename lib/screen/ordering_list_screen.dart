import 'dart:io';

import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/generic_table.dart';
import 'package:cns/database/entity/item_table.dart';
import 'package:cns/database/entity/item_unit_table.dart';
import 'package:cns/database/entity/order_table.dart';
import 'package:cns/database/entity/station_entity.dart';
import 'package:cns/database/entity/user_table.dart';
import 'package:cns/database/model/generic_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/database/model/item_unit_model.dart';
import 'package:cns/database/model/order_model.dart';
import 'package:cns/database/model/request_detail_model.dart';
import 'package:cns/database/model/request_model.dart';
import 'package:cns/database/model/station_model.dart';
import 'package:cns/database/model/user_model.dart';
import 'package:cns/screen/home_screen.dart';
import 'package:cns/screen/order_detail_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:cns/widget/order_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  static final String routeName = '/orderlist_screen';
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final _search = TextEditingController();
  String userID = "";
  List<OrderModel> orderList=[];
  List<OrderTable> orderData=[];
  var _isInit = true;
  var requestDate;
  var currDay;
  var currYear;
  var currMonth;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  var userName="";
  var stationenable = true;

  @override
  void initState() {
    super.initState();
    requestDate = DateTime.now();

    Common.instance
        .getStringValue(Constants.user_id)
        .then((value) => setState(() {
      userID = value;
      getUserInfo(userID);
    }));

//    getDate();

    /*setState(() {
      String date = dateFormat.format(requestDate);
      getOrderList(userID,date);
    });*/
  }

  /*void getDate(){
    requestDate = DateTime.now();
  }*/

  void getUserInfo(String userID) async {
    final database = await Common.instance.getAppDatabase();

    Common.instance
        .getStringValue(Constants.user_name)
        .then((value) => setState(() {
      userName = value;
      print("UserName"+userName);
//      getUserInfo(userID);
    }));

    List<UserTable> userInfo = await database.userDao.getUserByUserId(userID);
    print("UserInfo"+userInfo.length.toString());
    setState(() {
      if(userInfo.length>0){

        if(userInfo[0].DepartmentCode!='StationUser'){
          setState(() {
            stationenable = false;
          });
        }
        else{
          setState(() {
            stationenable = true;
          });
        }

        String date = dateFormat.format(requestDate);
        getOrderList(userName,date);
      }
    });
  }


  void getOrderList(String userName,String strDate) async{
    final database = await Common.instance.getAppDatabase();

    print("DAte"+strDate);
//    List<OrderTable> orders = await database.orderDao.getByUser('$strDate');
//    List<OrderTable> orders = await database.orderDao.getByStation(strDate,userName);
    if(!stationenable){
      List<OrderTable> orders = await database.orderDao.getByDate(strDate);
      print("OrderList"+orders.length.toString());

      setState(() {
        if(orders.length>0){
        orderData.clear();

        for(int i=0;i<orders.length;i++) {
        print("OrderDate"+orders[i].orderDate);
        orderData.add(orders[i]);
        }
      }
      else{
        orderData.clear();
      }
        orderData.sort((a,b) => b.requestNo.compareTo(a.requestNo));
      });
    }
    else{
      List<OrderTable> orders = await database.orderDao.getByStation(strDate,userName);
      print("OrderList"+orders.length.toString());

      setState(() {
        if(orders.length>0){
          orderData.clear();

          for(int i=0;i<orders.length;i++) {
            print("OrderDate"+orders[i].orderDate);
            orderData.add(orders[i]);
          }
        }
        else{
          orderData.clear();
        }
        orderData.sort((a,b) => b.requestNo.compareTo(a.requestNo));
      });
    }

  }

  Future<void> callDownloadData() async{
    print("CallDownload");
    String date = dateFormat.format(requestDate);
//    getOrderList(userName,date);

    final database = await Common.instance.getAppDatabase();

    List<OrderTable> orders = await database.orderDao.getByStation(date,userName);
    print("orders"+orders.length.toString());
    Common.instance.check().then((intenet) {
      if (intenet != null && intenet) {
        if(orders.length>0){
          for(int i=0;i<orders.length;i++){
            print("ordersID"+orders[i].orderId);

            Provider.of<RequestDetailProvider>(context,listen: false)
                .callDownloadRequest("1B2M2Y8AsgTpgAmY7PhCfg==", orders[i].orderId,orders[i].orderDate,userName).then((_) {
              setState(() {
                String date = dateFormat.format(requestDate);
                getOrderList(userName,date);
              });
            });
          }
        }
      }
      else{
        Fluttertoast.showToast(
            msg: "Connection Fail!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1);
      }
    });

  }

  void checkData() async{
    final database = await Common.instance.getAppDatabase();

    List<ItemTable> itemList = await database.itemDao.getAllItem();
    List<ItemUnitTable> itemUnitList = await database.itemUnitDao.getAllItemUnit();
    List<GenericTable> genericList = await database.genericDao.getAllGeneric();
    List<StationTable> stationList = await database.stationDao.getAllStation();

    if(itemList.length==0 || genericList.length==0 || itemUnitList.length==0 || stationList.length==0){
      setState(() {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.only(left: 10,right: 10),
              content: Text('Need to downlod data first!'),
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
      });
    }
    else{
      Common.instance.setStringValue(Constants.user_id, userID);

      Common.instance.setStringValue(Constants.order_id, "");
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen()
            ),
            ModalRoute.withName(OrderDetailScreen.routeName));
      });
    }
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
      Navigator.pop(context);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: requestDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != requestDate)
      setState(() {
        requestDate = picked;
        String date = dateFormat.format(requestDate);
        getOrderList(userName,date);
      });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()
            ),
            ModalRoute.withName(HomeScreen.routeName));
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Platform.isIOS? AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()
                  ),
                  ModalRoute.withName(HomeScreen.routeName));
            },
          ),
          centerTitle: true,
          title: Text('Ordering List'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.cloud_download,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: (){
                  Common.instance.check().then((intenet) {
                    if (intenet != null && intenet) {
                      showLoaderDialog(context);
                      Provider.of<GenericProvider>(context,listen: false)
                          .callGenericDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
                          .then((_){
                        setState(() {
                          callItemDownload();
                        });
                        print("Item Download Success");
                      });
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Connection Fail!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                    }
                  });
                }),

          ],
        ) :AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()
                  ),
                  ModalRoute.withName(HomeScreen.routeName));
            },
          ),
          title: Text('Ordering List'),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.cloud_download,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: (){
                  Common.instance.check().then((intenet) {
                    if (intenet != null && intenet) {
                      showLoaderDialog(context);
                      Provider.of<GenericProvider>(context,listen: false)
                          .callGenericDownload("1B2M2Y8AsgTpgAmY7PhCfg==")
                          .then((_){
                        setState(() {
                          callItemDownload();
                        });
                        print("Item Download Success");
                      });
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Connection Fail!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                    }
                  });

            }),

          ],
        ),
        body: RefreshIndicator(
          onRefresh: callDownloadData,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      requestDate = DateTime(requestDate.year,
                          requestDate.month, requestDate.day - 1);
                      setState(() {
                        String date = dateFormat.format(requestDate);
                        getOrderList(userName,date);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Text(
                            '${dateFormat.format(requestDate)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16
                            )
                        ),
                        onTap: (){
                          _selectDate(context);
                        },
                      ),
                      Container(
                          child: Image.asset(
                            'assets/image/calendar.png',
                            width: 20,
                            height: 20,
                          )
                      ),
                    ],
                  ),*/
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(left: 15,top: 8,right:15,bottom: 8,),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                              '${dateFormat.format(requestDate)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                              child: Image.asset(
                                'assets/image/calendar.png',
                                width: 20,
                                height: 20,
                              )
                          ),
                        ],
                      ),
                    ),
                      onTap: (){
                        _selectDate(context);
                      },
                  ),
                  IconButton(
                    onPressed: (){
                      requestDate = DateTime(requestDate.year,
                          requestDate.month, requestDate.day + 1);
                      setState(() {
                        String date = dateFormat.format(requestDate);
                        getOrderList(userName,date);
                      });
                    },
                    icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                  ),)
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    'Total Count : ${orderData.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(left: 5,top: 15,bottom: 15),
                margin: EdgeInsets.only(left: 10,right: 10,top: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                        child: Container(
                          child: Text(
                              'Request No',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          ),
                    )),
                    Expanded(
                      flex: 3,
                      child: Container(
                          child: Text(
                              'Request Type',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16)
                          )
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                          child: Text('Status',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              )
                          )
                      ),
                    ),
                  ],
                ),
              ),
              orderData.length>0?OrderList(orderData):Container(
                margin: EdgeInsets.only(top: 20),
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset('assets/image/warehouse_scan.jpg'),
                ),
              ),

            ],
          ),
        ),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              onPressed: (){
                setState(() {
                  checkData();
                });
              }
          ),
        /*bottomSheet: Padding(
          padding: EdgeInsets.only(left: 5,bottom: 10.0),
          child: Text(
            '© 2021 SYSTEMATIC Business Solution Co.,Ltd.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),*/
      ),
    );
  }
}
