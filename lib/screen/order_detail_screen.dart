import 'dart:io';

import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/generic_table.dart';
import 'package:cns/database/entity/item_table.dart';
import 'package:cns/database/entity/item_unit_table.dart';
import 'package:cns/database/entity/order_item_table.dart';
import 'package:cns/database/entity/order_table.dart';
import 'package:cns/database/entity/station_entity.dart';
import 'package:cns/database/entity/user_table.dart';
import 'package:cns/database/model/order_item_model.dart';
import 'package:cns/database/model/order_model.dart';
import 'package:cns/database/model/request_item.dart';
import 'package:cns/database/model/request_model.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:cns/widget/request_item_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'ordering_list_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  static final String routeName = '/order_detail_screen';
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

List<String> unitList = [];
List<String> strStationList = [];
//String currentSelectedValue = "PC";

class ListItem{
  int value;
  String name;
  ListItem(this.value, this.name);
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _requestNoController = TextEditingController();
  final _requestNoFocusNode = FocusNode();
  final _requestStatusController = TextEditingController();
  final _requestStatusFocusNode = FocusNode();
  final _mrTypeController = TextEditingController();
  final _mrTypeNoFocusNode = FocusNode();
  final _requestByController = TextEditingController();
  final _requestByFocusNode = FocusNode();
  final _requestToController = TextEditingController();
  final _requestToFocusNode = FocusNode();
  final _stationNameController = TextEditingController();
  final _stationNameFocusNode = FocusNode();
  final _approveByController = TextEditingController();
  final _approveByFocusNode = FocusNode();
  final _superApproveByController = TextEditingController();
  final _superApproveByFocusNode = FocusNode();
  final _remarkController = TextEditingController();
  final _remarkFocusNode = FocusNode();
  final _statusRemarkController = TextEditingController();
  final _statusRemarkFocusNode = FocusNode();
  final _qtyController = TextEditingController();
  final _qtyFocusNode = FocusNode();
  final _itemRemarkController = TextEditingController();
  final _itemRemarkFocusNode = FocusNode();

  final textEditingController = TextEditingController();

  final TextEditingController _tradeController = TextEditingController();
  final TextEditingController _genericController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final _tradeFocusNode = FocusNode();
//  final _statusRemarkFocusNode = FocusNode();

  late var _strDate = "";
  late var _strTime = "";
  late var _selectedTradeName = "";
  late var _selectedGenericName = "";
  late var _selectedUnit;
  late var _selectedTradeID = "";
  late var _selectedGenericID = "";
  late var _selectedUnitID = "";
  late var _selectedTradeIndex;
  late var _selectedStationIndex;
  late var _selectedGenericIndex;
  late var _selectedUnitIndex;
  late var _selectedStationID = "";
  late String _selectedStation;
  late String _orderDate="";


  List<String> genericList = [];
  List<String> tradeList = [];
  List<GenericTable> generic = [];
  List<ItemTable> trades = [];
  List<OrderItemTable> orderitems = [];
  List<StationTable> stations = [];
  List<ItemUnitTable> itemUnit=[];
  List<ItemUnitTable> itemUnits=[];

  Map<String, String> selectedValueMap = Map();

  String orderID = "";
  String userID = "";
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
  DateFormat orderDateFormat = DateFormat("dd/MM/yyyy");
  String requestDate = "";
  var hasSuperApprove=false;
  var hasApprove=false;
  var hasData = false;
  var isStatusNew = true;
  var stationenable = true;
  var userName ="";

  var _chosenValue;

  var _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _requestNoController.text = '';
    _requestStatusController.text = 'New';
    _selectedUnit = "";
    stationenable = true;

    getData();
    getDataForSpinner();

