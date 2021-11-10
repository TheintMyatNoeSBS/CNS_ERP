import 'package:cns/database/model/item_detail_model.dart';
import 'package:flutter/material.dart';

class ItemLocation extends StatelessWidget {
  final List<ItemDetailModel> item_detail;
  ItemLocation(this.item_detail);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new LayoutBuilder(
        builder:(BuildContext context, BoxConstraints viewportConstraints){
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: item_detail.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${item_detail[index].Location} :'),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  );
                }
            ),
          );
    }),
    );
  }
}
