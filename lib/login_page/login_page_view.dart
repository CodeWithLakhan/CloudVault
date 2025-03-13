import 'package:cloudvault/home_page/home_page_view.dart';
import 'package:cloudvault/signup_page/signup_page_view.dart';
import 'package:flutter/material.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

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
              "Login Page",
              style: TextStyle(fontSize: 20),
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
            ElevatedButton(onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePageView()),
                    (route) => false,
              );
            }, child: Text("Login")),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPageView()),
                  (route) => false,
                );
              },
              child: Text(
                "Don't have an Account?, Sign Up",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        )),
      ),
    );
  }
}
