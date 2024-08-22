import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'estacion.dart';

class InformacionEstacionesScreen extends StatefulWidget {
  final List<Estacion> estaciones;
  late final Map<String, dynamic> datosEstacion1;
  late final Map<String, dynamic> datosEstacion2;

  double distanciaTotal = 0;
  double measuredTotalAngle = 0;
  double measuredFwdBearing = 0;
  double MiscSeg = 0;
  double adjustedTotalAngle = 0;
  double adj=0;
  double diffE=0;
  double diffN=0;
  double misclosure=0;
  double measuredFwdBearingUltimaEstacion = 0; // Nuevo atributo
  List<double> datosEspecialesPrimeraEstacion = []!; // Modificado

  InformacionEstacionesScreen({
    required this.estaciones,
    required this.datosEstacion1,
    required this.datosEstacion2,
  });

  @override
  _InformacionEstacionesScreenState createState() =>
      _InformacionEstacionesScreenState();
}

class _InformacionEstacionesScreenState extends State<InformacionEstacionesScreen> {
  late double calMiscSeg=0;
  late double _resultadoUltimaEstacion;
  late List<double> datosEspecialesPrimeraEstacion;
  late List<double> columna2;
  late List<double> columna3;
  late List<double> columna4;
  late List<double> columna5;
  late double sumaAngulosColumna2;

  @override
  void initState() {
    super.initState();

    // Inicializar variables aquí
    datosEspecialesPrimeraEstacion = _calcularDatosEspecialesPrimeraEstacion();
    _resultadoUltimaEstacion = _calcularResultadoUltimaEstacion();
    _calcularColumnas();
  }

  void _calcularColumnas() {
    int numColumns = 15; // 1 (Estaciones) + 13 (Columnas adicionales)
    columna2 = [];
    columna3 = [];
    columna4 = [];
    columna5 = [];
    sumaAngulosColumna2 = 0;

    for (int index = 0; index < widget.estaciones.length; index++) {
      double valorColumna2;
      double valorColumna4;

      if (index == 0) {
        valorColumna2 = datosEspecialesPrimeraEstacion.isNotEmpty
            ? datosEspecialesPrimeraEstacion[0]
            : 0.0;
        valorColumna4 = datosEspecialesPrimeraEstacion.isNotEmpty
            ? datosEspecialesPrimeraEstacion[0]
            : 0.0;
      } else {
        valorColumna2 = _calcularDatosEntreEstaciones(
            columna2[index - 1], widget.estaciones[index]);
        valorColumna4 = _calcularDatosEntreEstaciones(
            columna4[index - 1], widget.estaciones[index]);
      }

      columna2.add(valorColumna2);
      sumaAngulosColumna2 += valorColumna2;
      columna4.add(valorColumna4);

      double valorColumna3 = _calcularDistanciaEstacion(widget.estaciones[index]);
      columna3.add(valorColumna3);
    }

    columna5 = _calcularDatosColumna5(columna3);
    double valorUltimaCeldaColumna2 = columna2.isNotEmpty ? columna2.last : 0.0;
    calMiscSeg = miscSeg(valorUltimaCeldaColumna2);
    widget.misclosure= calMiscSeg;

  }

  double _calcularDistanciaEstacion(Estacion estacion) {
    double valorColumna3 = (estacion.calcularSuma() - (calMiscSeg / widget.estaciones.length) / 3600);
    return valorColumna3;
  }

  double calcularMiscSegUltimaEstacion() {
    if (widget.estaciones.isNotEmpty) {
      double resultadoUltimaEstacion = _calcularResultadoUltimaEstacion();
      return miscSeg(resultadoUltimaEstacion);
    } else {
      return 0.0;
    }
  }

