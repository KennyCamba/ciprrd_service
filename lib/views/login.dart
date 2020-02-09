import 'package:ciprrd_service/main.dart';
import 'package:ciprrd_service/session/session.dart';
import 'package:ciprrd_service/sql/models.dart' as models;
import 'package:ciprrd_service/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Login();
  }

}

class _Login extends State<Login>{

  final user = TextEditingController();
  final pass = TextEditingController();

  void login(BuildContext context)async{
    String usuario = user.text;
    models.User usu = await Session.getUser();
    if(usu != null && usu.username == usuario){
      usu.login = true;
      await usu.update();
      print("usu: " + usu.login.toString());
      models.User usu2 = await Session.getUser();
      print("usu2: " + usu2.login.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (contex) => HomePage(title: "", user: usu,)),
      );
    }else{
      Toast.show("No login", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

  }

  @override
  void dispose(){
    user.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            elevation: 10.0,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(15.7),
            child: TextField(
              controller: user,
              autofocus: false,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                  hintText: "User",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(15.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.7),
                  )
              ),
            ),
          ),
          SizedBox(height: 30,),
          Material(
            elevation: 10.0,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(15.7),
            child: TextField(
              cursorColor: AppColors.primary,
              controller: pass,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary, width: 2.0),
                    borderRadius: BorderRadius.circular(15.7),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15.7),
                  )
              ),
            ),
          ),
          SizedBox(height: 30,),
          Text("FORGOT PASSWORD", style: TextStyle(color: Colors.grey),),
          SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () => login(context),
              elevation: 5.0,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15.0),
              color: AppColors.primary,
              child: Text("CONTINUE"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.7),
              ),
            )
          )
        ],
      ),
    );

  }

}