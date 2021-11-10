//create migration
import 'package:floor/floor.dart';

final migration5to6 = Migration(5, 6, (database) async {
  await database.execute('ALTER TABLE ItemUnitTable ADD COLUMN Seq TEXT default ''');
});

