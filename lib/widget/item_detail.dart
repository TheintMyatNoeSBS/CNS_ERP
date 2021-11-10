import 'package:cns/database/model/item_list_model.dart';
import 'package:cns/widget/item_balance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import 'item_location.dart';

class ItemDetail extends StatelessWidget {
  final ItemListModel _itemListModel;

  ItemDetail(this._itemListModel);
  final oCcy = new NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    precacheImage(new AssetImage("assets/image/cns_logo.jpg"),context);
    return Container(
      child: new LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints){
        return SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
            elevation: 3,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  child: Image.asset(
                    'assets/image/cns_logo.jpg',
                    width: 100,
                    height: 100,
                  ),
                ),
                Center(
                    child: _itemListModel.BarCode==""? Container(): Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width/1.4,
                      /*child: BarCodeImage(
                        params: Code128BarCodeParams(
                          _itemListModel.BarCode==""? '1234567890': _itemListModel.BarCode,
                          barHeight: 90.0,
                          lineWidth: 1,// height for the entire widget (default: 100.0)
                          withText: true,                // Render with text label or not (default: false)
                        ),
                        onError: (error) {               // Error handler
                          print('error = $error');
                        },
                      ),*/
                      child:SfBarcodeGenerator(
                        value:_itemListModel.BarCode==""? '1234567890': _itemListModel.BarCode,
                        showValue: true,
                      )
                    )
                ),
                _itemListModel.BarCode==""? Container():SizedBox(height: 20,),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('No :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${_itemListModel.RefNo}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Trade Name :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${_itemListModel.ItemName}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Generic Name :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${_itemListModel.GenericName}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Manufacture :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${_itemListModel.Manufacture}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Country :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${_itemListModel.Country}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      ItemBalance(_itemListModel.Item_Detail),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('Total Qty :'),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                      '${oCcy.format(double.parse(_itemListModel.TotalQty))}'
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        );
      }),
    );
  }
}
