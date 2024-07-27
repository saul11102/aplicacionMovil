import 'package:flutter/material.dart';
import 'package:productos_app/controllers/Service.dart';
import 'package:productos_app/views/menuBarView.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> productos = [];
  List<dynamic> sucursales = [];
  String? sucursalSeleccionada;

  @override
  void initState() {
    super.initState();
    listarSucursales();
    listarProductos();
  }

  void listarProductos() {
    Service c = Service();
    c.listar_productos().then((value) {
      if (value.code == '200') {
        setState(() {
          productos = value.datos;
        });
      } else {
        // Manejar el error de obtener productos
        print('error al obtener los productos');
      }
    });
  }

  void listarSucursales() {
    Service c = Service();
    c.listar_sucursal().then((value) {
      if (value.code == '200') {
        setState(() {
          sucursales = value.datos;
          if (sucursales.isNotEmpty) {
            sucursalSeleccionada = sucursales[0]['id'].toString();
          }
        });
      } else {
        // Manejar el error de obtener sucursales
        print('error al obtener las sucursales');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MenuBarView(message: 'Menu'),
      body: Column(
        children: [
          // Menú desplegable para seleccionar sucursal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: sucursalSeleccionada,
              items: sucursales.map((sucursal) {
                return DropdownMenuItem<String>(
                  value: sucursal['id'].toString(),
                  child: Text(sucursal['nombre']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  sucursalSeleccionada = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Seleccione una sucursal',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Tabla de productos filtrados por sucursal seleccionada
          Expanded(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Nombre',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Precio',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Estado',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: productos
                  .where((producto) => sucursalSeleccionada == null ||
                      producto['sucursal_id'].toString() ==
                          sucursalSeleccionada)
                  .map((producto) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(producto['nombre'])),
                    DataCell(Text(producto['precio'].toString())),
                    DataCell(Text(producto['estado'])),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
