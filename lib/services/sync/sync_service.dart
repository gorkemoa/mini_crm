// Sync service skeleton — reserved for future backend integration.
// When a remote backend is added, this service will coordinate:
//   1. Detecting local changes since last sync
//   2. Pushing changes via SyncQueueService
//   3. Pulling remote changes
//   4. Resolving conflicts

class SyncService {
  bool get isSyncEnabled => false;

  Future<void> syncAll() async {
    // Not implemented in local-first v1
  }
}
