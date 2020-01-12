clase = """Station
  final int stationID;
  String stationName;
  double latitude;
  double longitude;
  String referencePoints;
  String stationPhoto;
  Parish parishID;"""

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

