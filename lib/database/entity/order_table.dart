import 'package:floor/floor.dart';

@entity
class OrderTable{
  @primaryKey
  final String orderId;
  final String requestNo;
  final String date;
  final String orderDate;
  final String requestStatus;
  final String mrType;
  final String requestBy;
  final String requestTo;
  final String stationName;
  final String remark;
  final String statusRemark;
  final String approvedBy;
  final String superApproveBy;
  final String modifyBy;
  final String modifyOn;
  final String createdBy;
  final String createdOn;
  final String station;
  final String isUpload;

  OrderTable(this.orderId, this.requestNo, this.date, this.requestStatus,
      this.mrType, this.requestBy, this.requestTo, this.stationName,
      this.remark, this.statusRemark, this.approvedBy, this.superApproveBy,
      this.modifyBy, this.modifyOn, this.createdBy, this.createdOn,
      this.isUpload,this.orderDate,this.station);
}