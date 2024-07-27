import 'package:flutter/material.dart';
import 'package:productos_app/controllers/Service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:productos_app/views/menuBarView.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _formKey = GlobalKey<FormState>();
  List<Marker> _markers = [];
  List<dynamic> productos = [];
  List<dynamic> sucursales = [];

  //se ejecuta al iniciar la página
  @override
  void initState() {
    super.initState();
    listar_productos();
  }

  void listar_productos() {
    setState(() {
      Service c = Service();

      c.listar_productos().then((value) async {
        if (value.code == '200') {
          print('se obtuvieron los productos');
          productos = value.datos;
        } else {
          print('error al obtener los productos');
        }
        listarSucursales();
      });
    });
  }

  //método para listar sucursales
  void listarSucursales() {
    setState(() {
      Service c = Service();
      c.listar_sucursal().then((value) async {
        if (value.code == '200') {
          print('se obtuvieron las sucursales');
          sucursales = value.datos;
          List<Marker> markers = sucursales.map((sucursal) {
            String estado = 'Desconocido';
            double latitud = sucursal['latitud'];
            double longitud = sucursal['longitud'];
            String nombre = sucursal['nombre'];
            int sucursalId = sucursal['id'];
            for (var producto in productos) {
              if (producto['sucursal_id'] == sucursalId) {
                if (producto['estado'] == 'Caducado' ||
                    producto['estado'] == 'CADUCADO')
                  estado = 'Con productos caducados';
                else {
                  estado = 'Sin productos caducados';
                }
              }
            }
            return Marker(
              point: LatLng(latitud, longitud),
              width: 200,
              height: 100,
              child: Column(
                children: [
                  Icon(Icons.location_on, color: Color.fromRGBO(0, 128, 0, 1)),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            estado,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();

          setState(() {
            _markers = markers;
          });
        } else {
          print('Error al obtener sucursales');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MenuBarView(message: 'Menu'),
        body: FlutterMap(
          options: const MapOptions(
              initialCenter: LatLng(-3.99942, -79.2076),
              initialZoom: 17, //17
              interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.doubleTapDragZoom |
                      InteractiveFlag.pinchZoom)),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: _markers,
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () =>
                      (Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ));
  }
}
