import 'package:ciprrd_service/sql/connection.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class Model {

  var id;

  external Map<String, dynamic> toMap();

  Future<int> save() async{
    final Database db = await Connection.getInstance().database;
    return await db.insert(
      this.runtimeType.toString(),
      this.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update() async {
    final Database db = await Connection.getInstance().database;
    String table = this.runtimeType.toString();
    String id = table[0].toLowerCase() + table.substring(1, table.length) + "ID";
    return await db.update(
        table,
        this.toMap(),
        where: id + " = ?",
        whereArgs: [id],
    );
  }

  Future<int> delete() async {
    final Database db = await Connection.getInstance().database;
    String table = this.runtimeType.toString();
    String id = table[0].toLowerCase() + table.substring(1, table.length) + "ID";
    return await db.delete(
      table,
      where: id + " = ?",
      whereArgs: [id],
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

  Province({this.provinceID, this.provinceName}){
   super.id = this.provinceID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      "provinceID": provinceID,
      "provinceName": provinceName
    };
  }
  
  static Future<List<Province>> objects()async{
    final List<Map<String, dynamic>> maps = await Model.query("Province", );
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

  @override
  String toString() {
    return provinceName;
  }

}

class Canton extends Model{
  final int cantonID;
  String cantonName;
  Province provinceID;

  Canton({this.cantonID, this.cantonName, this.provinceID}){
    super.id = this.cantonID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'cantonID': cantonID,
      'cantonName': cantonName,
      'provinceID': provinceID.provinceID
    };
  }

  static Future<List<Canton>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Canton", );
    List<Canton> cantones = new List<Canton>();
    for(int i=0; i< maps.length; i++){
      Canton canton = new Canton(cantonID: maps[i]['cantonID'], cantonName: maps[i]['cantonName']);
      canton.provinceID = (await Province.filter(where: "provinceID = ?", whereArgs: [maps[i]['provinceID']]))[0];
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

  @override
  String toString() {
    return cantonName;
  }

}

class Parish extends Model{
  final int parishID;
  String parishName;
  Canton cantonID;

  Parish({this.parishID, this.parishName, this.cantonID}){
    super.id = this.parishID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'parishID': parishID,
      'parishName': parishName,
      'cantonID': cantonID.cantonID
    };
  }

  static Future<List<Parish>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Parish", );
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

  @override
  String toString() {
    return parishName;
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
  State stateID;

  Station({this.stationID, this.stationName, this.latitude, this.longitude,
      this.referencePoints, this.stationPhoto, this.parishID, this.stateID}){
      super.id = this.stationID;
  }

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

  static Future<List<Station>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Station", );
    List<Station> stations = new List<Station>();
    for(int i=0; i< maps.length; i++){
      Station station = Station(stationID: maps[i]['stationID'], stationName: maps[i]['stationName'], latitude: maps[i]['latitude'], longitude: maps[i]['longitude'], referencePoints: maps[i]['referencePoints'], stationPhoto: maps[i]['stationPhoto']);
      station.parishID = (await Parish.filter(where: "parishID = ?", whereArgs: [maps[i]['parishID']]))[0];
      station.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
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
      station.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      stations.add(station);
    }
    return stations;
  }

  @override
  String toString() {
    return stationName;
  }


}

class State extends Model{
  final int stateID;
  final String stateName;

  State({this.stateID, this.stateName}){
      super.id = this.stateID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'stateID': stateID,
      'stateName': stateName
    };
  }

  static Future<List<State>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("State", );
    List<State> states = new List<State>();
    for(int i=0; i< maps.length; i++){
      State state = new State(stateID: maps[i]["stateID"], stateName: maps[i]["stateName"]);
      states.add(state);
    }
    return states;
  }

  static Future<List<State>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("State", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<State> states = new List<State>();
    for(int i=0; i< maps.length; i++){
      State state = new State(stateID: maps[i]["stateID"], stateName: maps[i]["stateName"]);
      states.add(state);
    }
    return states;
  }
}

class MoonPhase extends Model{
  final int moonPhaseID;
  final String moonPhaseName;

