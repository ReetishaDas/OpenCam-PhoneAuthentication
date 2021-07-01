import 'package:flutter/material.dart';
import 'package:video_app/login_screen.dart';
import 'create_video.dart';

class ViewVideo extends StatefulWidget {
  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Click to Create Video",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Algreya',
                fontWeight: FontWeight.w700,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CreateVideo()));
                },
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 35.0,
                ),
              ),
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        child: Icon(
          Icons.logout,
          size: 35.0,
        ),
      ),
    );
  }
}
// Text(
// "Click to Create Video",
// ),
