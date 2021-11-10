import 'package:cns/database/model/item_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemBalance extends StatelessWidget {
  final List<ItemDetailModel> item_detail;
  final oCcy = new NumberFormat("#,##0", "en_US");

  ItemBalance(this.item_detail);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: item_detail.length,
          itemBuilder: (context, index) {
            return Container(
              child: item_detail[index].Balance=="0"? Container(): Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('${item_detail[index].Location} :'),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                  '${oCcy.format(double.parse(item_detail[index].Balance))}'
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            );
          }
      ),
    );

  }
}