  double _calcularResultadoUltimaEstacion() {
    if (widget.estaciones.isNotEmpty) {
      return _calcularDatosEntreEstaciones(
        datosEspecialesPrimeraEstacion[0],
        widget.estaciones.last,
      );
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // La tabla existente
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: _buildColumns(),
                  rows: _buildRows(),
                ),
              ),
            ),

            // Banner inferior
            Container(
              height: 300,
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Total Distance: ${widget.distanciaTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Measured total angle: ${widget.measuredTotalAngle.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Measured Fwd bearing: ${widget.measuredFwdBearing.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Misc seg: ${widget.misclosure.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Adjusted total angle: ${widget.adjustedTotalAngle.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Adj: ${widget.adj.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Total Diff Easting (m): ${widget.diffE.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Total Diff Northing (m): ${widget.misclosure.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [];
    columns.add(DataColumn(
      label: Text('Stations'),
    ));

    for (int i = 1; i <= 13; i++) {
      columns.add(DataColumn(
        label: Text('Column $i'),
      ));
    }

    return columns;
  }

  List<DataRow> _buildRows() {
    int numColumns = 14;
    List<DataRow> rows = [];
    double distanciaE = widget.datosEstacion1['easting1'];
    double distanciaN = widget.datosEstacion1['northing1'];
    double distanciaAdj = widget.datosEstacion1['easting1'];
    double distanciaAdj2 = widget.datosEstacion1['northing1'];

    for (int estacionIndex = 0; estacionIndex < widget.estaciones.length; estacionIndex++) {
      Estacion estacion = widget.estaciones[estacionIndex];
      List<DataCell> cells = [
        DataCell(
          Text('Station ${estacionIndex + 1}'),
        ),
      ];

      cells.add(DataCell(
        Text('${columna2[estacionIndex].toStringAsFixed(6)} '),
      ));

      double productoColumna3 = columna3[estacionIndex];
      cells.add(DataCell(
        Text(productoColumna3.toStringAsFixed(6)),
      ));

      double angulo = productoColumna3.floorToDouble();
      double minutos = ((productoColumna3 - angulo + 0.00000001) * 60).floorToDouble();
      double segundos = ((productoColumna3 - angulo - (minutos / 60)) * 3600);
      String segundosFormateados = segundos.toStringAsFixed(1);
      cells.add(DataCell(
        Text('$angulo° $minutos\' $segundosFormateados"'),
      ));

      cells.add(DataCell(
        Text('${columna5[estacionIndex].toStringAsFixed(6)} '),
      ));

      double angle = columna5[estacionIndex].floorToDouble();
      double minute = ((columna5[estacionIndex] - angle + 0.00000001) * 60).floorToDouble();
      double second = ((columna5[estacionIndex] - angle - (minute / 60)) * 3600);
      String seconds = second.toStringAsFixed(1);
      cells.add(DataCell(
        Text('$angle° $minute\' $seconds" '),
      ));

      double diferenciaE = sin((columna5[estacionIndex] * pi) / 180) * estacion.distancia;
      cells.add(DataCell(
        Text('${diferenciaE.toStringAsFixed(4)}'),
      ));
      double diferenciaN = cos((columna5[estacionIndex] * pi) / 180) * estacion.distancia;
      cells.add(DataCell(
        Text('${diferenciaN.toStringAsFixed(4)}'),
      ));

      widget.diffE += diferenciaE;
      widget.diffN += diferenciaN;

      distanciaE += diferenciaE;
      distanciaN += diferenciaN;
      widget.misclosure += diferenciaN;
      columna5.add(widget.misclosure);

      cells.add(DataCell(
        Text('${distanciaE.toStringAsFixed(4)}'),
      ));

      distanciaN += diferenciaN;
      cells.add(DataCell(
        Text('${distanciaN.toStringAsFixed(4)}'),
      ));

      cells.add(DataCell(
        Text('${(distanciaAdj + distanciaE * widget.adj).toStringAsFixed(4)}'),
      ));

      cells.add(DataCell(
        Text('${(distanciaAdj2 + distanciaN * widget.adj).toStringAsFixed(4)}'),
      ));

      cells.add(DataCell(
        Text('${(widget.datosEstacion1['easting1'] - distanciaAdj + distanciaE * widget.adj).toStringAsFixed(4)}'),
      ));

      cells.add(DataCell(
        Text('${(widget.datosEstacion1['northing1'] - distanciaAdj2 + distanciaN * widget.adj).toStringAsFixed(4)}'),
      ));

      rows.add(DataRow(cells: cells));
    }

    return rows;
  }


  double miscSeg(double meas) {
    double angulo1 = widget.datosEstacion2['angulo1'] ?? 0;
    double minutos1 = widget.datosEstacion2['minutos1'] ?? 0;
    double segundos1 = widget.datosEstacion2['segundos1'] ?? 0;
    double anguloInicial = angulo1 + (minutos1 / 60) + (segundos1 / 3600);
    double diff = meas - anguloInicial ;

    if (diff > 180) {
      return (diff - 360) * 3600;
    } else if (diff < -180) {
      return (diff + 360) * 3600;
    } else {
      return diff * 3600;
    }
  }
  double CalAdj ( double misc){
    double adj=0;
    adj= -1*(misc/widget.estaciones.length);



    return adj;
  }

  List<double> _calcularDatosEspecialesPrimeraEstacion() {

    double angulo1 = widget.datosEstacion1['angulo1'] ?? 0;
    double minutos1 = widget.datosEstacion1['minutos1'] ?? 0;
    double segundos1 = widget.datosEstacion1['segundos1'] ?? 0;



    double anguloInicial = angulo1 + (minutos1 / 60) + (segundos1 / 3600);


    double suma = anguloInicial;


    if (widget.estaciones.isNotEmpty &&
        widget.estaciones.first.esEstacionInicial) {
      suma += widget.estaciones.first.calcularSuma();
    }


    if (suma >= 360) {
      return [suma - 360];
    } else {
      return [suma];
    }
  }

  double _calcularDatosEntreEstaciones( double resultadoPrimeraEstacion, Estacion estacionActual) {
    double sumaActual = estacionActual.calcularSuma();



    double resultado =
        sumaActual + resultadoPrimeraEstacion;


    if (resultado - 180 <= 0) {
      resultado += 180;
    } else {
      if (resultado - 180 >= 360) {
        resultado -= 540;
      } else {
        resultado -= 180;
      }
    }

    return resultado;
  }


  // Función para calcular la columna 5
  List<double> _calcularDatosColumna5(List<double> columna3) {



    double angulo1 = widget.datosEstacion1['angulo1'] ?? 0;
    double minutos1 = widget.datosEstacion1['minutos1'] ?? 0;
    double segundos1 = widget.datosEstacion1['segundos1'] ?? 0;

    double anguloInicial = angulo1 + (minutos1 / 60) + (segundos1 / 3600);
    double suma = anguloInicial;

    List<double> datosColumna5 = [];

    for (int i = 0; i < columna3.length; i++) {

      double resultado;

      if (i == 0) {

        resultado = columna3[i];
        if (resultado + anguloInicial>= 360) {
          resultado= (resultado+ anguloInicial)- 360;
        }
      } else {

        double sumaActual = columna3[i];
        resultado = suma + sumaActual;

        if (resultado - 180 <= 0) {
          resultado += 180;
        } else {
          if (resultado - 180 >= 360) {
            resultado -= 540;
          } else {
            resultado -= 180;
          }
        }
      }


      datosColumna5.add(resultado);

      suma = resultado;
    }

    return datosColumna5;
  }





  double calcularSumaDistancias(List<Estacion> estaciones) {
    double sumaDistancias = 0;

    for (Estacion estacion in estaciones) {
      sumaDistancias += estacion.distancia;
    }

    return sumaDistancias;
  }

  double calcularSumaAngulos(List<Estacion> estaciones) {
    double sumaAngulos = 0;

    for (Estacion estacion in estaciones) {
      // Convierte a grados
      double angulo = estacion.angulo +
          estacion.minutos / 60 +
          estacion.segundos / 3600;

      sumaAngulos += angulo;
    }

    return sumaAngulos;
  }
}
