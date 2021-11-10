import 'package:cns/database/model/item_list_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/screen/item_detail_screen.dart';
import 'package:cns/widget/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemList extends StatelessWidget {
  final List<ItemListModel> items;
  final oCcy = new NumberFormat("#,##0", "en_US");

  ItemList(this.items);

  @override
  Widget build(BuildContext context) {
    return items.length==1? ItemDetail(items[0]):
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(items[index]),
                      ));
                },
                child: Card(
                  margin: EdgeInsets.only(left: 15,right: 15,bottom: 10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('No :'),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text('${items[index].RefNo}')),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Trade :'),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text('${items[index].ItemName}')),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Generic :'),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                        '${items[index].GenericName}'
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
                              flex: 3,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Total Qty :',),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                        '${oCcy.format(double.parse(items[index].TotalQty))}')
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
  }
}
