import 'package:admin/screens/dashboard.dart';
import 'package:admin/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginTest extends StatefulWidget {
  const LoginTest({super.key});

  @override
  State<LoginTest> createState() => _LoginTestState();
}

bool _isObscure = true;

class _LoginTestState extends State<LoginTest> {
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
          image: DecorationImage(image: AssetImage('assets/bg1.jpg'),fit:BoxFit.cover)
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.red,
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
                      Positioned(
              bottom: 150,
              left: 90,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 7, 216),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 500,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    // image: DecorationImage(image: AssetImage('assets/bg6.jpeg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              right: 70,
              top: 130,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.green,
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              right: 500,
              top: 20,
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 224, 131, 60),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              right: -90,
              top: 480,
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 88, 120, 89),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              right: 270,
              top: 420,
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 46, 35, 100),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              right: 470,
              bottom: -50,
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 231, 239, 120),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: 40,
              left: 30,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.black,
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: -70,
              left: 250,
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: 90,
              left: 450,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 16, 61, 70),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 110, 61, 210),
                    // image: DecorationImage(
                    //     image: AssetImage('assets/scaled_square_image.jpg')),
                    shape: BoxShape.circle),
              ),
            ),
            Center(
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
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black45),
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
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[300]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