  MoonPhase({this.moonPhaseID, this.moonPhaseName}){
    super.id = this.moonPhaseID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'moonPhaseID': moonPhaseID,
      'moonPhaseName': moonPhaseName
    };
  }

  static Future<List<MoonPhase>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("MoonPhase", );
    List<MoonPhase> moonPhases = new List<MoonPhase>();
    for(int i=0; i< maps.length; i++){
      MoonPhase moonPhase = new MoonPhase(moonPhaseID: maps[i]["moonPhaseID"], moonPhaseName: maps[i]["moonPhaseName"]);
      moonPhases.add(moonPhase);
    }
    return moonPhases;
  }

  static Future<List<MoonPhase>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("MoonPhase", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<MoonPhase> moonPhases = new List<MoonPhase>();
    for(int i=0; i< maps.length; i++){
      MoonPhase moonPhase = new MoonPhase(moonPhaseID: maps[i]["moonPhaseID"], moonPhaseName: maps[i]["moonPhaseName"]);
      moonPhases.add(moonPhase);
    }
    return moonPhases;
  }

  @override
  String toString() {
    return moonPhaseName;
  }
}

class BreakerType extends Model{
  final String breakerTypeID;
  final String breakerTypeName;

  BreakerType({this.breakerTypeID, this.breakerTypeName}){
    super.id = this.breakerTypeID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'breakerTypeID': breakerTypeID,
      'breakerTypeName': breakerTypeName
    };
  }

  static Future<List<BreakerType>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("BreakerType", );
    List<BreakerType> breakersType = new List<BreakerType>();
    for(int i=0; i< maps.length; i++){
      BreakerType breakerType = new BreakerType(breakerTypeID: maps[i]["breakerTypeID"], breakerTypeName: maps[i]["breakerTypeName"]);
      breakersType.add(breakerType);
    }
    return breakersType;
  }

  static Future<List<BreakerType>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("BreakerType", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<BreakerType> breakersType = new List<BreakerType>();
    for(int i=0; i< maps.length; i++){
      BreakerType breakerType = new BreakerType(breakerTypeID: maps[i]["breakerTypeID"], breakerTypeName: maps[i]["breakerTypeName"]);
      breakersType.add(breakerType);
    }
    return breakersType;
  }

  @override
  String toString() {
    return '$breakerTypeID ($breakerTypeName)';
  }


}

class Period extends Model{
  final int periodID;
  final DateTime periodHour;

  Period({this.periodID, this.periodHour}){
    super.id = this.periodID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'periodID': periodID,
      'periodHour': DateFormat("HH:mm:ss").format(periodHour)
    };
  }

  static Future<List<Period>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Period", );
    List<Period> periods = new List<Period>();
    for(int i=0; i< maps.length; i++){
      Period period = new Period(periodID: maps[i]["periodID"], periodHour: DateFormat("HH:mm").parse(maps[i]["periodHour"]));
      periods.add(period);
    }
    return periods;
  }

  static Future<List<Period>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Period", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<Period> periods = new List<Period>();
    for(int i=0; i< maps.length; i++){
      Period period = new Period(periodID: maps[i]["periodID"], periodHour: maps[i]["periodHour"]);
      periods.add(period);
    }
    return periods;
  }

  @override
  String toString() {
    return DateFormat("HH:mm:ss").format(periodHour);
  }
}

class User extends Model{
  final int userID;
  final String username;

  User({this.userID, this.username}){
    super.id = this.userID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'userID': userID,
      'username': username
    };
  }

  static Future<List<User>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("User", );
    List<User> users = new List<User>();
    for(int i=0; i< maps.length; i++){
      User user = new User(userID: maps[i]["userID"], username: maps[i]["userHour"]);
      users.add(user);
    }
    return users;
  }

  static Future<List<User>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("User", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<User> users = new List<User>();
    for(int i=0; i< maps.length; i++){
      User user = new User(userID: maps[i]["userID"], username: maps[i]["userHour"]);
      users.add(user);
    }
    return users;
  }
}

class Observation extends Model {
  int observationID;
  final DateTime observationDate;
  final String observationSeason;
  User userID;
  MoonPhase moonPhaseID;
  Station stationID;
  State stateID;
  final DateTime registeredTo;

  Observation({this.observationID, this.observationDate, this.observationSeason,
      this.userID, this.moonPhaseID, this.stationID, this.stateID,
      this.registeredTo}){
    super.id = this.observationID;
  }

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

