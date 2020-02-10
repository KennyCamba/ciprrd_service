import 'package:ciprrd_service/sql/models.dart' as models;
import 'package:ciprrd_service/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFragment extends StatelessWidget{
  models.User user;
  HomeFragment(this.user);
  @override
  Widget build(BuildContext context) {
    return _HomeFragment(user);
  }



}

class _HomeFragment extends StatefulWidget {
  models.User user;
  _HomeFragment(this.user);
  @override
  State<StatefulWidget> createState() {
    return Home();
  }
}

class Home extends State<_HomeFragment>{
  static final style = TextStyle(fontSize: 12.0);
  List<Widget> options = <Widget> [
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.library_books, color: Colors.blue,),
          Text("Mis obs", maxLines: 1, style: style,)
        ],
      ),
    ),
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.remove_red_eye, color: Colors.purple,),
          Text("Observaciones", maxLines: 1, style: style,)
        ],
      ),
    ),
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.supervisor_account, color: Colors.redAccent,),
          Text("Usuarios", maxLines: 1, style: style,)
        ],
      ),
    ),
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.room, color: Colors.deepPurpleAccent,),
          Text("Estaciones", maxLines: 1, style: style,)
        ],
      ),
    ),
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.settings, color: Colors.red,),
          Text("Editar Perfil", maxLines: 1, style: style,)
        ],
      ),
    ),
    ListTile(
      onTap: (){},
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.map, color: Colors.cyan,),
          Text("Ver en Mapa", maxLines: 1, style: style,)
        ],
      ),
    )
  ];

  List<Widget> getOptions(){
    if(widget.user.rol == "admin")
      return <Widget> [options[0], options[1], options[2], options[3], options[4]];
    else if(widget.user.rol == "invited")
      return <Widget>[options[4]];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = getOptions();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:Column(
        children: <Widget>[
          Material(
              elevation: 10.0,
              shadowColor: Colors.black54,
              color: AppColors.app_theme.shade50,
              borderRadius: BorderRadius.circular(10.7),
              child: GridView.count(
                    shrinkWrap: true,
                    childAspectRatio: 1.5,
                    crossAxisCount: 3,
                    children: buttons,
                )
              ),
          SizedBox(height: 10.0,),
          DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
              Material(
                elevation: 10.0,
                shadowColor: Colors.black54,
                color: AppColors.app_theme.shade50,
                borderRadius: BorderRadius.circular(10.7),
                child: TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("0", style: TextStyle(fontSize: 18),),
                      Text("Observaciones")
                    ],
                  ),),
                  Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("0", style: TextStyle(fontSize: 18),),
                      Text("Aprobadas")
                    ],
                  ),),
                  Tab(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("0", style: TextStyle(fontSize: 18),),
                      Text("Pendientes")
                    ],
                  ),
                  )
                  ],
                ),
              ),
                SizedBox(height: 10.0,),
                SizedBox(
                  height: 100.0,
                  child: TabBarView(
                    children: <Widget>[
                      Text("1"),
                      Text("2"),
                      Text("3"),
                    ],
                  ),
                )
              ],
            )

          )
        ],
      )

    );
  }

}