// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appdatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  GenericDao? _genericDaoInstance;

  ItemDao? _itemDaoInstance;

  ItemUnitDao? _itemUnitDaoInstance;

  OrderItemDao? _orderItemDaoInstance;

  OrderDao? _orderDaoInstance;

  StationDao? _stationDaoInstance;

  ProgramDao? _programDaoInstance;

  LoginUserDao? _loginUserDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 5,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserTable` (`UserID` TEXT NOT NULL, `UserCode` TEXT NOT NULL, `UserName` TEXT NOT NULL, `LastLogin` TEXT NOT NULL, `Password` TEXT NOT NULL, `Note` TEXT NOT NULL, `Active` TEXT NOT NULL, `CreatedBy` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedBy` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `LastAction` TEXT NOT NULL, `EnableTouch` TEXT NOT NULL, `CreatedByCode` TEXT NOT NULL, `CreatedByName` TEXT NOT NULL, `ModifedByCode` TEXT NOT NULL, `ModifiedByName` TEXT NOT NULL, `DepartmentID` TEXT NOT NULL, `LandingPage` TEXT NOT NULL, `AllowArrival` TEXT NOT NULL, `AllowBlackList` TEXT NOT NULL, `AllowDeparture` TEXT NOT NULL, `AllowInterpol` TEXT NOT NULL, `AllowCenter` TEXT NOT NULL, `DepartmentCode` TEXT NOT NULL, `DepartmentName` TEXT NOT NULL, `RoleID` TEXT NOT NULL, `RoleName` TEXT NOT NULL, `Email` TEXT NOT NULL, `PositionName` TEXT NOT NULL, `PositionID` TEXT NOT NULL, `StationID` TEXT NOT NULL, PRIMARY KEY (`UserID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GenericTable` (`GenericID` TEXT NOT NULL, `GenericName` TEXT NOT NULL, `Description` TEXT NOT NULL, `Active` TEXT NOT NULL, `CreatedBy` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedBy` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `LastAction` TEXT NOT NULL, PRIMARY KEY (`GenericID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemTable` (`ItemID` TEXT NOT NULL, `ItemNo` TEXT NOT NULL, `ItemName` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `GenericName` TEXT NOT NULL, `GenericID` TEXT NOT NULL, PRIMARY KEY (`ItemID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemUnitTable` (`ItemUOMID` TEXT NOT NULL, `UomLabel` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `ItemID` TEXT NOT NULL, `Seq` TEXT NOT NULL, PRIMARY KEY (`ItemUOMID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OrderTable` (`orderId` TEXT NOT NULL, `requestNo` TEXT NOT NULL, `date` TEXT NOT NULL, `orderDate` TEXT NOT NULL, `requestStatus` TEXT NOT NULL, `mrType` TEXT NOT NULL, `requestBy` TEXT NOT NULL, `requestTo` TEXT NOT NULL, `stationName` TEXT NOT NULL, `remark` TEXT NOT NULL, `statusRemark` TEXT NOT NULL, `approvedBy` TEXT NOT NULL, `superApproveBy` TEXT NOT NULL, `modifyBy` TEXT NOT NULL, `modifyOn` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `createdOn` TEXT NOT NULL, `station` TEXT NOT NULL, `isUpload` TEXT NOT NULL, PRIMARY KEY (`orderId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `OrderItemTable` (`orderItemId` TEXT NOT NULL, `orderId` TEXT NOT NULL, `itemId` TEXT NOT NULL, `itemName` TEXT NOT NULL, `genericId` TEXT NOT NULL, `genericName` TEXT NOT NULL, `unitId` TEXT NOT NULL, `unitName` TEXT NOT NULL, `qty` TEXT NOT NULL, `remark` TEXT NOT NULL, `modifyBy` TEXT NOT NULL, `modifyOn` TEXT NOT NULL, `createdBy` TEXT NOT NULL, `createdOn` TEXT NOT NULL, PRIMARY KEY (`orderItemId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `StationTable` (`StationID` TEXT NOT NULL, `StationName` TEXT NOT NULL, `Address` TEXT NOT NULL, `Active` TEXT NOT NULL, `CreatedBy` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedBy` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `LastAction` TEXT NOT NULL, `StationCode` TEXT NOT NULL, `Remark` TEXT NOT NULL, `CreatedByCode` TEXT NOT NULL, `ModifiedByCode` TEXT NOT NULL, PRIMARY KEY (`StationID`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProgramTable` (`SysProgramId` TEXT NOT NULL, `ProgramCode` TEXT NOT NULL, `ProgramName` TEXT NOT NULL, `SystemgroupID` TEXT NOT NULL, `userID` TEXT NOT NULL, PRIMARY KEY (`SysProgramId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LoginUserTable` (`UserID` TEXT NOT NULL, `UserCode` TEXT NOT NULL, `UserName` TEXT NOT NULL, `LastLogin` TEXT NOT NULL, `Password` TEXT NOT NULL, `Note` TEXT NOT NULL, `Active` TEXT NOT NULL, `CreatedBy` TEXT NOT NULL, `CreatedOn` TEXT NOT NULL, `ModifiedBy` TEXT NOT NULL, `ModifiedOn` TEXT NOT NULL, `LastAction` TEXT NOT NULL, `EnableTouch` TEXT NOT NULL, `CreatedByCode` TEXT NOT NULL, `CreatedByName` TEXT NOT NULL, `ModifedByCode` TEXT NOT NULL, `ModifiedByName` TEXT NOT NULL, `DepartmentID` TEXT NOT NULL, `LandingPage` TEXT NOT NULL, `AllowArrival` TEXT NOT NULL, `AllowBlackList` TEXT NOT NULL, `AllowDeparture` TEXT NOT NULL, `AllowInterpol` TEXT NOT NULL, `AllowCenter` TEXT NOT NULL, `DepartmentCode` TEXT NOT NULL, `DepartmentName` TEXT NOT NULL, `RoleID` TEXT NOT NULL, `RoleName` TEXT NOT NULL, `Email` TEXT NOT NULL, `PositionName` TEXT NOT NULL, `PositionID` TEXT NOT NULL, `StationID` TEXT NOT NULL, PRIMARY KEY (`UserID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  GenericDao get genericDao {
    return _genericDaoInstance ??= _$GenericDao(database, changeListener);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  ItemUnitDao get itemUnitDao {
    return _itemUnitDaoInstance ??= _$ItemUnitDao(database, changeListener);
  }

  @override
  OrderItemDao get orderItemDao {
    return _orderItemDaoInstance ??= _$OrderItemDao(database, changeListener);
  }

  @override
  OrderDao get orderDao {
    return _orderDaoInstance ??= _$OrderDao(database, changeListener);
  }

  @override
  StationDao get stationDao {
    return _stationDaoInstance ??= _$StationDao(database, changeListener);
  }

  @override
  ProgramDao get programDao {
    return _programDaoInstance ??= _$ProgramDao(database, changeListener);
  }

  @override
  LoginUserDao get loginUserDao {
    return _loginUserDaoInstance ??= _$LoginUserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userTableInsertionAdapter = InsertionAdapter(
            database,
            'UserTable',
            (UserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                }),
        _userTableUpdateAdapter = UpdateAdapter(
            database,
            'UserTable',
            ['UserID'],
            (UserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                }),
        _userTableDeletionAdapter = DeletionAdapter(
            database,
            'UserTable',
            ['UserID'],
            (UserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserTable> _userTableInsertionAdapter;

  final UpdateAdapter<UserTable> _userTableUpdateAdapter;

  final DeletionAdapter<UserTable> _userTableDeletionAdapter;

  @override
  Future<List<UserTable>> getAllUser() async {
    return _queryAdapter.queryList('select * from UserTable',
        mapper: (Map<String, Object?> row) => UserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String));
  }

  @override
  Future<List<UserTable>> getUserByUserId(String userID) async {
    return _queryAdapter.queryList('select * from UserTable where UserID =?1',
        mapper: (Map<String, Object?> row) => UserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userID]);
  }

  @override
  Future<List<UserTable>> getUserByUserCodeAndPassword(
      String userCode, String password) async {
    return _queryAdapter.queryList(
        'select * from UserTable where UserCode =?1 and Password =?2',
        mapper: (Map<String, Object?> row) => UserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userCode, password]);
  }

  @override
  Future<List<UserTable>> getUserByUserCode(String userCode) async {
    return _queryAdapter.queryList('select * from UserTable where UserCode =?1',
        mapper: (Map<String, Object?> row) => UserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userCode]);
  }

  @override
  Future<void> updatePassword(String userID, String password) async {
    await _queryAdapter.queryNoReturn(
        'update UserTable set Password =?2 where UserID =?1',
        arguments: [userID, password]);
  }

  @override
  Future<void> addUser(UserTable user) async {
    await _userTableInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateNote(UserTable user) async {
    await _userTableUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNote(UserTable user) async {
    await _userTableDeletionAdapter.delete(user);
  }

  @override
  Future<void> deleteAllNotes(List<UserTable> users) async {
    await _userTableDeletionAdapter.deleteList(users);
  }
}

class _$GenericDao extends GenericDao {
  _$GenericDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _genericTableInsertionAdapter = InsertionAdapter(
            database,
            'GenericTable',
            (GenericTable item) => <String, Object?>{
                  'GenericID': item.GenericID,
                  'GenericName': item.GenericName,
                  'Description': item.Description,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction
                }),
        _genericTableUpdateAdapter = UpdateAdapter(
            database,
            'GenericTable',
            ['GenericID'],
            (GenericTable item) => <String, Object?>{
                  'GenericID': item.GenericID,
                  'GenericName': item.GenericName,
                  'Description': item.Description,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction
                }),
        _genericTableDeletionAdapter = DeletionAdapter(
            database,
            'GenericTable',
            ['GenericID'],
            (GenericTable item) => <String, Object?>{
                  'GenericID': item.GenericID,
                  'GenericName': item.GenericName,
                  'Description': item.Description,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GenericTable> _genericTableInsertionAdapter;

  final UpdateAdapter<GenericTable> _genericTableUpdateAdapter;

  final DeletionAdapter<GenericTable> _genericTableDeletionAdapter;

  @override
  Future<List<GenericTable>> getAllGeneric() async {
    return _queryAdapter.queryList(
        'select * from GenericTable order by ModifiedOn desc',
        mapper: (Map<String, Object?> row) => GenericTable(
            row['GenericID'] as String,
            row['GenericName'] as String,
            row['Description'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String));
  }

  @override
  Future<List<GenericTable>> getById(String genericID) async {
    return _queryAdapter.queryList(
        'select * from GenericTable where GenericID =?1',
        mapper: (Map<String, Object?> row) => GenericTable(
            row['GenericID'] as String,
            row['GenericName'] as String,
            row['Description'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String),
        arguments: [genericID]);
  }

  @override
  Future<void> addGeneric(GenericTable generic) async {
    await _genericTableInsertionAdapter.insert(
        generic, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateGeneric(GenericTable generic) async {
    await _genericTableUpdateAdapter.update(generic, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGeneric(GenericTable generic) async {
    await _genericTableDeletionAdapter.delete(generic);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _itemTableInsertionAdapter = InsertionAdapter(
            database,
            'ItemTable',
            (ItemTable item) => <String, Object?>{
                  'ItemID': item.ItemID,
                  'ItemNo': item.ItemNo,
                  'ItemName': item.ItemName,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'GenericName': item.GenericName,
                  'GenericID': item.GenericID
                }),
        _itemTableUpdateAdapter = UpdateAdapter(
            database,
            'ItemTable',
            ['ItemID'],
            (ItemTable item) => <String, Object?>{
                  'ItemID': item.ItemID,
                  'ItemNo': item.ItemNo,
                  'ItemName': item.ItemName,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'GenericName': item.GenericName,
                  'GenericID': item.GenericID
                }),
        _itemTableDeletionAdapter = DeletionAdapter(
            database,
            'ItemTable',
            ['ItemID'],
            (ItemTable item) => <String, Object?>{
                  'ItemID': item.ItemID,
                  'ItemNo': item.ItemNo,
                  'ItemName': item.ItemName,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'GenericName': item.GenericName,
                  'GenericID': item.GenericID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ItemTable> _itemTableInsertionAdapter;

  final UpdateAdapter<ItemTable> _itemTableUpdateAdapter;

  final DeletionAdapter<ItemTable> _itemTableDeletionAdapter;

  @override
  Future<List<ItemTable>> getAllItem() async {
    return _queryAdapter.queryList(
        'select * from ItemTable order by ModifiedOn desc',
        mapper: (Map<String, Object?> row) => ItemTable(
            row['ItemID'] as String,
            row['ItemNo'] as String,
            row['ItemName'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['GenericName'] as String,
            row['GenericID'] as String));
  }

  @override
  Future<List<ItemTable>> getById(String itemID) async {
    return _queryAdapter.queryList('select * from ItemTable where ItemID =?1',
        mapper: (Map<String, Object?> row) => ItemTable(
            row['ItemID'] as String,
            row['ItemNo'] as String,
            row['ItemName'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['GenericName'] as String,
            row['GenericID'] as String),
        arguments: [itemID]);
  }

  @override
  Future<List<ItemTable>> getByGenericId(String genericID) async {
    return _queryAdapter.queryList(
        'select * from ItemTable where GenericID =?1',
        mapper: (Map<String, Object?> row) => ItemTable(
            row['ItemID'] as String,
            row['ItemNo'] as String,
            row['ItemName'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['GenericName'] as String,
            row['GenericID'] as String),
        arguments: [genericID]);
  }

  @override
  Future<void> addItem(ItemTable items) async {
    await _itemTableInsertionAdapter.insert(items, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItem(ItemTable items) async {
    await _itemTableUpdateAdapter.update(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(ItemTable items) async {
    await _itemTableDeletionAdapter.delete(items);
  }
}

class _$ItemUnitDao extends ItemUnitDao {
  _$ItemUnitDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _itemUnitTableInsertionAdapter = InsertionAdapter(
            database,
            'ItemUnitTable',
            (ItemUnitTable item) => <String, Object?>{
                  'ItemUOMID': item.ItemUOMID,
                  'UomLabel': item.UomLabel,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'ItemID': item.ItemID,
                  'Seq': item.Seq
                }),
        _itemUnitTableUpdateAdapter = UpdateAdapter(
            database,
            'ItemUnitTable',
            ['ItemUOMID'],
            (ItemUnitTable item) => <String, Object?>{
                  'ItemUOMID': item.ItemUOMID,
                  'UomLabel': item.UomLabel,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'ItemID': item.ItemID,
                  'Seq': item.Seq
                }),
        _itemUnitTableDeletionAdapter = DeletionAdapter(
            database,
            'ItemUnitTable',
            ['ItemUOMID'],
            (ItemUnitTable item) => <String, Object?>{
                  'ItemUOMID': item.ItemUOMID,
                  'UomLabel': item.UomLabel,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedOn': item.ModifiedOn,
                  'ItemID': item.ItemID,
                  'Seq': item.Seq
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ItemUnitTable> _itemUnitTableInsertionAdapter;

  final UpdateAdapter<ItemUnitTable> _itemUnitTableUpdateAdapter;

  final DeletionAdapter<ItemUnitTable> _itemUnitTableDeletionAdapter;

  @override
  Future<List<ItemUnitTable>> getAllItemUnit() async {
    return _queryAdapter.queryList(
        'select * from ItemUnitTable order by ModifiedOn desc',
        mapper: (Map<String, Object?> row) => ItemUnitTable(
            row['ItemUOMID'] as String,
            row['UomLabel'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['ItemID'] as String,
            row['Seq'] as String));
  }

  @override
  Future<List<ItemUnitTable>> getById(String itemID) async {
    return _queryAdapter.queryList(
        'select * from ItemUnitTable where ItemID =?1',
        mapper: (Map<String, Object?> row) => ItemUnitTable(
            row['ItemUOMID'] as String,
            row['UomLabel'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['ItemID'] as String,
            row['Seq'] as String),
        arguments: [itemID]);
  }

  @override
  Future<List<ItemUnitTable>> getByUOMId(String uomID) async {
    return _queryAdapter.queryList(
        'select * from ItemUnitTable where ItemUOMID =?1',
        mapper: (Map<String, Object?> row) => ItemUnitTable(
            row['ItemUOMID'] as String,
            row['UomLabel'] as String,
            row['CreatedOn'] as String,
            row['ModifiedOn'] as String,
            row['ItemID'] as String,
            row['Seq'] as String),
        arguments: [uomID]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('delete from ItemUnitTable');
  }

  @override
  Future<void> addItemUnit(ItemUnitTable items) async {
    await _itemUnitTableInsertionAdapter.insert(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateItemUnit(ItemUnitTable items) async {
    await _itemUnitTableUpdateAdapter.update(items, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItemUnit(ItemUnitTable items) async {
    await _itemUnitTableDeletionAdapter.delete(items);
  }
}

class _$OrderItemDao extends OrderItemDao {
  _$OrderItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _orderItemTableInsertionAdapter = InsertionAdapter(
            database,
            'OrderItemTable',
            (OrderItemTable item) => <String, Object?>{
                  'orderItemId': item.orderItemId,
                  'orderId': item.orderId,
                  'itemId': item.itemId,
                  'itemName': item.itemName,
                  'genericId': item.genericId,
                  'genericName': item.genericName,
                  'unitId': item.unitId,
                  'unitName': item.unitName,
                  'qty': item.qty,
                  'remark': item.remark,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn
                }),
        _orderItemTableUpdateAdapter = UpdateAdapter(
            database,
            'OrderItemTable',
            ['orderItemId'],
            (OrderItemTable item) => <String, Object?>{
                  'orderItemId': item.orderItemId,
                  'orderId': item.orderId,
                  'itemId': item.itemId,
                  'itemName': item.itemName,
                  'genericId': item.genericId,
                  'genericName': item.genericName,
                  'unitId': item.unitId,
                  'unitName': item.unitName,
                  'qty': item.qty,
                  'remark': item.remark,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn
                }),
        _orderItemTableDeletionAdapter = DeletionAdapter(
            database,
            'OrderItemTable',
            ['orderItemId'],
            (OrderItemTable item) => <String, Object?>{
                  'orderItemId': item.orderItemId,
                  'orderId': item.orderId,
                  'itemId': item.itemId,
                  'itemName': item.itemName,
                  'genericId': item.genericId,
                  'genericName': item.genericName,
                  'unitId': item.unitId,
                  'unitName': item.unitName,
                  'qty': item.qty,
                  'remark': item.remark,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderItemTable> _orderItemTableInsertionAdapter;

  final UpdateAdapter<OrderItemTable> _orderItemTableUpdateAdapter;

  final DeletionAdapter<OrderItemTable> _orderItemTableDeletionAdapter;

  @override
  Future<List<OrderItemTable>> getAllOrderItem() async {
    return _queryAdapter.queryList('select * from OrderItemTable',
        mapper: (Map<String, Object?> row) => OrderItemTable(
            row['orderItemId'] as String,
            row['orderId'] as String,
            row['itemId'] as String,
            row['itemName'] as String,
            row['genericId'] as String,
            row['genericName'] as String,
            row['unitId'] as String,
            row['unitName'] as String,
            row['qty'] as String,
            row['remark'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String));
  }

  @override
  Future<List<OrderItemTable>> getById(String orderItemId) async {
    return _queryAdapter.queryList(
        'select * from OrderItemTable where orderItemId =?1',
        mapper: (Map<String, Object?> row) => OrderItemTable(
            row['orderItemId'] as String,
            row['orderId'] as String,
            row['itemId'] as String,
            row['itemName'] as String,
            row['genericId'] as String,
            row['genericName'] as String,
            row['unitId'] as String,
            row['unitName'] as String,
            row['qty'] as String,
            row['remark'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String),
        arguments: [orderItemId]);
  }

  @override
  Future<List<OrderItemTable>> getByOrderId(String orderId) async {
    return _queryAdapter.queryList(
        'select * from OrderItemTable where orderId =?1',
        mapper: (Map<String, Object?> row) => OrderItemTable(
            row['orderItemId'] as String,
            row['orderId'] as String,
            row['itemId'] as String,
            row['itemName'] as String,
            row['genericId'] as String,
            row['genericName'] as String,
            row['unitId'] as String,
            row['unitName'] as String,
            row['qty'] as String,
            row['remark'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String),
        arguments: [orderId]);
  }

  @override
  Future<void> deleteItem(String orderItemId) async {
    await _queryAdapter.queryNoReturn(
        'delete from OrderItemTable where orderItemId =?1',
        arguments: [orderItemId]);
  }

  @override
  Future<void> deleteByOrderID(String orderId) async {
    await _queryAdapter.queryNoReturn(
        'delete from OrderItemTable where orderId =?1',
        arguments: [orderId]);
  }

  @override
  Future<void> addOrderItem(OrderItemTable orderItems) async {
    await _orderItemTableInsertionAdapter.insert(
        orderItems, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateOrderItem(OrderItemTable orderItems) async {
    await _orderItemTableUpdateAdapter.update(
        orderItems, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOrderItem(OrderItemTable orderItems) async {
    await _orderItemTableDeletionAdapter.delete(orderItems);
  }
}

class _$OrderDao extends OrderDao {
  _$OrderDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _orderTableInsertionAdapter = InsertionAdapter(
            database,
            'OrderTable',
            (OrderTable item) => <String, Object?>{
                  'orderId': item.orderId,
                  'requestNo': item.requestNo,
                  'date': item.date,
                  'orderDate': item.orderDate,
                  'requestStatus': item.requestStatus,
                  'mrType': item.mrType,
                  'requestBy': item.requestBy,
                  'requestTo': item.requestTo,
                  'stationName': item.stationName,
                  'remark': item.remark,
                  'statusRemark': item.statusRemark,
                  'approvedBy': item.approvedBy,
                  'superApproveBy': item.superApproveBy,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn,
                  'station': item.station,
                  'isUpload': item.isUpload
                }),
        _orderTableUpdateAdapter = UpdateAdapter(
            database,
            'OrderTable',
            ['orderId'],
            (OrderTable item) => <String, Object?>{
                  'orderId': item.orderId,
                  'requestNo': item.requestNo,
                  'date': item.date,
                  'orderDate': item.orderDate,
                  'requestStatus': item.requestStatus,
                  'mrType': item.mrType,
                  'requestBy': item.requestBy,
                  'requestTo': item.requestTo,
                  'stationName': item.stationName,
                  'remark': item.remark,
                  'statusRemark': item.statusRemark,
                  'approvedBy': item.approvedBy,
                  'superApproveBy': item.superApproveBy,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn,
                  'station': item.station,
                  'isUpload': item.isUpload
                }),
        _orderTableDeletionAdapter = DeletionAdapter(
            database,
            'OrderTable',
            ['orderId'],
            (OrderTable item) => <String, Object?>{
                  'orderId': item.orderId,
                  'requestNo': item.requestNo,
                  'date': item.date,
                  'orderDate': item.orderDate,
                  'requestStatus': item.requestStatus,
                  'mrType': item.mrType,
                  'requestBy': item.requestBy,
                  'requestTo': item.requestTo,
                  'stationName': item.stationName,
                  'remark': item.remark,
                  'statusRemark': item.statusRemark,
                  'approvedBy': item.approvedBy,
                  'superApproveBy': item.superApproveBy,
                  'modifyBy': item.modifyBy,
                  'modifyOn': item.modifyOn,
                  'createdBy': item.createdBy,
                  'createdOn': item.createdOn,
                  'station': item.station,
                  'isUpload': item.isUpload
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<OrderTable> _orderTableInsertionAdapter;

  final UpdateAdapter<OrderTable> _orderTableUpdateAdapter;

  final DeletionAdapter<OrderTable> _orderTableDeletionAdapter;

  @override
  Future<List<OrderTable>> getAllOrder() async {
    return _queryAdapter.queryList('select * from OrderTable',
        mapper: (Map<String, Object?> row) => OrderTable(
            row['orderId'] as String,
            row['requestNo'] as String,
            row['date'] as String,
            row['requestStatus'] as String,
            row['mrType'] as String,
            row['requestBy'] as String,
            row['requestTo'] as String,
            row['stationName'] as String,
            row['remark'] as String,
            row['statusRemark'] as String,
            row['approvedBy'] as String,
            row['superApproveBy'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String,
            row['isUpload'] as String,
            row['orderDate'] as String,
            row['station'] as String));
  }

  @override
  Future<List<OrderTable>> getByDate(String orderDate) async {
    return _queryAdapter.queryList(
        'select * from OrderTable where orderDate =?1 order by requestNo desc',
        mapper: (Map<String, Object?> row) => OrderTable(
            row['orderId'] as String,
            row['requestNo'] as String,
            row['date'] as String,
            row['requestStatus'] as String,
            row['mrType'] as String,
            row['requestBy'] as String,
            row['requestTo'] as String,
            row['stationName'] as String,
            row['remark'] as String,
            row['statusRemark'] as String,
            row['approvedBy'] as String,
            row['superApproveBy'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String,
            row['isUpload'] as String,
            row['orderDate'] as String,
            row['station'] as String),
        arguments: [orderDate]);
  }

  @override
  Future<List<OrderTable>> getByStation(
      String orderDate, String station) async {
    return _queryAdapter.queryList(
        'select * from OrderTable where orderDate =?1 and station=?2 order by requestNo desc',
        mapper: (Map<String, Object?> row) => OrderTable(row['orderId'] as String, row['requestNo'] as String, row['date'] as String, row['requestStatus'] as String, row['mrType'] as String, row['requestBy'] as String, row['requestTo'] as String, row['stationName'] as String, row['remark'] as String, row['statusRemark'] as String, row['approvedBy'] as String, row['superApproveBy'] as String, row['modifyBy'] as String, row['modifyOn'] as String, row['createdBy'] as String, row['createdOn'] as String, row['isUpload'] as String, row['orderDate'] as String, row['station'] as String),
        arguments: [orderDate, station]);
  }

  @override
  Future<List<OrderTable>> getByOrderId(String orderId) async {
    return _queryAdapter.queryList('select * from OrderTable where orderId =?1',
        mapper: (Map<String, Object?> row) => OrderTable(
            row['orderId'] as String,
            row['requestNo'] as String,
            row['date'] as String,
            row['requestStatus'] as String,
            row['mrType'] as String,
            row['requestBy'] as String,
            row['requestTo'] as String,
            row['stationName'] as String,
            row['remark'] as String,
            row['statusRemark'] as String,
            row['approvedBy'] as String,
            row['superApproveBy'] as String,
            row['modifyBy'] as String,
            row['modifyOn'] as String,
            row['createdBy'] as String,
            row['createdOn'] as String,
            row['isUpload'] as String,
            row['orderDate'] as String,
            row['station'] as String),
        arguments: [orderId]);
  }

  @override
  Future<void> deleteByOrderId(String orderId) async {
    await _queryAdapter.queryNoReturn(
        'delete from OrderTable where orderId =?1',
        arguments: [orderId]);
  }

  @override
  Future<void> addOrder(OrderTable orders) async {
    await _orderTableInsertionAdapter.insert(
        orders, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateOrder(OrderTable orders) async {
    await _orderTableUpdateAdapter.update(orders, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOrder(OrderTable orders) async {
    await _orderTableDeletionAdapter.delete(orders);
  }
}

class _$StationDao extends StationDao {
  _$StationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _stationTableInsertionAdapter = InsertionAdapter(
            database,
            'StationTable',
            (StationTable item) => <String, Object?>{
                  'StationID': item.StationID,
                  'StationName': item.StationName,
                  'Address': item.Address,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'StationCode': item.StationCode,
                  'Remark': item.Remark,
                  'CreatedByCode': item.CreatedByCode,
                  'ModifiedByCode': item.ModifiedByCode
                }),
        _stationTableUpdateAdapter = UpdateAdapter(
            database,
            'StationTable',
            ['StationID'],
            (StationTable item) => <String, Object?>{
                  'StationID': item.StationID,
                  'StationName': item.StationName,
                  'Address': item.Address,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'StationCode': item.StationCode,
                  'Remark': item.Remark,
                  'CreatedByCode': item.CreatedByCode,
                  'ModifiedByCode': item.ModifiedByCode
                }),
        _stationTableDeletionAdapter = DeletionAdapter(
            database,
            'StationTable',
            ['StationID'],
            (StationTable item) => <String, Object?>{
                  'StationID': item.StationID,
                  'StationName': item.StationName,
                  'Address': item.Address,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'StationCode': item.StationCode,
                  'Remark': item.Remark,
                  'CreatedByCode': item.CreatedByCode,
                  'ModifiedByCode': item.ModifiedByCode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StationTable> _stationTableInsertionAdapter;

  final UpdateAdapter<StationTable> _stationTableUpdateAdapter;

  final DeletionAdapter<StationTable> _stationTableDeletionAdapter;

  @override
  Future<List<StationTable>> getAllStation() async {
    return _queryAdapter.queryList('select * from StationTable',
        mapper: (Map<String, Object?> row) => StationTable(
            row['StationID'] as String,
            row['StationName'] as String,
            row['Address'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['StationCode'] as String,
            row['Remark'] as String,
            row['CreatedByCode'] as String,
            row['ModifiedByCode'] as String));
  }

  @override
  Future<List<StationTable>> getByName(String stationName) async {
    return _queryAdapter.queryList(
        'select * from StationTable where StationName =?1',
        mapper: (Map<String, Object?> row) => StationTable(
            row['StationID'] as String,
            row['StationName'] as String,
            row['Address'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['StationCode'] as String,
            row['Remark'] as String,
            row['CreatedByCode'] as String,
            row['ModifiedByCode'] as String),
        arguments: [stationName]);
  }

  @override
  Future<List<StationTable>> getByID(String stationID) async {
    return _queryAdapter.queryList(
        'select * from StationTable where StationID =?1',
        mapper: (Map<String, Object?> row) => StationTable(
            row['StationID'] as String,
            row['StationName'] as String,
            row['Address'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['StationCode'] as String,
            row['Remark'] as String,
            row['CreatedByCode'] as String,
            row['ModifiedByCode'] as String),
        arguments: [stationID]);
  }

  @override
  Future<void> addStation(StationTable stations) async {
    await _stationTableInsertionAdapter.insert(
        stations, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateStation(StationTable stations) async {
    await _stationTableUpdateAdapter.update(stations, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStation(StationTable stations) async {
    await _stationTableDeletionAdapter.delete(stations);
  }
}

class _$ProgramDao extends ProgramDao {
  _$ProgramDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _programTableInsertionAdapter = InsertionAdapter(
            database,
            'ProgramTable',
            (ProgramTable item) => <String, Object?>{
                  'SysProgramId': item.SysProgramId,
                  'ProgramCode': item.ProgramCode,
                  'ProgramName': item.ProgramName,
                  'SystemgroupID': item.SystemgroupID,
                  'userID': item.userID
                }),
        _programTableUpdateAdapter = UpdateAdapter(
            database,
            'ProgramTable',
            ['SysProgramId'],
            (ProgramTable item) => <String, Object?>{
                  'SysProgramId': item.SysProgramId,
                  'ProgramCode': item.ProgramCode,
                  'ProgramName': item.ProgramName,
                  'SystemgroupID': item.SystemgroupID,
                  'userID': item.userID
                }),
        _programTableDeletionAdapter = DeletionAdapter(
            database,
            'ProgramTable',
            ['SysProgramId'],
            (ProgramTable item) => <String, Object?>{
                  'SysProgramId': item.SysProgramId,
                  'ProgramCode': item.ProgramCode,
                  'ProgramName': item.ProgramName,
                  'SystemgroupID': item.SystemgroupID,
                  'userID': item.userID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProgramTable> _programTableInsertionAdapter;

  final UpdateAdapter<ProgramTable> _programTableUpdateAdapter;

  final DeletionAdapter<ProgramTable> _programTableDeletionAdapter;

  @override
  Future<List<ProgramTable>> getAllProgram() async {
    return _queryAdapter.queryList('select * from ProgramTable',
        mapper: (Map<String, Object?> row) => ProgramTable(
            row['SysProgramId'] as String,
            row['ProgramCode'] as String,
            row['ProgramName'] as String,
            row['SystemgroupID'] as String,
            row['userID'] as String));
  }

  @override
  Future<List<ProgramTable>> getByUserID(String userID) async {
    return _queryAdapter.queryList(
        'select * from ProgramTable where userID =?1',
        mapper: (Map<String, Object?> row) => ProgramTable(
            row['SysProgramId'] as String,
            row['ProgramCode'] as String,
            row['ProgramName'] as String,
            row['SystemgroupID'] as String,
            row['userID'] as String),
        arguments: [userID]);
  }

  @override
  Future<List<ProgramTable>> getPermission(
      String userID, String programCode) async {
    return _queryAdapter.queryList(
        'select * from ProgramTable where userID =?1 and ProgramCode=?2',
        mapper: (Map<String, Object?> row) => ProgramTable(
            row['SysProgramId'] as String,
            row['ProgramCode'] as String,
            row['ProgramName'] as String,
            row['SystemgroupID'] as String,
            row['userID'] as String),
        arguments: [userID, programCode]);
  }

  @override
  Future<void> addStation(ProgramTable programs) async {
    await _programTableInsertionAdapter.insert(
        programs, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateStation(ProgramTable programs) async {
    await _programTableUpdateAdapter.update(programs, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteStation(ProgramTable programs) async {
    await _programTableDeletionAdapter.delete(programs);
  }
}

class _$LoginUserDao extends LoginUserDao {
  _$LoginUserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _loginUserTableInsertionAdapter = InsertionAdapter(
            database,
            'LoginUserTable',
            (LoginUserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                }),
        _loginUserTableUpdateAdapter = UpdateAdapter(
            database,
            'LoginUserTable',
            ['UserID'],
            (LoginUserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                }),
        _loginUserTableDeletionAdapter = DeletionAdapter(
            database,
            'LoginUserTable',
            ['UserID'],
            (LoginUserTable item) => <String, Object?>{
                  'UserID': item.UserID,
                  'UserCode': item.UserCode,
                  'UserName': item.UserName,
                  'LastLogin': item.LastLogin,
                  'Password': item.Password,
                  'Note': item.Note,
                  'Active': item.Active,
                  'CreatedBy': item.CreatedBy,
                  'CreatedOn': item.CreatedOn,
                  'ModifiedBy': item.ModifiedBy,
                  'ModifiedOn': item.ModifiedOn,
                  'LastAction': item.LastAction,
                  'EnableTouch': item.EnableTouch,
                  'CreatedByCode': item.CreatedByCode,
                  'CreatedByName': item.CreatedByName,
                  'ModifedByCode': item.ModifedByCode,
                  'ModifiedByName': item.ModifiedByName,
                  'DepartmentID': item.DepartmentID,
                  'LandingPage': item.LandingPage,
                  'AllowArrival': item.AllowArrival,
                  'AllowBlackList': item.AllowBlackList,
                  'AllowDeparture': item.AllowDeparture,
                  'AllowInterpol': item.AllowInterpol,
                  'AllowCenter': item.AllowCenter,
                  'DepartmentCode': item.DepartmentCode,
                  'DepartmentName': item.DepartmentName,
                  'RoleID': item.RoleID,
                  'RoleName': item.RoleName,
                  'Email': item.Email,
                  'PositionName': item.PositionName,
                  'PositionID': item.PositionID,
                  'StationID': item.StationID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LoginUserTable> _loginUserTableInsertionAdapter;

  final UpdateAdapter<LoginUserTable> _loginUserTableUpdateAdapter;

  final DeletionAdapter<LoginUserTable> _loginUserTableDeletionAdapter;

  @override
  Future<List<LoginUserTable>> getAllUser() async {
    return _queryAdapter.queryList('select * from LoginUserTable',
        mapper: (Map<String, Object?> row) => LoginUserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String));
  }

  @override
  Future<List<LoginUserTable>> getUserByUserId(String userID) async {
    return _queryAdapter.queryList(
        'select * from LoginUserTable where UserID =?1',
        mapper: (Map<String, Object?> row) => LoginUserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userID]);
  }

  @override
  Future<List<LoginUserTable>> getUserByUserCodeAndPassword(
      String userCode, String password) async {
    return _queryAdapter.queryList(
        'select * from LoginUserTable where UserCode =?1 and Password =?2',
        mapper: (Map<String, Object?> row) => LoginUserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userCode, password]);
  }

  @override
  Future<List<LoginUserTable>> getUserByUserCode(String userCode) async {
    return _queryAdapter.queryList(
        'select * from LoginUserTable where UserCode =?1',
        mapper: (Map<String, Object?> row) => LoginUserTable(
            row['UserID'] as String,
            row['UserCode'] as String,
            row['UserName'] as String,
            row['LastLogin'] as String,
            row['Password'] as String,
            row['Note'] as String,
            row['Active'] as String,
            row['CreatedBy'] as String,
            row['CreatedOn'] as String,
            row['ModifiedBy'] as String,
            row['ModifiedOn'] as String,
            row['LastAction'] as String,
            row['EnableTouch'] as String,
            row['CreatedByCode'] as String,
            row['CreatedByName'] as String,
            row['ModifedByCode'] as String,
            row['ModifiedByName'] as String,
            row['DepartmentID'] as String,
            row['LandingPage'] as String,
            row['AllowArrival'] as String,
            row['AllowBlackList'] as String,
            row['AllowDeparture'] as String,
            row['AllowInterpol'] as String,
            row['AllowCenter'] as String,
            row['DepartmentCode'] as String,
            row['DepartmentName'] as String,
            row['RoleID'] as String,
            row['RoleName'] as String,
            row['Email'] as String,
            row['PositionName'] as String,
            row['PositionID'] as String,
            row['StationID'] as String),
        arguments: [userCode]);
  }

  @override
  Future<void> updatePassword(String userID, String password) async {
    await _queryAdapter.queryNoReturn(
        'update LoginUserTable set Password =?2 where UserID =?1',
        arguments: [userID, password]);
  }

  @override
  Future<void> addUser(LoginUserTable user) async {
    await _loginUserTableInsertionAdapter.insert(
        user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateNote(LoginUserTable user) async {
    await _loginUserTableUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNote(LoginUserTable user) async {
    await _loginUserTableDeletionAdapter.delete(user);
  }

  @override
  Future<void> deleteAllNotes(List<LoginUserTable> users) async {
    await _loginUserTableDeletionAdapter.deleteList(users);
  }
}
