import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatosFinalesScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDatosIngresados;


  DatosFinalesScreen({this.onDatosIngresados});

  @override
  _DatosFinalesScreenState createState() => _DatosFinalesScreenState();
}

class _DatosFinalesScreenState extends State<DatosFinalesScreen> {
  TextEditingController controllerAngulo1 = TextEditingController();
  TextEditingController controllerMinutos1 = TextEditingController();
  TextEditingController controllerSegundos1 = TextEditingController();
  TextEditingController controllerEasting1 = TextEditingController();
  TextEditingController controllerNorthing1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Station Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatosEstacionForm(
                1,
                controllerAngulo1,
                controllerMinutos1,
                controllerSegundos1,
                controllerEasting1,
                controllerNorthing1,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Obtener los valores ingresados
                  double angulo1 = double.parse(controllerAngulo1.text);
                  double minutos1 = double.parse(controllerMinutos1.text);
                  double segundos1 = double.parse(controllerSegundos1.text);
                  double easting1 = double.parse(controllerEasting1.text);
                  double northing1 = double.parse(controllerNorthing1.text);

                  // Devuelve los datos ingresados al widget anterior
                  if (widget.onDatosIngresados != null) {
                    widget.onDatosIngresados!({
                      'angulo1': angulo1,
                      'minutos1': minutos1,
                      'segundos1': segundos1,
                      'easting1': easting1,
                      'northing1': northing1,
                    });


                  }

                  // Cierra la pantalla actual
                  Navigator.pop(context);
                },
                child: Text('Process Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatosEstacionForm(
      int estacionNum,
      TextEditingController anguloController,
      TextEditingController minutosController,
      TextEditingController segundosController,
      TextEditingController eastingController,
      TextEditingController northingController,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Station $estacionNum:'),
        TextField(
          controller: anguloController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Angle'),
        ),
        TextField(
          controller: minutosController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Minutes'),
        ),
        TextField(
          controller: segundosController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Segundos'),
        ),
        TextField(
          controller: eastingController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Easting (m)'),
        ),
        TextField(
          controller: northingController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Northing (m)'),
        ),
      ],
    );
  }
}