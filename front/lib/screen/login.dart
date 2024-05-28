import 'dart:convert';
import 'package:front/screen/home.dart';
import 'package:front/screen/root.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 암호화 저장 토큰저장시 씀
import 'package:flutter/cupertino.dart';
import 'package:front/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    final storage = FlutterSecureStorage();
    Future login(String username, String password) async {
      try {
        String serverUri = dotenv.env['SERVER_URI']!;
        String loginEndpoint = dotenv.env['LOGIN_ENDPOINT']!;
        String loginUri = '$serverUri$loginEndpoint';

        var response = await http.post(
          Uri.parse(loginUri),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'username': username,
            'password': password,
          },
          encoding: Encoding.getByName('utf-8'),
        );
        /* Map<String, dynamic> decodedToken =
              JwtDecoder.decode(token); 이름 accessToken 인거 token에 넣기 */
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody =
              json.decode(response.body); // 반환값 디코드
          String? token = responseBody['accessToken'];
          print(token);
          if (token != null) {
            await storage.write(key: 'accessToken', value: token);
            print('Login successful.');
            print(token);
            //Get.toNamed('/home');
            Get.offNamed('/root');
          }
        } else {
          print('login failed');
        }
      } catch (e) {
        print(e.toString()); // 변칙 생겼을 때
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
                  height: 650,
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
                          Icons.airplane_ticket,
                          color: Colors.white,
                          size: 150,
                        ),
                        Text(
                          "Make your travel easier",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        Text(
                          "TRIPSET",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          controller: usernameController,
                          // onFieldSubmitted: (val) {
                          //   엔터시 로그인
                          // },
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
                              Icons.email,
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
                            login(username, password);
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
                          height: 10,
                        ),
                        SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Auto-login ',
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              CupertinoSwitch(
                                // 부울 값으로 스위치 토글 (value)
                                value: switchValue,
                                activeColor: Colors.blue.shade100,
                                onChanged: (bool? value) {
                                  // 스위치가 토글될 때 실행될 코드
                                  // 토큰값과 관련해서 사용될 듯 (미완)
                                  setState(() {
                                    switchValue = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/register');
                          },
                          child: Text(
                            "Don't have Account?",
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
                  height: 30,
                ),
                Container(
                  height: 60,
                  width: 60,
                  child: TextButton(
                    onPressed: () {
                      String username = usernameController.text;
                      String password = passwordController.text;
                      login(username, password);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade200,
                    ),
                    child: Transform.rotate(
                      angle: 45,
                      child: Icon(
                        Icons.airplanemode_active,
                        color: Colors.white,
                        size: 30,
                      ),
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
