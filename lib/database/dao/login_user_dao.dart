import 'package:cns/database/entity/login_user_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class LoginUserDao{
  @Query('select * from LoginUserTable')
  Future<List<LoginUserTable>> getAllUser();

  @Query('select * from LoginUserTable where UserID =:userID')
  Future<List<LoginUserTable>> getUserByUserId(String userID);

  @Query('select * from LoginUserTable where UserCode =:userCode and Password =:password')
  Future<List<LoginUserTable>> getUserByUserCodeAndPassword(String userCode,String password);

  @Query('select * from LoginUserTable where UserCode =:userCode')
  Future<List<LoginUserTable>> getUserByUserCode(String userCode);

  @Query('update LoginUserTable set Password =:password where UserID =:userID')
  Future<void> updatePassword(String userID,String password);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addUser(LoginUserTable user);

  @delete
  Future<void> deleteNote(LoginUserTable user);

  @update
  Future<void>updateNote(LoginUserTable user);

  @delete
  Future<void> deleteAllNotes(List<LoginUserTable> users);
}