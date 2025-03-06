import 'package:color_blindness/color_blindness.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapStyles {
  static BitmapDescriptor? getColorBlindIcon(ColorBlindnessType type) {
    switch (type) {
      case ColorBlindnessType.protanopia:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case ColorBlindnessType.deuteranopia:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case ColorBlindnessType.tritanopia:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case ColorBlindnessType.achromatopsia:
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  static String getColorBlindStyle(ColorBlindnessType type) {
    switch (type) {
      case ColorBlindnessType.protanopia:
      case ColorBlindnessType.deuteranopia:
        return '''[
          {
            "featureType": "all",
            "stylers": [
              {"saturation": -100},
              {"lightness": 10}
            ]
          },
          {
            "featureType": "road",
            "elementType": "geometry",
            "stylers": [
              {"color": "#ffffff"},
              {"weight": 2}
            ]
          },
          {
            "featureType": "poi",
            "elementType": "labels",
            "stylers": [
              {"visibility": "on"},
              {"lightness": 20}
            ]
          }
        ]''';

      case ColorBlindnessType.tritanopia:
        return '''[
          {
            "featureType": "all",
            "stylers": [
              {"saturation": -80},
              {"lightness": 15}
            ]
          },
          {
            "featureType": "road",
            "elementType": "geometry",
            "stylers": [
              {"color": "#c0c0c0"}
            ]
          }
        ]''';

      case ColorBlindnessType.achromatopsia:
        return '''[
          {
            "featureType": "all",
            "stylers": [
              {"saturation": -100}
            ]
          }
        ]''';

      default:
        return '[]';
    }
  }
}
