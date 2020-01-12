import 'package:ciprrd_service/sql/connection.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class Model {

  external Map<String, dynamic> toMap();

  Future<int> save() async{
    final Database db = await Connection.getInstance().database;
    return await db.insert(
      this.runtimeType.toString(),
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> query(String table, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final Database db = await Connection.getInstance().database;
    return await db.query(table, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
  }
}

class Province extends Model{
  final int provinceID;
  String provinceName;

  Province({this.provinceID, this.provinceName});

  @override
  Map<String, dynamic> toMap(){
    return {
      "provinceID": provinceID,
      "provinceName": provinceName
    };
  }
  
  static Future<List<Province>> objects(String query)async{
    final List<Map<String, dynamic>> maps = await Model.query("Provinces", );
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }

  static Future<List<Province>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async {
    final List<Map<String, dynamic>> maps = await Model.query("Province", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
        provinceID: maps[i]['provinceID'],
        provinceName: maps[i]['provinceName']
      );
    });
  }
}

class Canton extends Model{
  final int cantonID;
  String cantonName;
  Province provinceID;

  Canton({this.cantonID, this.cantonName, this.provinceID});

  @override
  Map<String, dynamic> toMap(){
    return {
      'cantonID': cantonID,
      'cantonName': cantonName,
      'provinceID': provinceID.provinceID
    };
  }

  static Future<List<Canton>> objects(String query) async{
    final List<Map<String, dynamic>> maps = await Model.query("Cantons", );
    List<Canton> cantones = new List<Canton>();
    for(int i=0; i< maps.length; i++){
      Canton canton = new Canton(cantonID: maps[i]['cantonID'], cantonName: maps[i]['cantonName']);
      canton.provinceID = (await Province.filter(where: "cantonID = ?", whereArgs: [maps[i]['provinceID']]))[0];
      cantones.add(canton);
    }
    return cantones;
  }
  
  static Future<List<Canton>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Canton", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<Canton> cantones = new List<Canton>();
    for(int i=0; i< maps.length; i++){
      Canton canton = new Canton(cantonID: maps[i]['cantonID'], cantonName: maps[i]['cantonName']);
      canton.provinceID = (await Province.filter(where: "provinceID = ?", whereArgs: [maps[i]['provinceID']]))[0];
      cantones.add(canton);
    }
    return cantones;
  }
}

class Parish extends Model{
  final int parishID;
  String parishName;
  Canton cantonID;

  Parish({this.parishID, this.parishName, this.cantonID});

  @override
  Map<String, dynamic> toMap(){
    return {
      'parishID': parishID,
      'parishName': parishName,
      'cantonID': cantonID.cantonID
    };
  }

  static Future<List<Parish>> objects(String query) async{
    final List<Map<String, dynamic>> maps = await Model.query("Parishs", );
    List<Parish> parishes = new List<Parish>();
    for(int i=0; i< maps.length; i++){
      Parish parish = new Parish(parishID: maps[i]['parishID'], parishName: maps[i]['parishName'], cantonID: maps[i]['cantonID']);
      parish.cantonID = (await Canton.filter(where: "cantonID = ?", whereArgs: [maps[i]['cantonID']]))[0];
      parishes.add(parish);
    }
    return parishes;
  }

  static Future<List<Parish>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Parish", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<Parish> parishes = new List<Parish>();
    for(int i=0; i< maps.length; i++){
      Parish parish = new Parish(parishID: maps[i]['parishID'], parishName: maps[i]['parishName'], cantonID: maps[i]['cantonID']);
      parish.cantonID = (await Canton.filter(where: "cantonID = ?", whereArgs: [maps[i]['cantonID']]))[0];
      parishes.add(parish);
    }
    return parishes;
  }
}

class Station extends Model{
  final int stationID;
  String stationName;
  double latitude;
  double longitude;
  String referencePoints;
  String stationPhoto;
  Parish parishID;

  Station({this.stationID, this.stationName, this.latitude, this.longitude,
      this.referencePoints, this.stationPhoto, this.parishID});

  @override
  Map<String, dynamic> toMap(){
    return {
      'stationID': stationID,
      'stationName': stationName,
      'latitude': latitude,
      'longitude': longitude,
      'referencePoints': referencePoints,
      'stationPhoto': stationPhoto,
      'parishID': parishID.parishID
    };
  }

  static Future<List<Station>> objects(String query) async{
    final List<Map<String, dynamic>> maps = await Model.query("Stations", );
    List<Station> stations = new List<Station>();
    for(int i=0; i< maps.length; i++){
      Station station = Station(stationID: maps[i]['stationID'], stationName: maps[i]['stationName'], latitude: maps[i]['latitude'], longitude: maps[i]['longitude'], referencePoints: maps[i]['referencePoints'], stationPhoto: maps[i]['stationPhoto']);
      station.parishID = (await Parish.filter(where: "parishID = ?", whereArgs: [maps[i]['parishID']]))[0];
      stations.add(station);
    }
    return stations;
  }

  static Future<List<Station>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Station", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);

    List<Station> stations = new List<Station>();
    for(int i=0; i< maps.length; i++){
      Station station = Station(stationID: maps[i]['stationID'], stationName: maps[i]['stationName'], latitude: maps[i]['latitude'], longitude: maps[i]['longitude'], referencePoints: maps[i]['referencePoints'], stationPhoto: maps[i]['stationPhoto']);
      station.parishID = (await Parish.filter(where: "parishID = ?", whereArgs: [maps[i]['parishID']]))[0];
      stations.add(station);
    }
    return stations;
  }
}

