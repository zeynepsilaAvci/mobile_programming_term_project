import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:course_project/home_screen.dart';
import 'package:course_project/services/auth_services.dart';
import 'package:course_project/login_screen.dart';

class SignupScreen extends StatelessWidget {
  final AuthService _auth= AuthService();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Register Here",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white60)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Email",
                    labelStyle: TextStyle(
                        color: Colors.white60
                    )
                ),
              ),
              SizedBox(height: 25),
              TextField(
                controller: _passController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white60)
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Password",
                    labelStyle: TextStyle(
                        color: Colors.white60
                    )
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width/1.5,
                child: ElevatedButton(
                    onPressed:()async {
                      String password = _passController.text;
                      String email = _emailController.text;
                      User? user = await _auth.registerWithEmailAndPassword(
                          _emailController.text,
                          _passController.text
                      );
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Password must be at least 6 characters long."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return; // Kontrol başarısızsa, işlem devam etmez
                      }
                      if(user != null){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen(),
                            ));
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.deepPurple[900],
                        fontSize: 18,
                      ),
                    )
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Or",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextButton(
                  onPressed:(){
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context)=>LoginScreen(),
                        ));
                  }
                  , child: Text("Log In",
                style: TextStyle(fontSize: 18),))
            ],
          ),
        ),
      ),
    );
  }
}
