import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';

String docsDir = '';

class DataStore {
  late final Store store;

  DataStore._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<DataStore> create() async {
    docsDir = (await getApplicationDocumentsDirectory()).path;
    final store = await openStore(directory: p.join(docsDir, "obx-example"));
    return DataStore._create(store);
  }
}
