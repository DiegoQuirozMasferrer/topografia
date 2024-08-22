import 'package:flutter/material.dart';
import 'datosFinalesScreen.dart';
import 'datosInicialesScreen.dart';
import 'detalleEstacionScreen.dart';
import 'estacion.dart';
import 'informacionEstaciones.dart';
import 'informacionProyectoScreen.dart';
import 'nuevaEstacion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Estacion> estaciones = [];
  Map<String, dynamic>? datosEstacion1;
  Map<String, dynamic>? datosEstacion2;

  String _obtenerTipoEstacion(Estacion estacion) {
    if (estacion.esEstacionInicial) {
      return 'Initial';
    } else if (estacion.esEstacionFinal) {
      return 'Final';
    } else {
      return '';
    }
  }
  void _mostrarPantallaAgregarEstacion(BuildContext context) {

  }

  void _mostrarPantallaConfiguracion(BuildContext context) {

  }
  void _mostrarPantallaEditarEstacion(BuildContext context, int index) async {
    Estacion estacionSeleccionada = estaciones[index];


    Estacion estacionEditada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevaEstacionScreen(estaciones: estaciones, estacionEditar: estacionSeleccionada),
      ),
    );

    // actualizar la estación en la lista
    if (estacionEditada != null) {
      setState(() {
        estaciones[index] = estacionEditada;
      });
    }
  }




  void _handleMenuOption(BuildContext context, String option) {
    switch (option) {
      case 'addStation':
        _mostrarPantallaAgregarEstacion(context);
        break;
      case 'configuration':
        _mostrarPantallaConfiguracion(context);
        break;

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Scree'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _handleMenuOption(context, value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Information',
                  child: Text('Information'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformacionEstacionesScreen(
                          estaciones: estaciones,
                          datosEstacion1: datosEstacion1!,
                          datosEstacion2: datosEstacion2!,
                        ),
                      ),
                    );
                  },
                ),

                PopupMenuItem(
                  value: 'Project Information',
                  child: Text('Project Information'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformacionProyectoScreen(estaciones: estaciones),
                      ),
                    );
                  },
                ),

              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: estaciones.length + 2, //
              itemBuilder: (context, index) {
                if (index < estaciones.length) {

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Station ${index + 1}'),
                      subtitle: Text('Tipo: ${_obtenerTipoEstacion(estaciones[index])}'),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesEstacionScreen(
                              estacion: estaciones[index],
                            ),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _mostrarPantallaEditarEstacion(context, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _mostrarDialogoBorrarEstacion(context, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (index == estaciones.length) {

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Start Station Co-ordinates:'),
                      subtitle: Text('Entered Data: ${datosEstacion1.toString()}'), // mostrar los datos ingresados
                      onTap: () async {
                        // abre la pantalla con  los datos ingresados
                        Map<String, dynamic>? datosIngresados = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DatosInicialesScreen(
                              onDatosIngresados: (datos) {
                                // actualiza la lista de datos
                                setState(() {
                                  datosEstacion1 = datos;
                                });
                              },
                            ),
                          ),
                        );


                      },
                    ),
                  );
                } else {

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Closing Station Co-ordinates:'),
                      subtitle: Text('Entered Data: ${datosEstacion2.toString()}'), // muestra los datos ingresados
                      onTap: () async {
                        // abre la pantalla y espera los datos ingresados
                        Map<String, dynamic>? datosIngresados = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DatosFinalesScreen(
                              onDatosIngresados: (datos) {
                                // Actualiza la lista de datos
                                setState(() {
                                  datosEstacion2 = datos;
                                });
                              },
                            ),
                          ),
                        );


                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // pantalla de agregar nueva estación
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevaEstacionScreen(estaciones: estaciones)),
          ).then((nuevaEstacion) {
            if (nuevaEstacion != null) {
              setState(() {
                estaciones.add(nuevaEstacion);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoBorrarEstacion(BuildContext context, int index) {


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Station'),
          content: Text('Are you sure you want to delete this station?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                setState(() {
                  estaciones.removeAt(index);
                });

                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
