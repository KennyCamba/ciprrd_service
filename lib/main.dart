import 'package:ciprrd_service/session/session.dart';
import 'package:ciprrd_service/sql/models.dart' as models;
import 'package:ciprrd_service/values/colors.dart';
import 'package:ciprrd_service/views/data.dart';
import 'package:ciprrd_service/views/home.dart';
import 'package:ciprrd_service/views/login.dart';
import 'package:ciprrd_service/views/map.dart';
import 'package:ciprrd_service/views/observation.dart';
import 'package:flutter/cupertino.dart';

import 'sql/connection.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  models.User user;

  void init() async{
    await Connection.getInstance().open("CIPRRDDB");
    user = await Session.getUser();
    if(user != null){
      print(user.login);
    }
    //await Connection.getInstance().delete("CIPRRDDB");
    //user = models.User(username: "kennyCamba", email: "kacamba@espol.edu.ec", firstname: "Kenny", lastname: "Camba", login: false, rol: "admin");
    //await user.save();
  }
  @override
  Widget build(BuildContext context){
    init();
    if(user != null && user.login){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Main',
        theme: ThemeData(
          primarySwatch: AppColors.app_theme,
        ),
        home: MainPage(title: 'Inicio', user: user,),
      );
    }else {
      return MaterialApp(
        title: 'Login',
        theme: ThemeData(
          primarySwatch: AppColors.app_theme,
        ),
        home: LoginPage(),
      );
    }

  }
}


class MainPage extends StatefulWidget {
  MainPage({Key key, this.title, this.user}) : super(key: key);

  String title;
  final models.User user;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedDrawerIndex = 0;
  _MainPageState();

  void _addObservation() {
    setState(() => _selectedDrawerIndex = 2);
  }

  Widget _getDrawerItemState(int pos){
    switch(pos){
      case 0:
        return new HomeFragment(widget.user);
      case 1:
        return new DataFragment();
      case 2:
        return new ObservationFragment();
      case 3:
        return new MapFragment();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index, String title){
    setState(() => _selectedDrawerIndex = index);
    setState(() => widget.title = title);
    Navigator.of(context).pop();
  }

  void logout(){
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Cierre de sesión"),
          content: new Text("¿Está seguro que desea cerrar sesión?"),
          actions: <Widget>[
            new FlatButton(onPressed:(){
              widget.user.login = false;
              widget.user.update();
              Navigator.pushReplacement(
                this.context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
                child: Text("Aceptar")
            ),
            new FlatButton(onPressed:(){
              Navigator.of(context).pop();
            },
                child: Text("Cancelar")
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    models.User user = widget.user;
    return Scaffold(
      backgroundColor: AppColors.app_theme.shade200,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.app_theme.shade800,
                image: DecorationImage(
                  image: new NetworkImage("https://cdn.wallpapersafari.com/88/47/FTGSmV.jpg"),
                  fit: BoxFit.fill,
                ),
                border: BorderDirectional(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 4.0
                  )
                ),
              ),
              accountName: Text(user.firstname.toUpperCase(), style: TextStyle(color: AppColors.app_theme.shade50, fontSize: 16),),
              accountEmail: Text(user.username + "\n" + user.rol,  style: TextStyle(color: AppColors.app_theme.shade50)),
              currentAccountPicture:
                CircleAvatar(
                  backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue: Colors.white,
                  child: Text(
                    user.username[0].toUpperCase(),
                    style:
                    TextStyle(
                        fontSize: 40.0
                    ),
                  ),
                ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.home, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Inicio'),
                ],
              ),
              onTap: () => _onSelectItem(0, "Inicio"),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.pie_chart, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Datos'),
                ],
              ),
              onTap: () => _onSelectItem(1, "Datos"),
            ),
            user.rol != "visited" ?
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.add, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Agregar Observación'),
                ],
              ),
              onTap: () => _onSelectItem(2, "Nueva Observación"),
            ) : Text("", style: TextStyle(fontSize: 0.0),),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.map, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Mapa'),
                ],
              ),
              onTap: () => _onSelectItem(3, "Mapa"),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.contact_mail, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Contáctanos'),
                ],
              ),
              onTap: () => _onSelectItem(4, "Contáctanos"),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              child: Text("Aplicación", style: TextStyle(color: Colors.grey, fontSize: 12.0,),),
              padding: EdgeInsets.only(left: 5.0),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.info_outline,),
                  SizedBox(width: 10,),
                  Text('Sobre nosotros'),
                ],
              ),
              onTap: () => _onSelectItem(5, "Sobre nosotros"),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.verified_user,),
                  SizedBox(width: 10,),
                  Text('Privacy Policy'),
                ],
              ),
              onTap: () => _onSelectItem(6, "Privacy Policy"),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app,),
                  SizedBox(width: 10,),
                  Text('Cerrar sesión'),
                ],
              ),
              onTap: () => logout(),
            ),
          ],
        ),
      ),
      body: _getDrawerItemState(_selectedDrawerIndex),
      floatingActionButton: user.rol != "visited" ? FloatingActionButton(
        onPressed: _addObservation,
        tooltip: 'Nueva observación',
        child: Icon(Icons.add),
      ): null,
    );
  }
}
