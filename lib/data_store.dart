import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';

class DataStore {
  late final Store store;

  DataStore._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<DataStore> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));
    return DataStore._create(store);
  }
}
