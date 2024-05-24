import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/screen/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    Future register(String username, String password) async {
      try {
        String serverUri = dotenv.env['SERVER_URI']!;
        String registerEndpoint = dotenv.env['REGISTER_ENDPOINT']!;
        String registerUri = '$serverUri$registerEndpoint';

        var response = await http.post(
          Uri.parse(registerUri),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'username': username,
            'password': password,
          },
        );
        if (response.statusCode == 200) {
          print('create account');
          print(response.body);
          Get.toNamed('/login');
        } else {
          print(response.statusCode);
          print('fail');
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade100,
                        Colors.blue.shade200,
                        Colors.blue.shade300,
                        Colors.blue.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                        ),
                        Icon(
                          Icons.app_registration,
                          color: Colors.white,
                          size: 70,
                        ),
                        Text(
                          "REGISTER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          controller: usernameController,
                          onFieldSubmitted: (val) {
                            String username = usernameController.text;
                            String password = passwordController.text;
                            register(username, password);
                          },
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue.shade200,
                            ),
                            label: Text(
                              'username',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.blue.shade200,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          onFieldSubmitted: (val) {
                            String username = usernameController.text;
                            String password = passwordController.text;
                            register(username, password);
                          },
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 15,
                          ),
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue.shade200,
                            ),
                            label: Text(
                              'password',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.blue.shade200,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Already have Account?",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  height: 60,
                  width: 60,
                  child: TextButton(
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      register(username, password);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade200,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
