/// Stub for future remote API integration.
/// Implement with HTTP client (dio/http) when backend is available.
abstract class RemoteApiService {
  Future<void> initialize(String baseUrl, String apiKey);
}

class RemoteApiServiceStub implements RemoteApiService {
  @override
  Future<void> initialize(String baseUrl, String apiKey) async {
    // No-op for local-first MVP
  }
}
