import 'package:cns/database/appdatabase.dart';
import 'package:cns/database/entity/generic_table.dart';
import 'package:cns/database/entity/item_table.dart';
import 'package:cns/database/entity/item_unit_table.dart';
import 'package:cns/database/entity/order_item_table.dart';
import 'package:cns/database/entity/order_table.dart';
import 'package:cns/database/entity/station_entity.dart';
import 'package:cns/database/model/order_item_model.dart';
import 'package:cns/database/model/request_item.dart';
import 'package:cns/util/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RequestItemList extends StatefulWidget {
  final List<OrderItemTable> orderItem;
  final isStatusNew;

  RequestItemList(this.orderItem, this.isStatusNew);

  @override
  State<RequestItemList> createState() => _RequestItemListState();
}

class _RequestItemListState extends State<RequestItemList> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  final _qtyController = TextEditingController();
  final _qtyFocusNode = FocusNode();
  final _itemRemarkController = TextEditingController();
  final _itemRemarkFocusNode = FocusNode();
  final TextEditingController _tradeController = TextEditingController();
  final TextEditingController _genericController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  late var _selectedTradeName = "";
  late var _selectedGenericName = "";
  late var _selectedUnit;
  late var _selectedTradeID = "";
  late var _selectedGenericID = "";
  late var _selectedUnitID = "";
  late var _selectedTradeIndex;
  late var _selectedGenericIndex;
  late var _selectedUnitIndex;

  List<String> genericList = [];
  List<String> tradeList = [];
  List<String> unitList = [];

  List<GenericTable> generic = [];
  List<ItemTable> trades = [];
  List<StationTable> stations = [];
  List<ItemUnitTable> itemUnit=[];
  List<ItemUnitTable> itemUnits=[];

  var _chosenValue;
  var orderID="";
  var orderItemID = "";
  var userID = "";
  var createdOn = "";

  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  @override
  void initState() {
    super.initState();
    getDataForSpinner();
  }

  void updateItem(OrderItemTable item){
    setState(() {
      print("PrintUpdate");
      _tradeController.text = item.itemName;
      _selectedTradeName = item.itemName;
      _selectedTradeID = item.itemId;
      _genericController.text = item.genericName;
      _selectedGenericName = item.genericName;
      _selectedGenericID = item.genericId;
      _selectedUnitID = item.unitId;
      _qtyController.text = item.qty;
      _itemRemarkController.text = item.remark;
      orderID = item.orderId;
      orderItemID = item.orderItemId;
      userID = item.createdBy;
      createdOn = item.createdOn;
      _selectedUnit = item.unitName;
      _unitController.text = item.unitName;

      if(_tradeController.text.isEmpty){
        print("SelectedUnit"+_selectedUnit);
        getUnitByGeneric(_selectedGenericID, _selectedUnit);
        _qtyFocusNode.requestFocus();

      }
      else{
        getUnit(_selectedTradeID,item.unitName);
        _qtyFocusNode.requestFocus();

      }

    });
  }

  void getOrderItemList(String orderID) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();

    List<OrderItemTable> orderItemInfo = await database.orderItemDao.getByOrderId(orderID);

    if(orderItemInfo.length>0){
      widget.orderItem.clear();
      setState(() {
        print("orderItemInfo"+orderItemInfo.length.toString());
        for(int i=0;i<orderItemInfo.length;i++){
          widget.orderItem.add(
              orderItemInfo[i]
          );
        }
      });
    }
  }

  Future<void> getDataForSpinner() async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();

    generic = await database.genericDao.getAllGeneric();

    trades = await database.itemDao.getAllItem();

    stations = await database.stationDao.getAllStation();

    genericList.clear();
    tradeList.clear();

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
    });

  }

  void addOrderItem(OrderItemTable orderItems) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();

    database.orderItemDao.addOrderItem(orderItems);

    /*setState(() {
      Navigator.pop(context);
      getOrderItemList(orderID);
    });*/
  }

  void updateRequestItemApi(String tradeName,String genericName,String tradeID,String genericID){


    addOrderItem(
        OrderItemTable(orderItemID, orderID,
        _selectedTradeID, _selectedTradeName, _selectedGenericID,
        _selectedGenericName, _selectedUnitID,
        _selectedUnit, _qtyController.text,
        _itemRemarkController.text, userID,
        createdOn, userID,
        dateFormat.format(DateTime.now()))
    );

    Provider.of<RequestItemProvider>(context,listen: false)
        .callUpdateRequestItemApi("1B2M2Y8AsgTpgAmY7PhCfg==",
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
            qty: _qtyController.text,
            remark: _itemRemarkController.text,
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
  }

  void showConfirmDialog(OrderItemTable item){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          insetPadding: EdgeInsets.only(left: 10,right: 10),
          title: Text('Delete'),
          content: Text('Are you sure want to delete?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No',style: TextStyle(color: Colors.blue),),
            ),
            FlatButton(
              onPressed: () {
                setState(() {

                  Common.instance.check().then((intenet) {
                    if (intenet != null && intenet) {
                      callDeleteApi(item);
                      Navigator.of(context).pop(false);
                    }
                    else{
                      Fluttertoast.showToast(
                          msg: "Connection Fail!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1);
                      Navigator.of(context).pop(false);
                    }
                  });
                });
              },
              child: Text('Yes',style: TextStyle(color: Colors.blue)),
            ),
          ],
        )
    );
  }

  void callDeleteApi(OrderItemTable item){
    Provider.of<RequestItemProvider>(context,listen: false)
        .callDeleteRequestItemApi("1B2M2Y8AsgTpgAmY7PhCfg==",
        RequestItem(
            MRItemID: item.orderItemId,
            MRID: item.orderId,
            ItemID: item.itemId,
            GenericID: item.genericId,
            RequestQty: item.qty,
            IssueQty: "",
            RemainQty: "",
            TotalRemainQty: "",
            Remark: item.remark, UnitID: item.unitId,
            LocationID: "",
            CreatedBy: userID,
            CreatedOn: createdOn,
            ModifiedBy: userID,
            ModifiedOn: dateFormat.format(DateTime.now())),OrderItemModel(
            orderItemId: item.orderItemId,
            orderId: item.orderId,
            itemId: item.itemId,
            itemName: item.itemName,
            genericId: item.genericId,
            genericName: item.genericName,
            unitId: item.unitId,
            unitName: item.unitName,
            qty: item.qty, remark: item.remark,
            modifyBy: userID,
            modifyOn: dateFormat.format(DateTime.now()),
            createdBy: userID,
            createdOn: createdOn
        )
    ).then((_){
      setState(() {
        widget.orderItem.remove(item);
        deleteItem(item.orderItemId);
        getOrderItemList(orderID);
      });
    });
  }

  void deleteItem(String itemID) async{
    print("CallDownload");
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    database.orderItemDao.deleteItem(itemID);
  }

  //find and create list of matched strings
  List<String> _getTrades(String query) {
    List<String> matches = [];

    matches.addAll(tradeList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void getUnit(String itemID, String unitName) async {

    print("itemID"+itemID);

    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    var value;
    itemUnit = await database.itemUnitDao.getById(itemID);

    print(itemUnit.length);

    unitList.clear();
    _chosenValue = value;


    for(int i=0;i<itemUnit.length;i++){
      setState(() {
        unitList.add(itemUnit[i].UomLabel);
        _chosenValue = unitList[0];
        print(unitList.length);
      });
    }

    setState(() {
      print('Unit Name'+_selectedUnit);

      if(unitName!=null && unitName!=""){
        _chosenValue = unitName;
      }
      else{
        _selectedUnit = itemUnit[0].UomLabel;
        _selectedUnitID = itemUnit[0].ItemUOMID;
        _qtyFocusNode.requestFocus();
      }


    });

  }

  void getUnitByGeneric(String genericID, String unitName) async{
    print('Unit Name'+unitName);
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    var value;
    List<ItemTable> itemList = await database.itemDao.getByGenericId(genericID);
    unitList.clear();
    itemUnits.clear();
    _chosenValue = value;

    if(itemList.length>0){
      for(int j=0;j<itemList.length;j++){
        itemUnit = await database.itemUnitDao.getById(itemList[j].ItemID);
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

            _chosenValue = unitList[0];
            print(unitList.length);
            print(itemUnits.length);
          });
        }
      }
      setState(() {

        if(unitName!=null && unitName!=""){
          _chosenValue = unitName;
          _qtyFocusNode.requestFocus();
        }
        else{
          _selectedUnit = itemUnits[0].UomLabel;
          _selectedUnitID = itemUnits[0].ItemUOMID;
          _chosenValue = unitList[0];

          print("SelectedUnitID"+_selectedUnitID);
          print("SelectedUnit :"+_chosenValue);
          _qtyFocusNode.requestFocus();
        }

      });
    }
  }


  //find and create list of matched strings
  List<String> _getGeneric(String query) {
    List<String> matches = [];

    matches.addAll(genericList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void _showUpdateItemDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
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
                                    getUnitByGeneric(_selectedGenericID,"");
                                    _qtyFocusNode.requestFocus();
                                  }
                                  else{
                                    setState(() {
                                      getUnit("","");
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

                                  getUnit(items.ItemID,"");
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
                                    setState(() {
                                      getUnitByGeneric("", "");
                                    });
                                  }

                                },
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

                                  if(_tradeController.text.isEmpty){
                                    getUnitByGeneric(_selectedGenericID,"");
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
//                                  _selectedUnitIndex = unitList.indexOf(_selectedUnit);
//                                  ItemUnitTable unit = itemUnit[_selectedUnitIndex];
//                                  if(unit!=null){
//                                    _selectedUnitID = unit.ItemUOMID;
//                                  }
                                  print("VAlue"+_chosenValue.toString());
                                });
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
                      Common.instance.check().then((intenet) {
                        if (intenet != null && intenet) {
                          updateRequestItemApi(_selectedTradeName,_selectedGenericName,_selectedTradeID,_selectedGenericID);
                          Navigator.of(context).pop(false);
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




//                  setState(() {
//                    FocusScopeNode currentFocus = FocusScope.of(context);
//                    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
//                      currentFocus.focusedChild!.unfocus();
//                    }
//                  });
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
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 3);
        },
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.orderItem.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              if(widget.isStatusNew){
                updateItem(widget.orderItem[index]);
                setState(() {
                  _showUpdateItemDialog();
                });
              }


            },
            child: Card(
              margin: EdgeInsets.zero,
              child: Container(
                padding: widget.isStatusNew?EdgeInsets.only(left: 5,right: 5,):EdgeInsets.only(left: 5,top: 15,right: 5,bottom: 15),
                width: MediaQuery.of(context).size.width,
                color: Color(0xffe2eaf1),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text(
                                widget.orderItem[index].itemName,
                                style: TextStyle(
                                    color: Colors.black,
                                  fontSize: 13
                                )
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                              child: Text(
                                  widget.orderItem[index].genericName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13
                                  )
                              )
                          ),
                        ),

                      ],
                    ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  widget.orderItem[index].unitName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13
                                  )
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  '${oCcy.format(double.parse(widget.orderItem[index].qty))}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13
                                  )
                              ),
                            ),
                          ),
                          Expanded(
                            child: widget.isStatusNew?Container(
                              margin: EdgeInsets.only(right: 5),
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    setState(() {
                                      if(widget.isStatusNew){
                                        showConfirmDialog(widget.orderItem[index]);
                                      }
                                      else{

                                      }

//                                  widget.orderItem.remove(widget.orderItem[index]);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 20,
                                  )
                              ),
                            ):Container(),
                          ),

                      ],
                    ),)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
