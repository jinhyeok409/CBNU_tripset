import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          title: Row(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 100)),
              // Image.asset('assets/logo.png',
              //     width: 110, height: 22, fit: BoxFit.fill), // 로고
              Text(
                'TRIPSET.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB0D1F8),
                  fontSize: 40,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 65,
                ),
                // CircleAvatar(
                // backgroundImage: AssetImage('assets/profile_image.jpg'), // 프로필 이미지 설정
                // radius: 20,
                // ),
                onPressed: () {},
              )
            ],
          ),
        ),
        body: Stack(children: [
          // 짜치는 멘트
          Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 200, 0, 0),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: '호진님,',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: '\n부산 ',
                                style: TextStyle(
                                    color: Color(0xFFB0D1F8),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: '여행 7일 전입니다.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500)),
                          ])),
                        ),
                      ],
                    )),
              ),

              Spacer(
                // 사진 기능 추가할 수도
                flex: 1,
              ),

              // 커뮤니티
              Flexible(
                flex: 2,
                child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 5, 0, 0),
                            child: Text(
                              "커뮤니티",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: InkWell(
                              onTap: () {
                                // 커뮤니티로 이동
                              },
                              child: Text(
                                '더보기 >',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // 커뮤니티 게시판
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                              color: Color(0xFFDFDFDF),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: ListView.builder(
                              padding: EdgeInsets.fromLTRB(15, 5, 10, 0),
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // 게시판으로 이동
                                        },
                                        child: Text(
                                          '게시판 이름',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // 게시글로 이동
                                        },
                                        child: Text(
                                          '게시글 제목',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )
                    ])),
              )
            ],
          ),

          // bottomNavigaitionBar
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: GetBuilder<BottomNavController>(
          //     init: BottomNavController(),
          //     builder: (controller) => BottomNavBar(),
          //   ),
          // ),
        ]),
      ),
    );
  }
}
