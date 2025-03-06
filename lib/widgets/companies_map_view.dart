import 'package:acesso_mapeado/shared/color_blindness_type.dart';
import 'package:acesso_mapeado/shared/map_styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:acesso_mapeado/controllers/user_controller.dart';
import 'package:acesso_mapeado/models/company_model.dart';
import 'package:acesso_mapeado/widgets/accessibility_sheet.dart';

class CompaniesMapView extends StatefulWidget {
  final List<CompanyModel> companies;

  const CompaniesMapView({
    super.key,
    required this.companies,
  });

  @override
  State<CompaniesMapView> createState() => _CompaniesMapViewState();
}

class _CompaniesMapViewState extends State<CompaniesMapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  // Adicionar constantes para configuração do mapa
  static const double _defaultZoom = 12.0;
  static const double _buttonSpacing = 8.0;
  static const double _buttonPadding = 16.0;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _createMarkers();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _createMarkers() async {
    _markers = widget.companies.where((company) {
      return company.latitude != null &&
          company.longitude != null &&
          company.latitude != 0 &&
          company.longitude != 0;
    }).map((company) {
      return Marker(
        markerId: MarkerId(company.name),
        position: LatLng(company.latitude!, company.longitude!),
        infoWindow: InfoWindow(
          title: company.name,
          snippet: '★ ${company.rating?.toStringAsFixed(1) ?? "N/A"}',
          onTap: () => _showCompanyDetails(company),
        ),
      );
    }).toSet();
  }

  void _showCompanyDetails(CompanyModel company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AccessibilitySheet(companyModel: company);
      },
    );
  }

  Future<void> _centerMapOnUser(List<CompanyModel> companies) async {
    final userPosition =
        Provider.of<UserController>(context, listen: false).userPosition;
    double maxDistance = 0;
    for (var company in companies) {
      final distanceToCompany = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition.longitude,
        company.latitude!,
        company.longitude!,
      );
      if (distanceToCompany > maxDistance) {
        maxDistance = distanceToCompany;
      }
    }
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(userPosition!.latitude, userPosition.longitude),
            zoom: calculateZoomDistance(maxDistance),
          ),
        ),
      );
    }
  }

  double calculateZoomDistance(double distance) {
    // Zoom levels based on distance ranges
    // Higher zoom = closer view, lower zoom = wider view
    if (distance <= 500) {
      return 16.0; // Very close view for distances under 500m
    } else if (distance <= 1000) {
      return 15.0; // Close view for distances under 1km
    } else if (distance <= 2500) {
      return 14.0; // Medium-close view for distances under 2.5km
    } else if (distance <= 5000) {
      return 13.0; // Medium view for distances under 5km
    } else if (distance <= 10000) {
      return 11.0; // Medium-far view for distances under 10km
    } else if (distance <= 25000) {
      return 10.0; // Far view for distances under 25km
    } else {
      return 9.0; // Very far view for larger distances
    }
  }

  // Extrair widget dos botões flutuantes
  Widget _buildMapButtons() {
    return Positioned(
      right: _buttonPadding,
      bottom: _buttonPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatingButton(
            heroTag: 'centerMap',
            icon: Icons.my_location,
            onPressed: () => _centerMapOnUser(widget.companies),
          ),
          const SizedBox(height: _buttonSpacing),
          _buildFloatingButton(
            heroTag: 'zoomIn',
            icon: Icons.add,
            onPressed: () =>
                _mapController?.animateCamera(CameraUpdate.zoomIn()),
          ),
          const SizedBox(height: _buttonSpacing),
          _buildFloatingButton(
            heroTag: 'zoomOut',
            icon: Icons.remove,
            onPressed: () =>
                _mapController?.animateCamera(CameraUpdate.zoomOut()),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPosition = Provider.of<UserController>(context).userPosition;

    if (_isLoading || userPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          style: MapStyles.getColorBlindStyle(
            Provider.of<ProviderColorBlindnessType>(context).getCurrentType(),
          ),
          initialCameraPosition: CameraPosition(
            target: userPosition,
            zoom: _defaultZoom,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (controller) => _mapController = controller,
        ),
        _buildMapButtons(),
      ],
    );
  }
}
