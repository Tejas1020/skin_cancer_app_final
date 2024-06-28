import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/img/canv1.png'),
            Image.asset('assets/img/canv2.png'),
            Image.asset('assets/img/canv3.png'),
            Image.asset('assets/img/canv4.png'),
            Image.asset('assets/img/canv5.png'),
          ],
        ),
      ),
    );
  }
}
