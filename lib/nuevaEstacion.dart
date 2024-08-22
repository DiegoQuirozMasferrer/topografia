import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'estacion.dart';

class NuevaEstacionScreen extends StatefulWidget {
  @override
  late final List<Estacion> estaciones;
  final Estacion? estacionEditar;

  NuevaEstacionScreen({required this.estaciones, this.estacionEditar});

  _NuevaEstacionScreenState createState() => _NuevaEstacionScreenState();
}

class _NuevaEstacionScreenState extends State<NuevaEstacionScreen> {
  late TextEditingController controllerAngulo;
  late TextEditingController controllerMinutos;
  late TextEditingController controllerSegundos;
  late TextEditingController controllerDist;
  late TextEditingController controllerUbicacionEste;
  late TextEditingController controllerUbicacionNorte;
  bool esEstacionInicial = false;
  bool esEstacionFinal = false;

  @override
  void initState() {
    super.initState();
    controllerAngulo = TextEditingController();
    controllerMinutos = TextEditingController();
    controllerSegundos = TextEditingController();
    controllerDist = TextEditingController();
    controllerUbicacionEste = TextEditingController();
    controllerUbicacionNorte = TextEditingController();
    if (widget.estacionEditar != null) {
      cargarValoresActuales();
    }
  }
  void cargarValoresActuales() {
    controllerAngulo.text = widget.estacionEditar!.angulo.toString();
    // cargar otros valores
  }
  bool existeEstacionInicial() {
    return esEstacionInicial != null;
  }

  bool existeEstacionFinal() {
    return esEstacionFinal != null;
  }

  Future<bool?> mostrarDialogoConfirmacion(String titulo, String mensaje) async {
    if (existeEstacionInicial() || existeEstacionFinal()){
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    else {
      // no hay estación inicial ni final registrada, no se muestra el diálogo
      return false;

    }
  }
  void desmarcarEstacionInicial() {
    setState(() {
      // buscar la estación que actualmente está marcada como inicial
      for (Estacion est in widget.estaciones) {
        if (est.esEstacionInicial) {
          // desmarcar la estación encontrada
          est.esEstacionInicial = false;
          break;  // se encontró la estación, salir del bucle
        }
      }
    });
  }

  void desmarcarEstacionFinal() {
    setState(() {
      esEstacionFinal = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Station ${widget.estaciones.length+1}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ángle:'),
              TextField(
                keyboardType: TextInputType.number,
                controller: controllerAngulo,
              ),
              SizedBox(height: 16.0),
              Text('Minutes:'),
              TextField(
                keyboardType: TextInputType.number,
                controller: controllerMinutos,
              ),
              SizedBox(height: 16.0),
              Text('Seconds:'),
              TextField(
                keyboardType: TextInputType.number,
                controller: controllerSegundos,
              ),
              SizedBox(height: 16.0),
              Text('Distance:'),
              TextField(
                keyboardType: TextInputType.number,
                controller: controllerDist,
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Is Initial Station'),
                value: esEstacionInicial,
                onChanged: (value) async {
                  if (value!) {
                    if (existeEstacionInicial()) {
                      bool? confirmar = await mostrarDialogoConfirmacion(
                        'Confirm Initial Station',
                        'There is already an initial station selected. Do you want to change it?', // consulta: Desea que esta sea la inicial
                      );

                      if (confirmar ?? false) {
                        desmarcarEstacionInicial();
                        setState(() {
                          esEstacionInicial = value;
                        });
                      }
                    } else {
                      desmarcarEstacionInicial();
                      setState(() {
                        esEstacionInicial = value;
                      });
                    }
                  } else {
                    desmarcarEstacionInicial();
                    setState(() {
                      esEstacionInicial = value;
                    });
                  }
                },
              ),
              CheckboxListTile(
                title: Text('Is Final Station'),
                value: esEstacionFinal,
                onChanged: (value) async {
                  if (value!) {
                    if (existeEstacionFinal()) {
                      bool? confirmar = await mostrarDialogoConfirmacion(
                        'Confirm Final Station',
                        'There is already a final station selected. Do you want to change it?',
                      );

                      if (confirmar ?? false) {
                        desmarcarEstacionFinal();
                        setState(() {
                          esEstacionFinal = value;
                        });
                      }
                    } else {
                      desmarcarEstacionFinal();
                      setState(() {
                        esEstacionFinal = value;
                      });
                    }
                  } else {
                    desmarcarEstacionFinal();
                    setState(() {
                      esEstacionFinal = value;
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Estacion nuevaEstacion = Estacion(
                    angulo: num.parse(controllerAngulo.text),
                    minutos: num.parse(controllerMinutos.text),
                    segundos: num.parse(controllerSegundos.text),

                    distancia: num.parse(controllerDist.text),


                    esEstacionInicial: esEstacionInicial,
                    esEstacionFinal: esEstacionFinal,
                  );

                  Navigator.pop(context, nuevaEstacion);
                },
                child: Text('Add Station'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}