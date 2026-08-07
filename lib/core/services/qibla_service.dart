import 'dart:math';

class QiblaService {
  // Kaaba coordinates in Mecca
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  /// Calculate initial bearing angle from user coordinates to Kaaba in Mecca (in degrees 0..360)
  static double calculateQiblaBearing(double userLat, double userLng) {
    double userLatRad = userLat * (pi / 180.0);
    double userLngRad = userLng * (pi / 180.0);
    double kaabaLatRad = kaabaLat * (pi / 180.0);
    double kaabaLngRad = kaabaLng * (pi / 180.0);

    double deltaLng = kaabaLngRad - userLngRad;

    double y = sin(deltaLng);
    double x = cos(userLatRad) * tan(kaabaLatRad) - sin(userLatRad) * cos(deltaLng);

    double bearingRad = atan2(y, x);
    double bearingDeg = bearingRad * (180.0 / pi);

    return (bearingDeg + 360.0) % 360.0;
  }

  /// Calculates distance in km from user to Kaaba using Haversine formula
  static double calculateDistanceToKaaba(double userLat, double userLng) {
    const double earthRadiusKm = 6371.0;

    double dLat = (kaabaLat - userLat) * (pi / 180.0);
    double dLng = (kaabaLng - userLng) * (pi / 180.0);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(userLat * (pi / 180.0)) * cos(kaabaLat * (pi / 180.0)) * sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }
}
