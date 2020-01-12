import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';



class Connection {

    Future<Database> database;
    static Connection instance = new Connection();

    Connection();

    static Connection getInstance(){
      return instance;
    }

    Future open(String path) async {
      database = openDatabase(
        // Set the path to the database.
        join(await getDatabasesPath(), path),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          db.execute(
            """CREATE TABLE Province(
                provinceID INTEGER PRIMARY KEY,
                provinceName TEXT
                )""",
          );
          db.execute(
            """CREATE TABLE Canton(
                cantonID INTEGER PRIMARY KEY,
                cantonName TEXT,
                provinceID INTEGER NOT NULL,
                CONSTRAINT FK_ProvinceCanton FOREIGN KEY(provinceID) REFERENCES Province(provinceID)
                )""",
          );
          db.execute(
            """CREATE TABLE Parish(
                  parishID INTEGER PRIMARY KEY,
                  parishName TEXT,
                  cantonID INTEGER NOT NULL,
                  CONSTRAINT  FK_CantonParish
                  FOREIGN KEY(cantonID) REFERENCES Canton(cantonID)
                  )""",
          );
          db.execute(
            """CREATE TABLE State (
                  stateID INTEGER PRIMARY KEY,
                  stateName TEXT
                  )""",
          );
          db.execute(
            """CREATE TABLE Station (
                  stationID INTEGER PRIMARY KEY,
                  stationName TEXT,
                  latitude DOUBLE,
                  longitude DOUBLE,
                  referencePoints TEXT,
                  stationPhoto TEXT,
                  parishID INTEGER NOT NULL,
                  stateID INTEGER NOT NULL DEFAULT(1),
                  CONSTRAINT FK_ParishStation
                  FOREIGN KEY (parishID) REFERENCES Parish(parishID),
                  CONSTRAINT FK_StateStation
                  FOREIGN KEY (stateID) REFERENCES State(stateID)
                  )""",
          );
          db.execute(
            """CREATE TABLE MoonPhase (
                  moonPhaseID INTEGER PRIMARY KEY,
                  moonPhaseName TEXT
                  )""",
          );
          db.execute(
            """CREATE TABLE User(
                  userID INTEGER PRIMARY KEY,
                  username TEXT
                  )""",
          );
          db.execute(
            """CREATE TABLE Observation (
                  observationID INTEGER AUTO_INCREMENT PRIMARY KEY,
                  observationDate DATE,
                  observationSeason TEXT,
                  userID INTEGER NOT NULL,
                  moonPhaseID INTEGER NOT NULL,
                  stationID INTEGER NOT NULL,
                  stateID INTEGER NOT NULL DEFAULT(3),
                  registeredTo DATETIME NOT NULL,
                  CONSTRAINT FK_UserObservation
                  FOREIGN KEY (userID) REFERENCES User(userID),
                  CONSTRAINT FK_MoonPhaseObservation
                  FOREIGN KEY (moonPhaseID) REFERENCES MoonPhase(moonPhaseID),
                  CONSTRAINT FK_StationObservation
                  FOREIGN KEY (stationID) REFERENCES Station(stationID),
                  CONSTRAINT FK_StateObservation
                  FOREIGN KEY (stateID) REFERENCES State(stateID)
                  )""",
          );
          db.execute(
            """CREATE TABLE BreakerType (
                  breakerTypeID VARCHAR(5) PRIMARY KEY,
                  breakerTypeName TEXT)""",
          );
          db.execute(
            """CREATE TABLE Period (
                  periodID INTEGER PRIMARY KEY,
                  periodHour TIME
                  )""",
          );
          db.execute(
            """CREATE TABLE Measurement (
                  measurementID INTEGER AUTO_INCREMENT PRIMARY KEY,
                  observationID INTEGER NOT NULL,
                  registeredTo DATETIME NOT NULL,
                  periodID INTEGER NOT NULL,
                  hangoverCurrent BOOL,
                  latitude DOUBLE,
                  longitude DOUBLE,
                  temp FLOAT,
                  beachOrientation INTEGER,
                  wideSurfArea FLOAT,
                  distanceLPFloat INTEGER,
                  distanceLPBreaker INTEGER,
                  csSpace FLOAT,
                  csTime INTEGER,
                  csSpeed FLOAT,
                  csDirection TEXT,
                  windDirection INTEGER,
                  windSpeed FLOAT,
                  waveOrthogonal INTEGER,
                  waveApproachAngle INTEGER,
                  breakerTypeID TEXT NOT NULL,
                  timeElapsed INTEGER,
                  averagePeriod FLOAT,
                  averageWaveHeight FLOAT,
                  stateID INTEGER NOT NULL DEFAULT(3),
                  CONSTRAINT FK_ObservationMeasurement
                  FOREIGN KEY(observationID) REFERENCES Observation(observationID),
                  CONSTRAINT FK_PeriodMeasurement
                  FOREIGN KEY(periodID) REFERENCES Period(periodID),
                  CONSTRAINT FK_BreakerTypeMeasurement
                  FOREIGN KEY(breakerTypeID) REFERENCES BreakerType(breakerTypeID),
                  CONSTRAINT FK_StateMeasurement
                  FOREIGN KEY (stateID) REFERENCES State(stateID)
                  )""",
          );
          db.execute(
            """CREATE TABLE BreakingHeight(
                  breakingHeightID INTEGER AUTO_INCREMENT PRIMARY KEY,
                  numeral INTEGER,
                  heightValue FLOAT,
                  measurementID INTEGER NOT NULL,
                  stateID INTEGER NOT NULL DEFAULT(3),
                  CONSTRAINT FK_MeasurBreakingHeight
                  FOREIGN KEY(measurementID) REFERENCES Measurement(measurementID),
                  CONSTRAINT FK_StateBreakingHeight
                  FOREIGN KEY (stateID) REFERENCES State(stateID)
                  )""",
          );
          return db.execute(
            """INSERT INTO Moonphase(moonPhaseName) VALUES('Cuadratura');
               INSERT INTO Moonphase(moonPhaseName) VALUES('Sicigia');
               insert into Period(Period.periodHour)	values('07:00');
                insert into Period(Period.periodHour)	values('07:30');
                insert into Period(Period.periodHour)	values('08:00');
                insert into Period(Period.periodHour)	values('08:30');
                insert into Period(Period.periodHour)	values('09:00');
                insert into Period(Period.periodHour)	values('09:30');
                insert into Period(Period.periodHour)	values('10:00');
                insert into Period(Period.periodHour)	values('10:30');
                insert into Period(Period.periodHour)	values('11:00');
                insert into Period(Period.periodHour)	values('11:30');
                insert into Period(Period.periodHour)	values('12:00');
                insert into Period(Period.periodHour)	values('12:30');
                insert into Period(Period.periodHour)	values('13:00');
                insert into Period(Period.periodHour)	values('13:30');
                insert into Period(Period.periodHour)	values('14:00');
                insert into Period(Period.periodHour)	values('14:30');
                insert into Period(Period.periodHour)	values('15:00');
                insert into Period(Period.periodHour)	values('15:30');
                insert into Period(Period.periodHour)	values('16:00');
                insert into Period(Period.periodHour)	values('16:30');
                insert into Period(Period.periodHour)	values('17:00');
                insert into Period(Period.periodHour)	values('17:30');
                insert into Period(Period.periodHour)	values('18:00');
                insert into Period(Period.periodHour)	values('18:30');

               """,
          );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }

}