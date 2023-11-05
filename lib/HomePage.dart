import 'package:csdf_mini_project/scanQR.dart';
import 'package:flutter/material.dart';

import 'generateQR.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const CircleAvatar(
                backgroundImage: AssetImage(
                  "assets/images/QR.jpg",
                ),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: 150,
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to QR code scanning screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanQRScreen(),
                    ),
                  );
                },
                child: Text('Scan QR Code'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to QR code generation screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateQRScreen(),
                    ),
                  );
                },
                child: Text('Generate QR Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
