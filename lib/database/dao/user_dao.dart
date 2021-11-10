import 'package:cns/database/entity/user_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao{
  @Query('select * from UserTable')
  Future<List<UserTable>> getAllUser();

  @Query('select * from UserTable where UserID =:userID')
  Future<List<UserTable>> getUserByUserId(String userID);

  @Query('select * from UserTable where UserCode =:userCode and Password =:password')
  Future<List<UserTable>> getUserByUserCodeAndPassword(String userCode,String password);

  @Query('select * from UserTable where UserCode =:userCode')
  Future<List<UserTable>> getUserByUserCode(String userCode);

  @Query('update UserTable set Password =:password where UserID =:userID')
  Future<void> updatePassword(String userID,String password);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addUser(UserTable user);

  @delete
  Future<void> deleteNote(UserTable user);

  @update
  Future<void>updateNote(UserTable user);

  @delete
  Future<void> deleteAllNotes(List<UserTable> users);
}