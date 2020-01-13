clase = """Measurement
  int measurementID;
  final Observation observationID;
  final DateTime registeredTo;
  Period periodID;
  final bool hangoverCurrent;
  final double latitude;
  final double longitude;
  final double temp;
  final int beachOrientation;
  final double wideSurfArea;
  final int distanceLPFloat;
  final int distanceLPBreaker;
  final double csSpace;
  final int csTime;
  final double csSpeed;
  final String csDirection;
  final int windDirection;
  final double windSpeed;
  final int waveOrthogonal;
  final int waveApproachAngle;
  BreakerType breakerTypeID;
  final int timeElapsed;
  final double averagePeriod;
  final double averageWaveHeight;
  State stateID;"""

objetos = clase.split("\n")
i = 0
var = objetos[0] + "("
print(var)
for o in objetos[1:]:
    var1 = o.split(" ")[-1].replace(";", "");
    var += var1 + ": maps[i]" + "['" + var1 + "']"
    if i < len(objetos) - 2:
        var = var + ", "
    i += 1
print(var + ")")

