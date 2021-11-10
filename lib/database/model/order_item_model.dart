class OrderItemModel{
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

  OrderItemModel({
    required this.orderItemId, required this.orderId,
    required this.itemId, required this.itemName,
    required this.genericId, required this.genericName,
    required this.unitId, required this.unitName, required this.qty,
    required this.remark, required this.modifyBy,
    required this.modifyOn, required this.createdBy,
    required this.createdOn
  });
}