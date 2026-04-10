// Remote auth service skeleton — reserved for future user account system.

class RemoteAuthService {
  bool get isSignedIn => false;
  String? get currentUserId => null;

  Future<void> signIn(String email, String password) async {
    throw UnimplementedError('Auth not configured yet.');
  }

  Future<void> signOut() async {
    throw UnimplementedError('Auth not configured yet.');
  }
}
