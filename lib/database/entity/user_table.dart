import 'package:floor/floor.dart';

@entity
class UserTable{
  @primaryKey
  final String UserID;
  final String UserCode;
  final String UserName;
  final String LastLogin;
  final String Password;
  final String Note;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;
  final String EnableTouch;
  final String CreatedByCode;
  final String CreatedByName;
  final String ModifedByCode;
  final String ModifiedByName;
  final String DepartmentID;
  final String LandingPage;
  final String AllowArrival;
  final String AllowBlackList;
  final String AllowDeparture;
  final String AllowInterpol;
  final String AllowCenter;
  final String DepartmentCode;
  final String DepartmentName;
  final String RoleID;
  final String RoleName;
  final String Email;
  final String PositionName;
  final String PositionID;
  final String StationID;

  UserTable(this.UserID, this.UserCode, this.UserName, this.LastLogin,
      this.Password, this.Note, this.Active, this.CreatedBy, this.CreatedOn,
      this.ModifiedBy, this.ModifiedOn, this.LastAction, this.EnableTouch,
      this.CreatedByCode, this.CreatedByName, this.ModifedByCode,
      this.ModifiedByName, this.DepartmentID, this.LandingPage,
      this.AllowArrival, this.AllowBlackList, this.AllowDeparture,
      this.AllowInterpol, this.AllowCenter, this.DepartmentCode,
      this.DepartmentName, this.RoleID, this.RoleName, this.Email,
      this.PositionName, this.PositionID,this.StationID);
}