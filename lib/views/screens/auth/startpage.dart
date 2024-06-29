import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.black, Colors.grey, Colors.black])),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 100,
            ),
            SizedBox(
              width: double.infinity,
              height: 400,
              child: Image.asset(
                "images/note.png",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: const Text(
                "Don't let anything get to you \n Writeyour notes easily \n through the My Notes application",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.orange,
              minWidth: 350,
              height: 40,
              child: const Text("Get Started"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("login");
              },
            )
          ],
        ),
      ),
    );
  }
}
