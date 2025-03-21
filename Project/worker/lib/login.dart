import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worker/dashboard.dart';
import 'package:worker/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

bool _isObscure = true;

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void signIn() async {
    try {
      String email = _email.text;
      String password = _password.text;
      print(email);
      print(password);
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final User? user = res.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
      print("signin successfull");
    } catch (e) {
      print("Access Denied $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage( 
                        image: AssetImage(
                          'assets/restaurant.jpg',
                        ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(250, 130))),
                height: 350,
                width: 550,
              ),
              ListView(
                padding: EdgeInsets.all(30),
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sign In",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text("Sign in to your Nutirgo account",
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.black45),
                        ),
                        hintText: 'Enter Your Email',
                        label: Text("Email"),
                        prefixIcon: Icon(Icons.alternate_email_outlined)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Your Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.black45),
                      ),
                      hintText: "Enter Your Passsword",
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 60),
                        child: Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF25A18B)),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text("Don't have an accound"),
                  //     TextButton(
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (context) => Registration(),
                  //               ));
                  //         },
                  //         child: Text('Sign Up')),
                  //   ],
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
