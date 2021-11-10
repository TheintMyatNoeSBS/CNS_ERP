import 'package:floor/floor.dart';

@entity
class OrderItemTable{
  @primaryKey
  final String orderItemId;
  final String orderId;
  final String itemId;
  final String itemName;
  final String genericId;
  final String genericName;
  final String unitId;
  final String unitName;
  final String qty;
  final String remark;
  final String modifyBy;
  final String modifyOn;
  final String createdBy;
  final String createdOn;

  OrderItemTable(this.orderItemId, this.orderId, this.itemId, this.itemName,
      this.genericId, this.genericName, this.unitId, this.unitName, this.qty,
      this.remark, this.modifyBy, this.modifyOn, this.createdBy,
      this.createdOn);

}