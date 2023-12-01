//import 'package:mysql1/mysql1.dart';
import 'package:postgres/postgres.dart';

class PostGreSqlInstance {
  static final settings = PostgreSQLConnection('localhost', 5432, 'ozana',
      username: 'postgres', password: 'postgre');
  static Future<void> init() async {
    if (settings.isClosed) {
      await settings.open();
    }
  }

  static void close() {
    settings.close();
  }
  
  static String fedapayLiveKey = 'sk_live_u3RNPFYvhVAmWGqJPXsUSZTn';
}
