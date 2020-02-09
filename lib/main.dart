import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:ciprrd_service/session/session.dart';
import 'package:ciprrd_service/sql/models.dart' as models;
import 'package:ciprrd_service/values/colors.dart';
import 'package:ciprrd_service/views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

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
    //session = Session.getActiveSession();
    //await Connection.getInstance().delete("CIPRRDDB");
    //await (await Connection.getInstance().database).execute("insert into Period(periodHour)	values('07:30')", );
    //Province p = new Province(provinceName: "Guayas");
   // int n = await p.save();
    //Province p = (await Province.filter(where: "provinceID = ?", whereArgs: [1]))[0];
    //Canton c = new Canton(cantonName: "Guayaquil", provinceID: p);
    //c.save();
    //print((await Canton.filter(where: "cantonID = ?", whereArgs: [1]))[0].toMap());
    //print((await models.Province.filter(orderBy: "provinceName")));
    //user = models.User(username: "kennyCamba", email: "kacamba@espol.edu.ec", firstname: "Kenny", lastname: "Camba", login: false, rol: "admin");
    //await user.save();
  }
  @override
  Widget build(BuildContext context){
    init();
    if(user != null && user.login){
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColors.app_theme,
        ),
        home: HomePage(title: '', user: user,),
      );
    }else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColors.app_theme,
        ),
        home: LoginPage(),
      );
    }

  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        toolbarOpacity: 0.0,
        elevation: 0.0,

        title: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: Colors.grey,
          indicator: BubbleTabIndicator(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            indicatorRadius: 15.7,
            indicatorHeight: 25.0,
            indicatorColor: AppColors.primary,
            tabBarIndicatorSize: TabBarIndicatorSize.label
          ),
          labelColor: Colors.white,
          tabs:[
            Tab(text: "SIGN IN",),
            Tab(text: "SIGN UP",)
          ]
        ),
      ),
        body: TabBarView(
          children: <Widget>[
            Login(),
            Icon(Icons.email)
          ],
        ),
      )
    );
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final models.User user;

  @override
  _MyHomePageState createState() => _MyHomePageState(user: user);
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  final models.User user;

  _MyHomePageState({this.user});

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void logout(BuildContext context){
    user.login = false;
    user.update();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (contex) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.pie_chart, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Datos'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.add, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Agregar Observación'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.map, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Mapa'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.contact_mail, color: AppColors.primary,),
                  SizedBox(width: 10,),
                  Text('Contáctanos'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
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
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.verified_user,),
                  SizedBox(width: 10,),
                  Text('Privacy Policy'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app,),
                  SizedBox(width: 10,),
                  Text('Cerrar sesión'),
                ],
              ),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
