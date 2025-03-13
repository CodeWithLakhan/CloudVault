import 'package:cloudvault/login_page/login_page_view.dart';
import 'package:flutter/material.dart';

class SignupPageView extends StatelessWidget {
  const SignupPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CloudVault"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up Page",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              decoration: InputDecoration(hintText: "Enter Name"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Enter Email"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Enter Password"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Login")),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPageView()),
                  (route) => false,
                );
              },
              child: Text(
                "Have an Account?, Login ",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        )),
      ),
    );
  }
}