  static Future<List<Observation>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Observation", );
    List<Observation> observations = new List<Observation>();
    for(int i=0; i< maps.length; i++){
      Observation observation = new Observation(observationID: maps[i]['observationID'], observationDate: maps[i]['observationDate'],
          observationSeason: maps[i]['observationSeason'], registeredTo: maps[i]['registeredTo']);
      observation.userID = (await User.filter(where: "userID = ?", whereArgs: [maps[i]['userID']]))[0];
      observation.moonPhaseID = (await MoonPhase.filter(where: "moonPhaseID = ?", whereArgs: [maps[i]['moonPhaseID']]))[0];
      observation.stationID = (await Station.filter(where: "stationID = ?", whereArgs: [maps[i]['stationID']]))[0];
      observation.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      observations.add(observation);
    }
    return observations;
  }

  static Future<List<Observation>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Observation", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<Observation> observations = new List<Observation>();
    for(int i=0; i< maps.length; i++){
      Observation observation = new Observation(observationID: maps[i]['observationID'], observationDate: maps[i]['observationDate'],
          observationSeason: maps[i]['observationSeason'], registeredTo: maps[i]['registeredTo']);
      observation.userID = (await User.filter(where: "userID = ?", whereArgs: [maps[i]['userID']]))[0];
      observation.moonPhaseID = (await MoonPhase.filter(where: "moonPhaseID = ?", whereArgs: [maps[i]['moonPhaseID']]))[0];
      observation.stationID = (await Station.filter(where: "stationID = ?", whereArgs: [maps[i]['stationID']]))[0];
      observation.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      observations.add(observation);
    }
    return observations;
  }
}

class Measurement extends Model{
  final int measurementID;
  Observation observationID;
  DateTime registeredTo;
  Period periodID;
  bool hangoverCurrent;
  double latitude;
  double longitude;
  double temp;
  int beachOrientation;
  double wideSurfArea;
  int distanceLPFloat;
  int distanceLPBreaker;
  double csSpace;
  int csTime;
  double csSpeed;
  String csDirection;
  int windDirection;
  double windSpeed;
  int waveOrthogonal;
  int waveApproachAngle;
  BreakerType breakerTypeID;
  int timeElapsed;
  double averagePeriod;
  double averageWaveHeight;
  State stateID;

  Measurement({this.measurementID, this.observationID, this.registeredTo,
      this.periodID, this.hangoverCurrent, this.latitude, this.longitude,
      this.temp, this.beachOrientation, this.wideSurfArea, this.distanceLPFloat,
      this.distanceLPBreaker, this.csSpace, this.csTime, this.csSpeed,
      this.csDirection, this.windDirection, this.windSpeed,
      this.waveOrthogonal, this.waveApproachAngle, this.breakerTypeID,
      this.timeElapsed, this.averagePeriod, this.averageWaveHeight,
      this.stateID}){
    super.id = this.measurementID;
  }

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

