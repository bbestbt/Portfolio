import 'package:flutter/material.dart';

class NewTempPage extends StatefulWidget {
  @override
  _NewTempPageState createState() => _NewTempPageState();
}

class _NewTempPageState extends State<NewTempPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Text('Hello'),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
                // context.read<AuthenticationService>().signOut();
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
