/// Stub for future sync service.
/// Will handle push/pull sync, conflict resolution, and change queue.
abstract class SyncService {
  Future<void> sync();
  bool get isSyncing;
}

class SyncServiceStub implements SyncService {
  @override
  bool get isSyncing => false;

  @override
  Future<void> sync() async {
    // No-op for local-first MVP
  }
}
