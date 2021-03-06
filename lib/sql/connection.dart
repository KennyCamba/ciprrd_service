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

    Future delete(String path) async{
      return deleteDatabase(join(await getDatabasesPath(), path));
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
                  username TEXT,
                  email TEXT,
                  firstname TEXT,
                  lastname TEXT,
                  login BOOL,
                  rol TEXT
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
          db.execute("INSERT INTO MoonPhase(moonPhaseName) VALUES('Cuadratura')", );
          db.execute("INSERT INTO MoonPhase(moonPhaseName) VALUES('Sicigia')", );
          db.execute("insert into Period(periodHour)	values('07:00')", );
          db.execute("insert into Period(periodHour)	values('07:30')", );
          db.execute("insert into Period(periodHour)	values('08:00')", );
          db.execute("insert into Period(periodHour)	values('08:30')", );
          db.execute("insert into Period(periodHour)	values('09:00')", );
          db.execute("insert into Period(periodHour)	values('09:30')", );
          db.execute("insert into Period(periodHour)	values('10:00')", );
          db.execute("insert into Period(periodHour)	values('10:30')", );
          db.execute("insert into Period(periodHour)	values('11:00')", );
          db.execute("insert into Period(periodHour)	values('11:30')", );
          db.execute("insert into Period(periodHour)	values('12:00')", );
          db.execute("insert into Period(periodHour)	values('12:30')", );
          db.execute("insert into Period(periodHour)	values('13:00')", );
          db.execute("insert into Period(periodHour)	values('13:30')", );
          db.execute("insert into Period(periodHour)	values('14:00')", );
          db.execute("insert into Period(periodHour)	values('14:30')", );
          db.execute("insert into Period(periodHour)	values('15:00')", );
          db.execute("insert into Period(periodHour)	values('15:30')", );
          db.execute("insert into Period(periodHour)	values('16:00')", );
          db.execute("insert into Period(periodHour)	values('16:30')", );
          db.execute("insert into Period(periodHour)	values('17:00')", );
          db.execute("insert into Period(periodHour)	values('17:30')", );
          db.execute("insert into Period(periodHour)	values('18:00')", );
          db.execute("insert into Period(periodHour)	values('18:30')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('El Oro')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('Esmeraldas')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('Galápagos')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('Guayas')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('Manabí')", );
          db.execute("INSERT INTO Province(provinceName) VALUES('Santa Elena')", );
          db.execute("INSERT INTO State(stateName) VALUES('Activated')", );
          db.execute("INSERT INTO State(stateName) VALUES('Removed')", );
          db.execute("INSERT INTO State(stateName) VALUES('Pending')", );
          db.execute("INSERT INTO State(stateName) VALUES('Checking')", );
          db.execute("INSERT INTO State(stateName) VALUES('Approved')", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Machala', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Arenillas', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Atahualpa', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Balsas', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Chilla', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('El Guabo', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Huaquillas', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Las Lajas', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Marcabelí', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Pasaje', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Piñas', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Portovelo', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Santa Rosa', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Zaruma', 1)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Esmeraldas', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Atacames', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Eloy Alfaro', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Muisne', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Quinindé', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Rioverde', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('San Lorenzo', 2)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('San Cristóbal', 3)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Isabela', 3)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Santa Cruz', 3)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Guayaquil', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Alfredo Baquerizo Moreno', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Balao', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Balzar', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Colimes', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Daule', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Durán', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('El Empalme', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('El Triunfo', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('General Antonio Elizalde', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Isidro Ayora', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Lomas de Sargentillo', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Marcelino Maridueña', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Milagro', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Naranjal', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Naranjito', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Nobol', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Palestina', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Pedro Carbo', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Playas', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Salitre', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Samborondón', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Santa Lucía', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Simón Bolívar', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Yaguachi', 4)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Portoviejo', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('24 de Mayo', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Bolívar', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Chone', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('El Carmen', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Flavio Alfaro', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Jama', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Jaramijó', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Jipijapa', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Junín', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Manta', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Montecristi', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Olmedo', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Paján', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Pedernales', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Pichincha', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Puerto López', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Rocafuerte', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('San Vicente', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Santa Ana', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Sucre', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Tosagua', 5)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Santa Elena', 6)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('La Libertad', 6)", );
          db.execute("INSERT INTO Canton(cantonName, provinceID) VALUES('Salinas', 6)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Retiro', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Cambio', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Providencia', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Machala', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto Bolívar', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Nueve de Mayo', 1)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Carcabón', 2)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chacras', 2)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Palmales', 2)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ayapamba', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cordoncillo', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Milagro', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San José', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Juan de Cerro Azul', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Paccha', 3)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bellamaría', 4)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chilla', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Carabota', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Casacay', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Challiguro', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chucacay', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cune', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Dumari', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Cedro', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Gallo Cantana', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Luz de América', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Nudillo', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pacay', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pacayunga', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pano', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pejeyacu', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Playas de Daucay', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Playas de San Tin Tin', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pueblo Viejo', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Quera Alto', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Shiguil', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Shiquil', 5)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Barbones', 6)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Iberia', 6)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Río Bonito', 6)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tendales', 6)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ecuador', 7)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Paraíso', 7)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Hualtaco', 7)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Milton Reyes', 7)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Unión Lojana', 7)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Paraíso', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Libertad', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Isidro', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Victoria', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Platanillos', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Valle Hermoso', 8)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Ingenio', 9)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Buenavista', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cañaquemada', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Casacay', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Peaña', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Progreso', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Uzhcurrumi', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bolívar', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Loma de Franco', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ochoa León', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tres Cerritos', 10)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Capiro', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Bocana', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Moromoro', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Piedras', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Roque', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Saracay', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Matriz', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Susaya', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Piñas Grande', 11)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Curtincapa', 12)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Morales', 12)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Salatí', 12)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bellamaría', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bellavista', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jambelí', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Avanzada', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Antonio', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Torata', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Victoria', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Balneario Jambelí', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jumón', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Nuevo Santa Rosa', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto Jelí', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rosa', 13)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Abañín', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Arcapamba', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Guanazán', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Guizhaguiña', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Huertas', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Malvas', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Muluncay Grande', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Sinsao', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Salvias', 14)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Camarones', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Coronel Carlos Concha Torres', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chinca', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Majua', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Mateo', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tabiazo', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tachina', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Vuelta Larga', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('5 de Agosto', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bartolomé Ruiz', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Esmeraldas', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Luis Tello', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Simón Plata Torres', 15)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Unión', 16)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Súa', 16)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tonchigüe', 16)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tonsupa', 16)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Anchayacu', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Atahualpa', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Borbón', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Colón Eloy del María', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Tola', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Luis Vargas Torres', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Maldonado', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pampanal de Bolívar', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Francisco de Onzole', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San José de Cayapas', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santo Domingo de Onzole', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Lucía de las Peñas', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Selva Alegre', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Telembí', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Timbiré', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Valdez', 17)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bolívar', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Daule', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Galera', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Quingue', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Salima', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Francisco', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Gregorio', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Jose de Chamanga', 18)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cube', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chura', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Unión', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Malimpia', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Viche', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Rosa Zárate', 19)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chontaduro', 20)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chumundé', 20)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Lagarto', 20)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Montalvo', 20)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Rocafuerte', 20)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('5 de Junio', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Alto Tambo', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ancón', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Calderón', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Carondelet', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Concepción', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Mataje', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Javier de Cachaví', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rita', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tambillo', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tululbí', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Urbina', 21)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Española', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Fe', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Genovesa', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Progreso', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Floreana', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto Baquerizo Moreno', 22)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Isla Charles Darwin', 23)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Fernandina', 23)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Teodoro Wolf', 23)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tomás de Berlanga', 23)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto Villamil', 23)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bellavista', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Baltra', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Marchena', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pinta', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pinzón', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Rábida', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santiago', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Seymou', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rosa', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto Ayora', 24)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Juan Gómez Rendón', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Morro', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Posorja', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puná', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tenguel', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ayacucho', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bolívar', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Carbo', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Febres Cordero', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('García Moreno', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Letamendi', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Nueve de Octubre', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Olmedo', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Roca', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Rocafuerte', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Sucre', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tarqui', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Urdaneta', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ximena', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pascuales', 25)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jujan', 26)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Alfredo Baquerizo Moreno', 26)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Balao', 27)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Balzar', 28)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Jacinto', 29)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Juan Bautista Aguirre', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Laurel', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Limonal', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Los Lojas', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Daule', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Aurora', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Banife', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Emiliano Caicedo Marcos', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Magro', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Padre Juan Bautista Aguirre', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Clara', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Vicente Piedrahita', 30)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Eloy Alfaro', 31)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Recero', 31)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Guayas', 32)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Rosario. Velasco Ibarra', 32)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Triunfo', 33)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bucay', 34)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Antonio Elizalde)', 34)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Isidro Ayora', 35)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES(' Lomas de Sargentillo', 36)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Coronel Marcelino Maridueña', 37)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chobo', 38)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Mariscal Sucre', 38)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Roberto Astudillo', 38)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jesús María', 39)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Carlos', 39)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rosa de Flandes', 39)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Taura', 39)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Naranjito', 40)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Narcisa de Jesús', 41)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Palestina', 42)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Valle de La Virgen', 43)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Sabanilla', 43)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Villamil', 44)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Vernaza', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Victoria', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Junquillal', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bocana', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Candilejos', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Central', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Paraíso', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Mateo', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Salitre', 45)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Samborondón', 46)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Puntilla', 46)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tarifa', 46)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Lucía', 47)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Coronel Lorenzo de Garaicoa', 48)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Simón Bolívar', 48)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Pedro J. Montero', 49)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Yaguachi Viejo', 49)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Virgen de Fátima', 49)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Jacinto de Yaguachi', 49)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Alhajuela', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Calderón', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chirijos', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Crucita', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pueblo Nuevo', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Riochico', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Plácido', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Portoviejo', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('12 de Marzo', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Colón', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Picoazá', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Pablo', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Andrés de Vera', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Francisco Pacheco', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('18 de Octubre', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Simón Bolívar', 50)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bellavista', 51)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Noboa', 51)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Arquitecto Sixto Durán Ballén', 51)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Sucre', 51)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Membrillo', 52)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Quiroga', 52)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Calceta', 52)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Boyacá', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Canuto', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chibunga', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Convento', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Eloy Alfaro', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ricaurte', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Antonio', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chone', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rita', 53)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Wilfrido Loor Moreira', 54)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Pedro de Suma', 54)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Carmen', 54)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('4 de Diciembre', 54)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Francisco de Novillo', 55)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Zapallo', 55)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jama', 56)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Jaramijó', 57)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('América', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Anegado', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Julcuy', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Unión', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Membrillal', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pedro Pablo Gómez', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Puerto de Cayo', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Doctor Miguel Morán Lucio', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Manuel Inocencio Parrales y Guale', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Lorenzo de Jipijapa', 58)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Junín', 59)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Lorenzo', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Marianita', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Los Estero', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Manta', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Mateo', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Tarqui', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Eloy Alfaro', 60)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Pila', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Aníbal San Andrés', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Montecristi', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('El Colorado', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Eloy Alfaro', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Leonidas Proaño', 61)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Olmedo', 62)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Campozano', 63)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cascol', 63)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Guale', 63)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Lascano', 63)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Cojimíes', 64)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('10 de Agosto', 64)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Atahualpa', 64)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Barraganete', 65)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Sebastián', 65)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Pichincha', 65)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Machalilla', 66)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Salango', 66)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Rocafuerte', 67)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Canoa', 68)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ayacucho', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Honorato Vásquez', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('La Unión', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Pablo', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Ana', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Lodana', 69)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Charapotó', 70)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San Isidro', 70)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bahía de Caráquez', 70)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Leonidas Plaza Gutiérrez', 70)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Bachillerato', 71)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Angel Pedro Giler', 71)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES(' Atahualpa', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Colonche', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Chanduy', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Manglaralto', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Simón Bolívar', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('San José de Ancón', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Ballenita', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Elena', 72)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Libertad', 73)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Anconcito', 74)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('José Luis Tamayo', 74)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Carlos Espinoza Larrea', 74)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('General Alberto Enríquez Gallo', 74)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Vicente Rocafuerte', 74)", );
          db.execute("INSERT INTO Parish(parishName, cantonID) VALUES('Santa Rosa', 74)", );
          db.execute("INSERT INTO BreakerType(breakerTypeID, breakerTypeName) VALUES('spi', 'Spilling')", );
          db.execute("INSERT INTO BreakerType(breakerTypeID, breakerTypeName) VALUES('plu', 'Plunging')", );
          db.execute("INSERT INTO BreakerType(breakerTypeID, breakerTypeName) VALUES('s-p', 'Spilling-Plunging')", );
          db.execute("INSERT INTO BreakerType(breakerTypeID, breakerTypeName) VALUES('coll', 'Collopsing')", );
          return db.execute("INSERT INTO BreakerType(breakerTypeID, breakerTypeName) VALUES('sur', 'Surging')", );
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }

}