import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'estacion.dart';

class InformacionProyectoScreen extends StatefulWidget {
  final List<Estacion> estaciones;

  InformacionProyectoScreen({required this.estaciones});

  @override
  _InformacionProyectoScreenState createState() => _InformacionProyectoScreenState();
}

class _InformacionProyectoScreenState extends State<InformacionProyectoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Project Information'),
      ),
      body: Container(
        color: Colors.blue.shade900, // Color celeste oscuro
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildEstacionInfo(widget.estaciones, true),
            _buildEstacionInfo(widget.estaciones, false),
          ],
        ),
      ),
    );
  }

  Widget _buildEstacionInfo(List<Estacion> estaciones, bool esInicial) {
    List<Widget> widgetsEstaciones = [];

    for (Estacion estacion in estaciones) {
      if ((!esInicial && estacion.esEstacionInicial) ||
          (esInicial && estacion.esEstacionFinal)) {
        continue;
      }

      double anguloTotal = estacion.calcularAnguloTotal(estaciones, estaciones.indexOf(estacion));

      widgetsEstaciones.add(
        Card(
          color: Colors.grey, // Color gris para la tarjeta
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text('Station ${estaciones.indexOf(estacion) + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Angle: ${estacion.angulo}'),
                Text('Minutes: ${estacion.minutos}'),
                Text('Seconds: ${estacion.segundos}'),
                Text('Distance: ${estacion.distancia}'),
                Text('Total Angle: ${estacion.calcularSuma()}'),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: widgetsEstaciones.isNotEmpty
            ? widgetsEstaciones
            : [Text('No information available')],
      ),
    );
  }
}