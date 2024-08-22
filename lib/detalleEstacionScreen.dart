import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'estacion.dart';

class DetallesEstacionScreen extends StatelessWidget {
  final Estacion estacion;

  DetallesEstacionScreen({required this.estacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Station Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Angle: ${estacion.angulo}°'),
            Text('Minutes: ${estacion.minutos}'),
            Text('Seconds: ${estacion.segundos}'),

            Text('Is Initial Station: ${estacion.esEstacionInicial}'),
            Text('Is Final Station: ${estacion.esEstacionFinal}'),
          ],
        ),
      ),
    );
  }
}