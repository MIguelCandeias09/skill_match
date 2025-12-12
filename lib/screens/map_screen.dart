import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/firebase_offer_service.dart';
import '../services/geocoding_service.dart';
import '../services/firebase_request_service.dart'; // <--- Importar o serviço
import '../models/offer_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController? _mapController;
  final LatLng _center = LatLng(38.7223, -9.1393);

  List<Offer> _offers = [];
  Map<String, LatLng?> _coordinates = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOffersWithCoordinates();
  }

  Future<void> _loadOffersWithCoordinates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final offers = await FirebaseOfferService.getOffers();
      final locations = offers.map((o) => o.location).toSet().toList();
      final coordinates = await GeocodingService.getMultipleCoordinates(locations);

      setState(() {
        _offers = offers;
        _coordinates = coordinates;
        _isLoading = false;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        _fitMapToMarkers();
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar ofertas: $e';
        _isLoading = false;
      });
    }
  }

  void _fitMapToMarkers() {
    if (_mapController == null) return;
    final validCoords = _coordinates.values.whereType<LatLng>().toList();
    if (validCoords.isEmpty) return;

    double minLat = validCoords.first.latitude;
    double maxLat = validCoords.first.latitude;
    double minLng = validCoords.first.longitude;
    double maxLng = validCoords.first.longitude;

    for (final coord in validCoords) {
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.longitude < minLng) minLng = coord.longitude;
      if (coord.longitude > maxLng) maxLng = coord.longitude;
    }

    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
    _mapController!.move(center, 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Ofertas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOffersWithCoordinates,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => _mapController?.move(_center, 12.0),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('A carregar coordenadas...'),
          ],
        ),
      )
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOffersWithCoordinates,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      )
          : FlutterMap(
        mapController: _mapController ??= MapController(),
        options: MapOptions(
          initialCenter: _center,
          initialZoom: 12.0,
          minZoom: 5.0,
          maxZoom: 18.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.skill_match',
          ),
          MarkerLayer(
            markers: _offers
                .where((offer) => _coordinates[offer.location] != null)
                .map((offer) {
              final coordinates = _coordinates[offer.location]!;
              return Marker(
                point: coordinates,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showOfferDetails(context, offer),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A4FFF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showOfferDetails(BuildContext context, Offer offer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8A4FFF), Color(0xFFFF6B9D)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.userName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(offer.location, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8A4FFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Oferece', style: TextStyle(color: Color(0xFF8A4FFF), fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(offer.offering, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B9D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Procura', style: TextStyle(color: Color(0xFFFF6B9D), fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(offer.lookingFor, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // --- LÓGICA DE ENVIAR PEDIDO ---
                final success = await FirebaseRequestService.sendRequest(
                  toUserId: offer.userId,
                  toUserName: offer.userName,
                  offerTitle: offer.offering,
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Pedido enviado com sucesso!' : 'Erro ao enviar pedido.'),
                      backgroundColor: success ? const Color(0xFF8A4FFF) : Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Contactar'),
            ),
          ],
        ),
      ),
    );
  }
}