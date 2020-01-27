import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AlertWidget extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  final bool back;
  AlertWidget({this.message, this.color, this.icon, this.back});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color,
              size: 64,
            ),
            Padding(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(16),
            ),
            back ? Padding(
              child: RaisedButton(
                child: Text('Back'),
                onPressed: () => Navigator.pop(context),
              ),
              padding: EdgeInsets.all(16),
            ) : Container(),
          ],
        ),
      ),
    );
  }
  
}