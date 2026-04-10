// Sync mapper skeleton — reserved for future backend integration.
// Will transform local models to/from remote API DTOs.

class SyncMapperService {
  Map<String, dynamic> toRemote(Map<String, dynamic> localMap) {
    // Identity mapper for now — override when API schema differs
    return localMap;
  }

  Map<String, dynamic> fromRemote(Map<String, dynamic> remoteMap) {
    return remoteMap;
  }
}