  static Future<List<Measurement>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("Measurement", );
    List<Measurement> measurements = new List<Measurement>();
    for(int i=0; i< maps.length; i++){
      Measurement measurement = new Measurement(measurementID: maps[i]['measurementID'], registeredTo: maps[i]['registeredTo'], hangoverCurrent: maps[i]['hangoverCurrent'],
          latitude: maps[i]['latitude'], longitude: maps[i]['longitude'], temp: maps[i]['temp'], beachOrientation: maps[i]['beachOrientation'],
          wideSurfArea: maps[i]['wideSurfArea'], distanceLPFloat: maps[i]['distanceLPFloat'], distanceLPBreaker: maps[i]['distanceLPBreaker'],
          csSpace: maps[i]['csSpace'], csTime: maps[i]['csTime'], csSpeed: maps[i]['csSpeed'], csDirection: maps[i]['csDirection'],
          windDirection: maps[i]['windDirection'], windSpeed: maps[i]['windSpeed'], waveOrthogonal: maps[i]['waveOrthogonal'],
          waveApproachAngle: maps[i]['waveApproachAngle'], timeElapsed: maps[i]['timeElapsed'], averagePeriod: maps[i]['averagePeriod'],
          averageWaveHeight: maps[i]['averageWaveHeight']);
      measurement.observationID = (await Observation.filter(where: "observationID = ?", whereArgs: [maps[i]['observationID']]))[0];
      measurement.periodID = (await Period.filter(where: "periodID = ?", whereArgs: [maps[i]['periodID']]))[0];
      measurement.breakerTypeID = (await BreakerType.filter(where: "breakerTypeID = ?", whereArgs: [maps[i]['breakerTypeID']]))[0];
      measurement.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      measurements.add(measurement);
    }
    return measurements;
  }

  static Future<List<Measurement>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("Measurement", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<Measurement> measurements = new List<Measurement>();
    for(int i=0; i< maps.length; i++){
      Measurement measurement = new Measurement(measurementID: maps[i]['measurementID'], registeredTo: maps[i]['registeredTo'], hangoverCurrent: maps[i]['hangoverCurrent'],
          latitude: maps[i]['latitude'], longitude: maps[i]['longitude'], temp: maps[i]['temp'], beachOrientation: maps[i]['beachOrientation'],
          wideSurfArea: maps[i]['wideSurfArea'], distanceLPFloat: maps[i]['distanceLPFloat'], distanceLPBreaker: maps[i]['distanceLPBreaker'],
          csSpace: maps[i]['csSpace'], csTime: maps[i]['csTime'], csSpeed: maps[i]['csSpeed'], csDirection: maps[i]['csDirection'],
          windDirection: maps[i]['windDirection'], windSpeed: maps[i]['windSpeed'], waveOrthogonal: maps[i]['waveOrthogonal'],
          waveApproachAngle: maps[i]['waveApproachAngle'], timeElapsed: maps[i]['timeElapsed'], averagePeriod: maps[i]['averagePeriod'],
          averageWaveHeight: maps[i]['averageWaveHeight']);
      measurement.observationID = (await Observation.filter(where: "observationID = ?", whereArgs: [maps[i]['observationID']]))[0];
      measurement.periodID = (await Period.filter(where: "periodID = ?", whereArgs: [maps[i]['periodID']]))[0];
      measurement.breakerTypeID = (await BreakerType.filter(where: "breakerTypeID = ?", whereArgs: [maps[i]['breakerTypeID']]))[0];
      measurement.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      measurements.add(measurement);
    }
    return measurements;
  }
}

class BreakingHeight extends Model{
  final int breakingHeightID;
  int numeral;
  double heightValue;
  Measurement measurementID;
  State stateID;

  BreakingHeight({this.breakingHeightID, this.numeral, this.heightValue,
      this.measurementID, this.stateID}){
    super.id = this.breakingHeightID;
  }

  @override
  Map<String, dynamic> toMap(){
    return {
      'numeral': numeral,
      'heightValue': heightValue,
      'measurementID': measurementID.measurementID
    };
  }

  static Future<List<BreakingHeight>> objects() async{
    final List<Map<String, dynamic>> maps = await Model.query("BreakingHeight", );
    List<BreakingHeight> breakingHeights = new List<BreakingHeight>();
    for(int i=0; i< maps.length; i++){
      BreakingHeight breakingHeight = BreakingHeight(breakingHeightID: maps[i]['breakingHeightID'], numeral: maps[i]['numeral'], heightValue: maps[i]['heightValue']);
      breakingHeight.measurementID = (await Measurement.filter(where: "measurementID = ?", whereArgs: [maps[i]['measurementID']]))[0];
      breakingHeight.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      breakingHeights.add(breakingHeight);
    }
    return breakingHeights;
  }

  static Future<List<BreakingHeight>> filter({bool distinct,
    List<String> columns,
    String where,
    List<dynamic> whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset}) async{
    final List<Map<String, dynamic>> maps = await Model.query("BreakingHeight", distinct: distinct, columns: columns,
        where: where, whereArgs: whereArgs, groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
    List<BreakingHeight> breakingHeights = new List<BreakingHeight>();
    for(int i=0; i< maps.length; i++){
      BreakingHeight breakingHeight = BreakingHeight(breakingHeightID: maps[i]['breakingHeightID'], numeral: maps[i]['numeral'], heightValue: maps[i]['heightValue']);
      breakingHeight.measurementID = (await Measurement.filter(where: "measurementID = ?", whereArgs: [maps[i]['measurementID']]))[0];
      breakingHeight.stateID = (await State.filter(where: "stateID = ?", whereArgs: [maps[i]['stateID']]))[0];
      breakingHeights.add(breakingHeight);
    }
    return breakingHeights;
  }
}
