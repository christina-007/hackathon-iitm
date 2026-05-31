class MockLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const MockLocation({required this.latitude, required this.longitude, required this.timestamp});
}

class MockLocationService {
  MockLocationService._internal();

  static final MockLocationService instance = MockLocationService._internal();

  MockLocation getCurrentLocation() {
    return MockLocation(
      latitude: 12.9716,
      longitude: 77.5946,
      timestamp: DateTime.now(),
    );
  }

  Future<MockLocation> refreshLocation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return getCurrentLocation();
  }
}
