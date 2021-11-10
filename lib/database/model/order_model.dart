class OrderModel{
  final String orderId;
  final String requestNo;
  final String date;
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
  final String isUpload;

  OrderModel({
    required this.orderId, required this.requestNo,
    required this.date, required this.requestStatus,
    required this.mrType, required this.requestBy,
    required this.requestTo, required this.stationName,
    required this.remark, required this.statusRemark,
    required this.approvedBy, required this.superApproveBy,
    required this.modifyBy, required this.modifyOn,
    required this.createdBy, required this.createdOn,
    required this.isUpload
  });

  factory OrderModel.fromJSON(Map<String, dynamic> json) {

    List<OrderModel> genericList = [];

    return OrderModel(
      orderId: json['ItemUOMID']==null? "-": json['ItemUOMID'],
      requestNo: json['UomLabel']==null? "-": json['UomLabel'],
      date: json['Status']==null? "-": json['Status'],
      requestStatus: json['Active']==null? "-": json['Active'].toString(),
      mrType: json['CreatedBy']==null? "-": json['CreatedBy'],
      requestBy: json['CreatedOn']==null? "-": json['CreatedOn'],
      requestTo: json['ModifiedBy']==null? "": json['ModifiedBy'],
      stationName: json['ModifiedOn']==null? "": json['ModifiedOn'],
      remark: json['ModifiedOn']==null? "": json['ModifiedOn'],
      statusRemark: json['ModifiedOn']==null? "": json['ModifiedOn'],
      approvedBy: json['LastAction']==null? "-": json['LastAction'],
      superApproveBy: json['ShowSeq']==null? "-": json['ShowSeq'],
      modifyBy: json['ItemID']==null? "-": json['ItemID'],
      modifyOn: json['ItemID']==null? "-": json['ItemID'],
      createdBy: json['ItemID']==null? "-": json['ItemID'],
      createdOn: json['ItemID']==null? "-": json['ItemID'],
      isUpload: 'False',
    );
  }
}