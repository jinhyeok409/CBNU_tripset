import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    User user = User("", "");
    Future register() async {
      try {
        var response = await http.post(
          Uri.parse('server uri'),
          headers: {'Context-Type': 'application/json'},
          body: json.encode(
            {
              'username': user.username,
              'password': user.password,
            },
          ),
        );
        if (response.statusCode == 200) {
          print('create account');
          print(response.body);
        } else
          (print('failed'));
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
                          controller:
                              TextEditingController(text: user.username),
                          onChanged: (val) {
                            user.username = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'username is Empty';
                            }
                            return '';
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
                          controller:
                              TextEditingController(text: user.password),
                          onChanged: (val) {
                            user.password = val;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password is Empty';
                            }
                            return '';
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
                      register();
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
