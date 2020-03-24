import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zowe_flutter/providers/auth.dart';

class LogoutScreen extends StatelessWidget {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Material(
              child: Text(
                "Are you sure you want to logout?",
                style: style.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold,),
              ),
            ),)
            
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color.fromRGBO(42, 125, 225, 1),
              child: MaterialButton(
                onPressed: () async {
                  auth.logout();
                },
                child: Text(
                  "Logout",
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
