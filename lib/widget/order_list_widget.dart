import 'package:cns/database/entity/order_table.dart';
import 'package:cns/database/model/order_model.dart';
import 'package:cns/screen/order_detail_screen.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final List<OrderTable> order;

  OrderList(this.order);
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
        itemCount: order.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Common.instance.setStringValue(Constants.order_id, order[index].orderId);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetailScreen()
                  ),
                  ModalRoute.withName(OrderDetailScreen.routeName));
            },
            child: Card(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Container(
                padding: EdgeInsets.only(left: 5,top: 15,right: 5,bottom: 15),
                width: MediaQuery.of(context).size.width,
                color: order[index].requestStatus=='Rejected'? Colors.red:Color(0xffe2eaf1),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                            order[index].requestNo,
                            style: TextStyle(
                                color: order[index].requestStatus=='Rejected'? Colors.white:Colors.black,
                                fontSize: 14),

                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(order[index].mrType,
                            style: TextStyle(
                                color: order[index].requestStatus=='Rejected'? Colors.white:Colors.black,
                            fontSize: 14
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                            order[index].requestStatus,
                            style: TextStyle(
                                color: order[index].requestStatus=='Rejected'? Colors.white:Colors.black,
                                fontSize: 14
                            )
                        ),
                      ),
                    ),
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
