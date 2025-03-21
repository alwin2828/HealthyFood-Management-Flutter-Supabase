import 'package:flutter/material.dart';
import 'package:shop/dashboard.dart';
import 'package:shop/main.dart';
import 'package:shop/registration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

bool _isObscure = true;

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void Signin() async {
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
        body: SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover)),
        child: Center(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 500,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.black45),
                                ),
                                hintText: 'Enter Your Email',
                                label: Text("Email"),
                                prefixIcon:
                                    Icon(Icons.alternate_email_outlined)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Your Address';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: Colors.black45),
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
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Signin();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF25A18B)
),
                        ),
                        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an accound"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Registration(),
                                ));
                          },
                          child: Text('Sign Up')),
                    ],
                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