/*class State extends Model<State>{
  final int stateID;
  final String stateName;

  State(this.stateID, this.stateName);

  @override
  Map<String, dynamic> toMap(){
    return {
      'stateID': stateID,
      'stateName': stateName
    };
  }

  @override
  Future<List<State>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class MoonPhase extends Model<MoonPhase>{
  final int moonPhaseID;
  final String moonPhaseName;

  MoonPhase(this.moonPhaseID, this.moonPhaseName);

  @override
  Map<String, dynamic> toMap(){
    return {
      'moonPhaseID': moonPhaseID,
      'moonPhaseName': moonPhaseName
    };
  }

  @override
  Future<List<MoonPhase>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class BreakerType extends Model<BreakerType>{
  final String breakerTypeID;
  final String breakerTypeName;

  BreakerType(this.breakerTypeID, this.breakerTypeName);

  @override
  Map<String, dynamic> toMap(){
    return {
      'breakerTypeID': breakerTypeID,
      'breakerTypeName': breakerTypeName
    };
  }

  @override
  Future<List<BreakerType>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class Period extends Model<Period>{
  final int periodID;
  final DateTime periodHour;

  Period(this.periodID, this.periodHour);

  @override
  Map<String, dynamic> toMap(){
    return {
      'periodID': periodID,
      'periodHour': DateFormat("HH:mm:ss").format(periodHour)
    };
  }

  @override
  Future<List<Period>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class User extends Model<User>{
  final int userID;
  final String username;

  User(this.userID, this.username);

  @override
  Map<String, dynamic> toMap(){
    return {
      'userID': userID,
      'username': username
    };
  }

  @override
  Future<List<User>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class Observation extends Model<Observation>{
  int observationID;
  final DateTime observationDate;
  final String observationSeason;
  final User userID;
  final MoonPhase moonPhaseID;
  final Station stationID;
  State stateID;
  final DateTime registeredTo;

  Observation(this.observationID, this.observationDate, this.observationSeason,
      this.userID, this.moonPhaseID, this.stationID, this.stateID,
      this.registeredTo);

  @override
  Map<String, dynamic> toMap(){
    return {
      'observationDate': DateFormat("yyyy-MM-dd").format(observationDate),
      'observationSeason': observationSeason,
      'userID': userID.userID,
      'moonPhaseID': moonPhaseID.moonPhaseID,
      'stationID': stationID.stationID,
      'registeredTo': DateFormat("yyyy-MM-dd HH:mm:ss").format(registeredTo)
    };
  }

  @override
  Future<List<Observation>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class Measurement extends Model<Measurement>{
  int measurementID;
  final Observation observationID;
  final DateTime registeredTo;
  final Period periodID;
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
  final BreakerType breakerTypeID;
  final int timeElapsed;
  final double averagePeriod;
  final double averageWaveHeight;
  State stateID;

  Measurement(this.measurementID, this.observationID, this.registeredTo,
      this.periodID, this.hangoverCurrent, this.latitude, this.longitude,
      this.temp, this.beachOrientation, this.wideSurfArea, this.distanceLPFloat,
      this.distanceLPBreaker, this.csSpace, this.csTime, this.csSpeed,
      this.csDirection, this.windDirection, this.windSpeed,
      this.waveOrthogonal, this.waveApproachAngle, this.breakerTypeID,
      this.timeElapsed, this.averagePeriod, this.averageWaveHeight,
      this.stateID);

  @override
  Map<String, dynamic> toMap(){
    return {
      'observationID': observationID.observationID,
      'registeredTo': DateFormat("yyyy-MM-dd HH:mm:ss").format(registeredTo),
      'periodID': periodID.periodID,
      'hangoverCurrent': hangoverCurrent,
      'latitude': latitude,
      'longitude': longitude,
      'temp': temp,
      'beachOrientation': beachOrientation,
      'wideSurfArea': wideSurfArea,
      'distanceLPFloat': distanceLPFloat,
      'distanceLPBreaker': distanceLPBreaker,
      'csSpace': csSpace,
      'csTime': csTime,
      'csSpeed': csSpeed,
      'csDirection': csDirection,
      'windDirection': windDirection,
      'windSpeed': windSpeed,
      'waveOrthogonal': waveOrthogonal,
      'waveApproachAngle': waveApproachAngle,
      'breakerTypeID': breakerTypeID.breakerTypeID,
      'timeElapsed': timeElapsed,
      'averagePeriod': averagePeriod,
      'averageWaveHeight': averageWaveHeight,
    };
  }

  @override
  Future<List<Measurement>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}

class BreakingHeight extends Model<BreakingHeight>{
  final int breakingHeightID;
  final int numeral;
  final double heightValue;
  final Measurement measurementID;
  State stateID;

  BreakingHeight(this.breakingHeightID, this.numeral, this.heightValue,
      this.measurementID, this.stateID);

  @override
  Map<String, dynamic> toMap(){
    return {
      'numeral': numeral,
      'heightValue': heightValue,
      'measurementID': measurementID.measurementID
    };
  }

  @override
  Future<List<BreakingHeight>> objects(String query, {bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await this.query(query, distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    return List.generate(maps.length, (i) {
      return Province(
          provinceID: maps[i]['provinceID'],
          provinceName: maps[i]['provinceName']
      );
    });
  }
}*/
