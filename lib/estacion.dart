class Estacion {
  num angulo;
  num minutos=0;
  num segundos=0;
  num distancia=0;

  bool esEstacionInicial;
  bool esEstacionFinal;

  Estacion({
    required this.angulo,
    required this.minutos,
    required this.segundos,

    this.esEstacionInicial = false,
    this.esEstacionFinal = false,
    required this.distancia,
  }) : assert(angulo != null),
        assert(minutos != null),
        assert(segundos != null),

        assert(esEstacionInicial != null),
        assert(esEstacionFinal != null),
        assert(distancia != null);
  double calcularSuma() {
    return angulo + minutos / 60 + segundos / 3600;
  }

  double calcularAnguloTotal(List<Estacion> estaciones, int indiceActual) {
    double anguloTotal = 0;

    int indiceEstacionInicial =
    estaciones.indexWhere((estacion) => estacion.esEstacionInicial);
    int indiceEstacionFinal =
    estaciones.indexWhere((estacion) => estacion.esEstacionFinal);

    if (indiceEstacionInicial != -1 && indiceEstacionFinal != -1) {
      for (int i = indiceEstacionInicial; i != indiceEstacionFinal; i = (i + 1) % estaciones.length) {
        anguloTotal += estaciones[i].calcularSuma();
      }
      anguloTotal += estaciones[indiceEstacionFinal].calcularSuma();
    }

    if (anguloTotal >= 360) {
      anguloTotal -= 360;
    }

    return anguloTotal;
  }
}