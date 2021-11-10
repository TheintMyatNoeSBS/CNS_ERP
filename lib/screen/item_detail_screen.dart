import 'dart:io';

import 'package:cns/database/model/item_list_model.dart';
import 'package:cns/widget/item_detail.dart';
import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  static final String routeName = '/item_detail_screen';
  final ItemListModel _itemDetailModel;

  ItemDetailScreen(this._itemDetailModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS? AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(_itemDetailModel.RefNo),
      ) :AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_itemDetailModel.RefNo),
      ),
      body: new LayoutBuilder(builder: (BuildContext context, BoxConstraints viewportConstraints){
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15),
            child: ItemDetail(_itemDetailModel),
          ),
        );
      }),
    );
  }
}