    _getStation("");
    _getTrades("");
    _getGeneric("");


  }

  void _loadOrderData(String orderID) async{
    final database = await Common.instance.getAppDatabase();

    List<OrderTable> orderInfo= await database.orderDao.getByOrderId(orderID);
    print("OrderList"+orderInfo.length.toString());
    if(orderInfo.length>0){
      _requestNoController.text = orderInfo[0].requestNo;
      _requestStatusController.text = orderInfo[0].requestStatus;
      _mrTypeController.text = orderInfo[0].mrType;
      _requestByController.text = orderInfo[0].requestBy;
      _requestToController.text = orderInfo[0].requestTo;


      String str = dateFormat.format(DateTime.parse(orderInfo[0].date));
      setState(() {
        var parts = str.split(' ');
        _strDate = parts[0].trim();
        _strTime = parts[1].trim();
      });

      if(orderInfo[0].requestStatus!="New"){
        setState(() {
          isStatusNew = false;
        });
      }

      _selectedStationID = orderInfo[0].stationName;
      if(_selectedStationID!=null){
        List<StationTable> stationInfo = await database.stationDao.getByID(_selectedStationID);
        if(stationInfo.length>0){
          print("stationInfo"+stationInfo[0].StationName);
          _stationController.text = stationInfo[0].StationName;
        }
      }

      _remarkController.text = orderInfo[0].remark;
      _statusRemarkController.text = orderInfo[0].statusRemark;

      if(orderInfo[0].approvedBy.isNotEmpty){
        hasApprove=true;
        List<UserTable> userInfo = await database.userDao.getUserByUserId(orderInfo[0].approvedBy);
        if(userInfo!=null){
          _approveByController.text = userInfo[0].UserName;

        }
      }
      if(orderInfo[0].superApproveBy.isNotEmpty){
        hasSuperApprove=true;
        List<UserTable> userInfo = await database.userDao.getUserByUserId(orderInfo[0].superApproveBy);
        if(userInfo!=null){
          _superApproveByController.text = userInfo[0].UserName;

        }
      }

      List<OrderItemTable> orderItemInfo = await database.orderItemDao.getByOrderId(orderInfo[0].orderId);
      if(orderItemInfo.length>0){
        orderitems.clear();
        setState(() {
          print("orderItemInfo"+orderItemInfo.length.toString());
          for(int i=0;i<orderItemInfo.length;i++){
            orderitems.add(
                orderItemInfo[i]
            );
          }
        });
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    _requestNoFocusNode.dispose();
    _requestStatusFocusNode.dispose();
    _mrTypeNoFocusNode.dispose();
    _stationNameFocusNode.dispose();
    _approveByFocusNode.dispose();
    _superApproveByFocusNode.dispose();
    _requestByFocusNode.dispose();
    _requestToFocusNode.dispose();
    _remarkFocusNode.dispose();
    _statusRemarkFocusNode.dispose();
    _qtyFocusNode.dispose();
    _itemRemarkFocusNode.dispose();
  }

  void getData(){

    Common.instance
        .getStringValue(Constants.user_id)
        .then((value) => setState(() {
      userID = value;
      getUserInfo(userID);
    }));

    Common.instance
        .getStringValue(Constants.user_name)
        .then((value) => setState(() {
      userName = value;
      getStation(userName);
    }));

    Common.instance
        .getStringValue(Constants.order_id)
        .then((value) => setState(() {
      orderID = value;
      print("orderID :"+orderID);
      if(orderID==null || orderID==""){
        orderID = Uuid().v1();
      }
      else{
        setState(() {
          hasData = true;
          _loadOrderData(orderID);
        });
      }
    }));

    String str = dateFormat.format(DateTime.now());
    requestDate = dateFormat.format(DateTime.now());
    _orderDate = orderDateFormat.format(DateTime.now());
    setState(() {
      var parts = str.split(' ');
      _strDate = parts[0].trim();
      _strTime = parts[1].trim();
    });
  }

  void getStation(String StationID) async{
    _selectedStationID = StationID;
    final database = await Common.instance.getAppDatabase();

    if(_selectedStationID!=null){
      List<StationTable> stationInfo = await database.stationDao.getByID(_selectedStationID);
      if(stationInfo.length>0){
        print("stationInfo"+stationInfo[0].StationName);
        _stationController.text = stationInfo[0].StationName;
      }
    }
  }

  void getUserInfo(String userID) async {
    final database = await Common.instance.getAppDatabase();

    List<UserTable> userInfo = await database.userDao.getUserByUserId(userID);
    print("UserInfo"+userInfo.length.toString());
    setState(() {
      if(userInfo.length>0){
        print("UserID"+userInfo[0].UserID);
        print("UserName"+userInfo[0].UserName);
        _requestByController.text = userInfo[0].UserName;

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
      }
    });
  }

  void clearItem(){
    _selectedTradeName = "";
    _selectedTradeID = "";
    _selectedGenericName = "";
    _selectedGenericID = "";
    _tradeController.text = "";
    _qtyController.text = "";
    _genericController.text= "";
    _unitController.text= "";
    _itemRemarkController.text = "";
    _selectedUnit = "";
    _selectedUnitID = "";
    _qtyFocusNode.requestFocus();

  }

  //find and create list of matched strings
  List<String> _getTrades(String query) {
    List<String> matches = [];

    matches.addAll(tradeList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> _getUnit(String query) {
    List<String> matches = [];

    matches.addAll(unitList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //find and create list of matched strings
  List<String> _getGeneric(String query) {
    List<String> matches = [];

    matches.addAll(genericList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  //find and create list of matched strings
  List<String> _getStation(String query) {

    List<String> matches = [];
    matches.addAll(strStationList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future<void> getDataForSpinner() async {
    final database = await Common.instance.getAppDatabase();

    generic = await database.genericDao.getAllGeneric();

    trades = await database.itemDao.getAllItem();

    stations = await database.stationDao.getAllStation();

    genericList.clear();
    tradeList.clear();
    strStationList.clear();

    setState(() {
      if(generic.length>0){
        for(int i=0;i<generic.length;i++){
          genericList.add(generic[i].GenericName);

        }
      }

      if(trades.length>0){
        for(int i=0;i<trades.length;i++){
          tradeList.add(trades[i].ItemName);


        }
      }

      if(stations.length>0){
        for(int i = 0;i<stations.length;i++){
          strStationList.add(stations[i].StationName);

        }
      }
    });

  }

  void getUnit(String itemID) async {
    final database = await Common.instance.getAppDatabase();
    var value;
    itemUnit = await database.itemUnitDao.getById(itemID);
    unitList.clear();
    _chosenValue = value;
    for(int i=0;i<itemUnit.length;i++){
      setState(() {
        unitList.add(itemUnit[i].UomLabel);
        _selectedUnit = itemUnit[0].UomLabel;
        _selectedUnitID = itemUnit[0].ItemUOMID;
        _unitController.text = itemUnit[0].UomLabel;
        _chosenValue = unitList[0];
        print(unitList.length);
      });
    }

    setState(() {
      if(unitList.isNotEmpty){
        for(int j=0;j<itemUnit.length;j++){
          if(itemUnit[j].Seq == "0"){
            setState((){
              _selectedUnit = itemUnit[j].UomLabel;
              _selectedUnitID = itemUnit[j].ItemUOMID;
              _unitController.text = itemUnit[j].UomLabel;
              _chosenValue = unitList[j];

            });
            break;
          }
          else if(itemUnit[j].Seq == "1"){
            setState(() {
              _selectedUnit = itemUnit[j].UomLabel;
              _selectedUnitID = itemUnit[j].ItemUOMID;
              _unitController.text = itemUnit[j].UomLabel;
              _chosenValue = unitList[j];
            });
            break;
          }
        }
        print("ChooseUnit_:$_chosenValue");
      }
    });

  }

  void getUnitByGeneric(String genericID) async{
    final database = await Common.instance.getAppDatabase();
    var value;
    List<ItemTable> itemList = await database.itemDao.getByGenericId(genericID);
    print("itemList"+itemList.length.toString());

    unitList.clear();
    itemUnits.clear();
    if(itemList.length>0){
      for(int j=0;j<itemList.length;j++){
        itemUnit = await database.itemUnitDao.getById(itemList[j].ItemID);
        _chosenValue = value;
        for(int i=0;i<itemUnit.length;i++){
          itemUnits.add(itemUnit[i]);
          setState(() {
            print("Do..");
            if(unitList.length>0){
              print("Do...");
              for(int u=0;u<unitList.length;u++){
                if(unitList[u] == itemUnit[i].UomLabel){
                  print("Remove.."+unitList[u]);
                  unitList.remove(unitList[u]);
                  itemUnits.removeAt(u);
                  break;
                }

              }
            }
            print("Add..");
            unitList.add(itemUnit[i].UomLabel);

            print(itemUnit[i].UomLabel);
            _selectedUnit = itemUnits[0].UomLabel;
            _selectedUnitID = itemUnits[0].ItemUOMID;
            _unitController.text = itemUnits[0].UomLabel;
            _chosenValue = unitList[0];
            print(unitList.length);
            print(itemUnits.length);
          });
        }
        setState(() {
          if(itemUnits.length>0){
            for(int b=0;b<itemUnits.length;b++){
              if(itemUnits[b].Seq == "0"){
                _selectedUnit = itemUnits[b].UomLabel;
                _selectedUnitID = itemUnits[b].ItemUOMID;
                _unitController.text = itemUnits[b].UomLabel;
                _chosenValue = unitList[b];
                break;
              }
              else if(itemUnits[b].Seq == "1"){
                _selectedUnit = itemUnits[b].UomLabel;
                _selectedUnitID = itemUnits[b].ItemUOMID;
                _unitController.text = itemUnits[b].UomLabel;
                _chosenValue = unitList[b];
                break;
              }

            }
          }
        });
      }
    }
  }

  void callAddOrderOnPressBack(){
    final request = Request(
        MRID: orderID,
        MRNo: "",
        MRDate: requestDate,
        MRType: _mrTypeController.text,
        RequestByID: _requestByController.text,
        RequestToID: _requestToController.text,
        StationID: _selectedStationID,
        MRStatus: _requestStatusController.text,
        ApprovedBy: "",
        SuperApprovedBy: "",
        ApprovedRemark: _remarkController.text,
        StatusRemark: _statusRemarkController.text,
        CreatedBy: userID,
        CreatedOn: dateFormat.format(DateTime.now()),
        ModifiedBy: userID,
        ModifiedOn: dateFormat.format(DateTime.now()));

    final orders = OrderModel(
        orderId: orderID,
        requestNo: "",
        date: requestDate,
        requestStatus: _requestStatusController.text,
        mrType: _mrTypeController.text,
        requestBy: _requestByController.text,
        requestTo: _requestByController.text,
        stationName:_selectedStationID,
        remark: _remarkController.text,
        statusRemark: _statusRemarkController.text,
        approvedBy: "",
        superApproveBy: "",
        modifyBy: userID,
        modifyOn: dateFormat.format(DateTime.now()),
        createdBy: userID,
        createdOn: dateFormat.format(DateTime.now()),
        isUpload: "False"
    );
    setState(() {
      Provider.of<RequestProvider>(context,listen: false)
          .callUploadRequest("1B2M2Y8AsgTpgAmY7PhCfg==",
          request,orders
      ).then((_) {
        setState(() {
          callDownloadDataOnPressBack();
        });
//        Navigator.pushReplacementNamed(context, OrderListScreen.routeName);
      });
    });
  }

  void callDownloadDataOnPressBack(){
    Provider.of<RequestProvider>(context,listen: false)
        .callDownloadRequest("1B2M2Y8AsgTpgAmY7PhCfg==", orderID,_orderDate,userName).then((_) {
      setState(() {
        if(hasData){
          Fluttertoast.showToast(
              msg: "Update Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
        else{
          Fluttertoast.showToast(
              msg: "Save Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OrderListScreen()
            ),
            ModalRoute.withName(OrderListScreen.routeName));
      });
    });
  }

  void callAddOrder(){
    final request = Request(
        MRID: orderID,
        MRNo: "",
        MRDate: requestDate,
        MRType: _mrTypeController.text,
        RequestByID: _requestByController.text,
        RequestToID: _requestToController.text,
        StationID: _selectedStationID,
        MRStatus: _requestStatusController.text,
        ApprovedBy: "",
        SuperApprovedBy: "",
        ApprovedRemark: _remarkController.text,
        StatusRemark: _statusRemarkController.text,
        CreatedBy: userID,
        CreatedOn: dateFormat.format(DateTime.now()),
        ModifiedBy: userID,
        ModifiedOn: dateFormat.format(DateTime.now()));

    final orders = OrderModel(
        orderId: orderID,
        requestNo: "",
        date: requestDate,
        requestStatus: _requestStatusController.text,
        mrType: _mrTypeController.text,
        requestBy: _requestByController.text,
        requestTo: _requestByController.text,
        stationName:_selectedStationID,
        remark: _remarkController.text,
        statusRemark: _statusRemarkController.text,
        approvedBy: "",
        superApproveBy: "",
        modifyBy: userID,
        modifyOn: dateFormat.format(DateTime.now()),
        createdBy: userID,
        createdOn: dateFormat.format(DateTime.now()),
        isUpload: "False"
    );
    setState(() {
      Provider.of<RequestProvider>(context,listen: false)
          .callUploadRequest("1B2M2Y8AsgTpgAmY7PhCfg==",
          request,orders
      ).then((_) {
        setState(() {
          callDownloadData();
        });
//        Navigator.pushReplacementNamed(context, OrderListScreen.routeName);
      });
    });
  }

  void callDownloadData(){
    Provider.of<RequestProvider>(context,listen: false)
        .callDownloadRequest("1B2M2Y8AsgTpgAmY7PhCfg==", orderID,_orderDate,userName).then((_) {
      setState(() {

        Navigator.pop(context);
        if(hasData){
          Fluttertoast.showToast(
              msg: "Update Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
        else{
          Fluttertoast.showToast(
              msg: "Save Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }

        loadNewRecord();
      });
    });
  }
  void loadNewRecord(){
    setState(() {
      orderitems.clear();
      orderID = Uuid().v1();
      hasData = false;
      hasSuperApprove=false;
      hasApprove=false;
      isStatusNew = true;

      String str = dateFormat.format(DateTime.now());
      requestDate = dateFormat.format(DateTime.now());
      _orderDate = orderDateFormat.format(DateTime.now());
      setState(() {
        var parts = str.split(' ');
        _strDate = parts[0].trim();
        _strTime = parts[1].trim();
      });

    });

    if(!stationenable){
      _selectedStationID = "";
      _stationController.text = "";
    }


//    _selectedStationID = "";

    _requestStatusController.text = "New";
    _mrTypeController.text = "";
    _requestToController.text = "";
//    _stationController.text = "";
    _remarkController.text = "";
    _statusRemarkController.text = "";

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

  void callAddRequestItem(){
    print("_selectedGenericID"+_selectedGenericID);
    String orderItemID = Uuid().v1();
    Provider.of<RequestItemProvider>(context,listen: false)
        .callUploadRequestItem("1B2M2Y8AsgTpgAmY7PhCfg==",
        RequestItem(
            MRItemID: orderItemID,
            MRID: orderID,
            ItemID: _selectedTradeID,
            GenericID: _selectedGenericID,
            RequestQty: _qtyController.text,
            IssueQty: "",
            RemainQty: "",
            TotalRemainQty: "",
            Remark: _itemRemarkController.text, UnitID: _selectedUnitID,
            LocationID: "",
            CreatedBy: userID,
            CreatedOn: dateFormat.format(DateTime.now()),
            ModifiedBy: userID,
            ModifiedOn: dateFormat.format(DateTime.now())),OrderItemModel(
            orderItemId: orderItemID,
            orderId: orderID,
            itemId: _selectedTradeID,
            itemName: _selectedTradeName,
            genericId: _selectedGenericID,
            genericName: _selectedGenericName,
            unitId: _selectedUnitID,
            unitName: _selectedUnit,
            qty: _qtyController.text, remark: _itemRemarkController.text,
            modifyBy: userID,
            modifyOn: dateFormat.format(DateTime.now()),
            createdBy: userID,
            createdOn: dateFormat.format(DateTime.now())
        )
    ).then((_){
      setState(() {
        getOrderItemList(orderID);
      });
    });
    setState(() {
      _chosenValue = null;
      unitList.clear();
      getUnit("");
      getUnitByGeneric("");
      clearItem();
    });
  }

  void getOrderItemList(String orderID) async {
    final database = await Common.instance.getAppDatabase();

    List<OrderItemTable> orderItemInfo = await database.orderItemDao.getByOrderId(orderID);

    if(orderItemInfo.length>0){
      orderitems.clear();
      setState(() {
        print("orderItemInfo"+orderItemInfo.length.toString());
        for(int i=0;i<orderItemInfo.length;i++){
          orderitems.add(
              orderItemInfo[i]
          );
        }
      });
    }
  }

  void _showExitDialog(){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 10,right: 10),
          content: Text('Discard your changes?'),
          actions: [
            FlatButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  showSaveDataDialog();
                });
              },
              child: Text('No',style: TextStyle(color: Colors.blue),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderListScreen()
                    ),
                    ModalRoute.withName(OrderListScreen.routeName));
              },
              child: Text('Yes',style: TextStyle(color: Colors.blue)),
            ),
          ],
        )
    );
  }

  void checkHasChanges() async{
    final database = await Common.instance.getAppDatabase();

    List<OrderItemTable> orderItemInfo = await database.orderItemDao.getByOrderId(orderID);
    List<OrderTable> orderInfo = await database.orderDao.getByOrderId(orderID);

    if(isStatusNew){
      if(_mrTypeController.text!=""){
        setState(() {
          _showExitDialog();
        });
      }
      else if(_requestToController.text!=""){
        setState(() {
          _showExitDialog();
        });
      }
      else if(orderItemInfo.length>0 && orderInfo.length==0){
        setState(() {
          _showExitDialog();
        });
      }
      else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => OrderListScreen()
            ),
            ModalRoute.withName(OrderListScreen.routeName));
      }
    }
    else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => OrderListScreen()
          ),
          ModalRoute.withName(OrderListScreen.routeName));
    }

  }

  void showSaveDataDialog(){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 10,right: 10),
          content: Text('Are you sure want to save?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No',style: TextStyle(color: Colors.blue),),
            ),
            FlatButton(
              onPressed: () {
                if(_selectedStationID.isEmpty && _selectedStationID==""){
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "Station name is required!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1);
                }
                else{
                  setState(() {
                    Common.instance.check().then((intenet) {
                      if (intenet != null && intenet) {
                        Navigator.of(context).pop();
                        showLoaderDialog(context);
                        callAddOrderOnPressBack();
                      }
                      else{
                        Fluttertoast.showToast(
                            msg: "Connection Fail!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1);
                        Navigator.pop(context);

                      }
                    });

                  });
                }
              },
              child: Text('Yes',style: TextStyle(color: Colors.blue)),
            ),
          ],
        )
    );
  }


  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: (){
            setState(() {
              _chosenValue = null;
              unitList.clear();
              getUnit("");
              getUnitByGeneric("");
              clearItem();
              Navigator.pop(context);
            });
            return Future.value(false);
          },
          child: AlertDialog(
            insetPadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                              'Request Item Detail',
                              style: TextStyle(
                                  color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),
                            )
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.clear,color: Colors.white,size: 30,),
                            onPressed: (){
                              _chosenValue = null;
                              unitList.clear();
                              getUnit("");
                              clearItem();
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Text(
                            'Trade Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _tradeController,
                                  maxLines: 2,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 20,bottom: 6),
                                  hintText: 'Please Select',
                                    suffixIcon: Icon(Icons.arrow_drop_down)
                                ),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                onChanged: (value){
                                  if(value.length==0){
                                    if(_tradeController.text.isEmpty){
                                      getUnitByGeneric(_selectedGenericID);
                                      _qtyFocusNode.requestFocus();
                                    }
                                    else{
                                      setState(() {
                                        getUnit("");
                                      });
                                    }
                                  }
                                },
                              ),
                                suggestionsCallback: (String pattern) {
                                  return _getTrades(pattern);
                                },
                                itemBuilder: (context, String suggestion) {
                                  return ListTile(
                                    title: Text(suggestion),
                                  );
                                },
                                transitionBuilder: (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (String suggestion) {
                                  _tradeController.text = suggestion;
                                  _selectedTradeName = suggestion;
                                  print("TradeName"+_selectedTradeName);
                                  _selectedTradeIndex = tradeList.indexOf(suggestion);
                                  ItemTable items = trades[_selectedTradeIndex];
                                  setState(() {
                                    if(items!=null){
                                      print("TradeID"+items.ItemID);
                                      _selectedGenericName = items.GenericName;
                                      _genericController.text = items.GenericName;
                                      _selectedGenericID = items.GenericID;
                                      _selectedTradeID = items.ItemID;
                                      getUnit(items.ItemID);

                                      print("_selectedGenericID"+_selectedGenericID);
                                    }
                                  });

                                },
                                validator: (val) => val!.isEmpty
                                    ? 'Please Select'
                                    : null,
                                onSaved: (val){
                                  setState((){
                                    _selectedTradeName = val!;
                                  });
                                },
                              ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Text(
                            'Generic Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _genericController,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(top: 20,bottom: 6),
                                    hintText: 'Please Select',
                                      suffixIcon: Icon(Icons.arrow_drop_down)
                                  ),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                onChanged: (value){
                                  if(value.length==0 && _tradeController.text.isEmpty){
                                    getUnitByGeneric("");
                                  }
                                }
                              ),
                              suggestionsCallback: (String pattern) {
                                return _getGeneric(pattern);
                              },
                              itemBuilder: (context, String suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              transitionBuilder: (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (String suggestion) {
                                _genericController.text = suggestion;

                                _selectedGenericIndex = genericList.indexOf(suggestion);
                                GenericTable generics = generic[_selectedGenericIndex];
                                if(generics!=null){
                                  _selectedGenericID = generics.GenericID;
                                  _selectedGenericName = generics.GenericName;
                                  print("generic");
                                  if(_tradeController.text.isEmpty){
                                    print("Selectgeneric");
                                    getUnitByGeneric(_selectedGenericID);
                                    _qtyFocusNode.requestFocus();
                                  }
                                }

                              },
                              validator: (val) => val!.isEmpty
                                  ? 'Please Select'
                                  : null,
                              onSaved: (val){
                                setState(() {
                                  _selectedGenericName = val!;
                                }
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Text(
                            'Unit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {

                              FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: _unitController,
                                cursorColor: Colors.transparent,
                                cursorWidth: 0,
                                maxLines: 2,
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(top: 20,bottom: 6),
                                    hintText: 'Please Select',
                                    suffixIcon: Icon(Icons.arrow_drop_down)
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                                onChanged: (value){
                                  setState(() {
                                    _chosenValue = value;
                                    _qtyFocusNode.requestFocus();
                                    _selectedUnit = _chosenValue.toString();

                                    if(_tradeController.text.isEmpty){
                                      _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                      ItemUnitTable unit = itemUnits[_selectedUnitIndex];
                                      if(unit!=null){
                                        _selectedUnitID = unit.ItemUOMID;
                                        print("_selectedUnitID"+_selectedUnitID);
                                      }
                                    }
                                    else{
                                      _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                      ItemUnitTable unit = itemUnit[_selectedUnitIndex];
                                      if(unit!=null){
                                        _selectedUnitID = unit.ItemUOMID;
                                        print("_selectedUnitID"+_selectedUnitID);
                                      }
                                    }
                                    print("VAlue"+_chosenValue.toString());
                                  });
                                },
                              ),
                              suggestionsCallback: (String pattern) {
                                return _getUnit("");
                              },
                              itemBuilder: (context, String suggestion) {
                                return ListTile(
                                  title: Text(suggestion),
                                );
                              },
                              transitionBuilder: (context, suggestionsBox, controller) {
                                return suggestionsBox;
                              },
                              onSuggestionSelected: (String suggestion) {
                                _unitController.text = suggestion;
                                _selectedUnit = suggestion;
                                if(_tradeController.text.isEmpty){
                                  _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                  ItemUnitTable unit = itemUnits[_selectedUnitIndex];
                                  if(unit!=null){
                                    _selectedUnitID = unit.ItemUOMID;
                                    print("_selectedUnitID"+_selectedUnitID);
                                  }
                                }
                                else{
                                  _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                  ItemUnitTable unit = itemUnit[_selectedUnitIndex];
                                  if(unit!=null){
                                    _selectedUnitID = unit.ItemUOMID;
                                    print("_selectedUnitID"+_selectedUnitID);
                                  }
                                }
                                print("VAlue"+_chosenValue.toString());

                              },
                              validator: (val) => val!.isEmpty
                                  ? 'Please Select'
                                  : null,
                              onSaved: (val){
                                setState((){
                                  _selectedUnit = val!;
                                });
                              },
                            ),
                          ),
                        )
                        /*Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: DropdownButton<String>(
                              focusColor:Colors.white,
                              value: _chosenValue,
                              isExpanded: true,
                              //elevation: 5,
                              style: TextStyle(color: Colors.white),
                              items: unitList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style:TextStyle(color:Colors.black),),
                                );
                              }).toList(),
                              hint:Text(
                                "Please Select",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _chosenValue = value;
                                  _qtyFocusNode.requestFocus();
                                  _selectedUnit = _chosenValue.toString();

                                  if(_tradeController.text.isEmpty){
                                    _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                    ItemUnitTable unit = itemUnits[_selectedUnitIndex];
                                    if(unit!=null){
                                      _selectedUnitID = unit.ItemUOMID;
                                      print("_selectedUnitID"+_selectedUnitID);
                                    }
                                  }
                                  else{
                                    _selectedUnitIndex = unitList.indexOf(_selectedUnit);
                                    ItemUnitTable unit = itemUnit[_selectedUnitIndex];
                                    if(unit!=null){
                                      _selectedUnitID = unit.ItemUOMID;
                                      print("_selectedUnitID"+_selectedUnitID);
                                    }
                                  }
                                  print("VAlue"+_chosenValue.toString());
                                });
                              },
                            ),
                          ),
                        )*/
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Text(
                            'Qty',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextField(
                            controller: _qtyController,
                            focusNode: _qtyFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,

                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                          child: Text(
                            'Remark',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: TextField(
                            controller: _itemRemarkController,
                            focusNode: _itemRemarkFocusNode,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,

                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    if(_tradeController.text.isEmpty){
                      _selectedTradeID="";
                      _selectedTradeName="";
                    }
                    if(_genericController.text.isEmpty){
                      _selectedGenericName="";
                      _selectedGenericID="";
                    }

                    if(_tradeController.text.isEmpty && _genericController.text.isEmpty){
                      _selectedUnitID ="";
                      _selectedUnit="";
                    }

                    if(_qtyController.text.isEmpty){
                      Fluttertoast.showToast(
                          msg: "Qty is required!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                    }
                    else{
                      setState(() {
                        Common.instance.check().then((intenet) {
                          if (intenet != null && intenet) {
                            callAddRequestItem();
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                              currentFocus.focusedChild!.unfocus();
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

                      });
                    }

                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width/3.5,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)
                        )
                    ),
                    child: Center(
                      child: Text('Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        checkHasChanges();

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        appBar: Platform.isIOS? AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              checkHasChanges();
            },
          ),
          centerTitle: true,
          title: Text('Ordering Detail'),
          actions: [
            !isStatusNew?InkWell(
              onTap: (){
                loadNewRecord();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/image/add_file.png',
                  height: 25,
                  width: 25,
                ),
              ),
            ):IconButton(
                onPressed: (){
                  if(_selectedStationID.isEmpty && _selectedStationID==""){
                    Fluttertoast.showToast(
                        msg: "Station name is required!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  }
                  else{
                    Common.instance.check().then((intenet) {
                      if (intenet != null && intenet) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              insetPadding: EdgeInsets.only(left: 10,right: 10),
                              content: Text('Are you sure want to save?'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No',style: TextStyle(color: Colors.blue),),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    setState(() {
                                      showLoaderDialog(context);
                                      callAddOrder();

                                    });
                                  },
                                  child: Text('Yes',style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            )
                        );
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
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                  size: 30,
                )
            ),

          ],
        ) :AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              checkHasChanges();
            },
          ),
          title: Text('Ordering Detail'),
          actions: [
            !isStatusNew?InkWell(
              onTap: (){
                loadNewRecord();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  'assets/image/add_file.png',
                  height: 25,
                  width: 25,
                ),
              ),
            ):IconButton(
                onPressed: (){
                  if(_selectedStationID.isEmpty && _selectedStationID==""){
                    Fluttertoast.showToast(
                        msg: "Station name is required!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1);
                  }
                  else{
                    Common.instance.check().then((intenet) {
                      if (intenet != null && intenet) {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              insetPadding: EdgeInsets.only(left: 10,right: 10),
                              content: Text('Are you sure want to save?'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('No',style: TextStyle(color: Colors.blue),),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                    setState(() {
                                      showLoaderDialog(context);
                                      callAddOrder();

                                    });
                                  },
                                  child: Text('Yes',style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            )
                        );
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

                },
                icon: Icon(Icons.save,color: Colors.white,size: 30,)
            ),


          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height/1.24,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(10),
            children: [
              hasData?Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 5,right:15),
                    alignment: Alignment.centerRight,
                    child: Text('Request No',style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _requestNoController,
                        focusNode: _requestNoFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enabled: false,

                      ),
                    ),
                  )
                ],
              ):Container(),
              Container(
                margin: hasData?EdgeInsets.only(top: 20,bottom: 5):EdgeInsets.only(top:10,bottom: 5),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 15),
                      child: Text('Date',style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/image/calendar.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(_strDate),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Image.asset(
                                'assets/image/clock.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(_strTime),
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Status',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _requestStatusController,
                        focusNode: _requestStatusFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enabled: false,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('MR Type',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _mrTypeController,
                        focusNode: _mrTypeNoFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enabled: !isStatusNew? false:true,
                        style: TextStyle(
                          fontSize: 14,
                        ),

                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Request By',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _requestByController,
                        focusNode: _requestByFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enabled: false,
                        style: TextStyle(
                          fontSize: 14,
                        ),

                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Request To',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _requestToController,
                        focusNode: _requestToFocusNode,
                        enabled: !isStatusNew? false:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Station Name',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _stationController,
                            maxLines: 2,
                            enabled: !stationenable? true : false,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 20),
                              hintText: 'Please Select',
                              suffixIcon: Container(
//                              transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                            )
                        ),
                        suggestionsCallback: (String pattern) {
                          return _getStation(pattern);
                        },
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (String suggestion) {
                          _stationController.text = suggestion;
                          _selectedStationIndex = strStationList.indexOf(suggestion);
                          StationTable station = stations[_selectedStationIndex];
                          if(station!=null){
                            _selectedStationID = station.StationID;
                          }

                        },
                        validator: (val) => val!.isEmpty
                            ? 'Please Select'
                            : null,
                        onSaved: (val){
                          setState(() {
                            _selectedStation = val!;
                          }
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              hasApprove?Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Approved By 1',style: TextStyle(fontWeight: FontWeight.bold) ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _approveByController,
                        focusNode: _approveByFocusNode,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14,
                        ),

                      ),
                    ),
                  )
                ],
              ):Container(),
              hasSuperApprove?Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Approved By 2',style: TextStyle(fontWeight: FontWeight.bold) ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _superApproveByController,
                        focusNode: _superApproveByFocusNode,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ):Container(),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10,right: 15),
                    alignment: Alignment.centerRight,
                    child: Text('Remark',style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _remarkController,
                        focusNode: _remarkFocusNode,
                        enabled: !isStatusNew? false:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  )
                ],
              ),
              /*Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/3,
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Status Remark',style: TextStyle(fontWeight: FontWeight.bold) ),
                  ),
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _statusRemarkController,
                        focusNode: _statusRemarkFocusNode,
                        textInputAction: TextInputAction.next,
                        enabled: hasData? false:true,
                        keyboardType: TextInputType.text,

                      ),
                    ),
                  )
                ],
              ),*/
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total Item (${orderitems.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 5,top: 15,right: 5,bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex:7,
                      child: Row(
                        children: [
                          Expanded(
                            flex:5,
                            child: Container(
                              child: Text('Trade',style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: Text('Generic',style: TextStyle(color: Colors.white))
                            ),
                          ),

                      ],),
                    ),
                    Expanded(
                      flex:3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                                child: Text(
                                    'Unit',
                                    style: TextStyle(color: Colors.white)
                                )
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Qty',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Text(''),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              RequestItemList(orderitems,isStatusNew),

            ],
          ),
        ),
          floatingActionButton: isStatusNew? FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.add),
              onPressed: (){
                setState(() {
                  _showDialog();
                });
              }
          ):null,
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

