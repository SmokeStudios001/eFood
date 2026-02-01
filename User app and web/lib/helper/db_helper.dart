import 'package:flutter_restaurant/data/datasource/local/cache_response.dart';
import 'package:flutter_restaurant/main.dart';

class DbHelper {
  static Future<void> insertOrUpdate({
    required String id,
    required CacheResponseCompanion data,
  }) async {
    // 1. Start a database transaction.
    await database.transaction(() async {
      // 2. Get the response within the safe transaction block.
      // This locks the relevant part of the table until the transaction completes.
      final response = await database.getCacheResponseById(id);

      if (response?.endPoint != null) {
        // Entry exists, so update it.
        await database.updateCacheResponse(id, data);
      } else {
        // Entry does not exist, so insert it.
        await database.insertCacheResponse(data);
      }
    }); // The transaction is committed/completed here.
  }
}