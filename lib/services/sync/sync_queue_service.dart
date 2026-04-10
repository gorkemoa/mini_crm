// Sync queue skeleton — reserved for future backend integration.
// Will hold local mutations to be pushed on next sync.

class SyncQueueService {
  Future<void> enqueue(String entityType, String entityId, String operation) async {
    // Not implemented in local-first v1
  }

  Future<List<Map<String, dynamic>>> getPendingItems() async {
    return [];
  }

  Future<void> clearAll() async {
    // Not implemented in local-first v1
  }
}
