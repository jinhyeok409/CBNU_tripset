import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true, // AppBar를 Body에 포함하여 배경을 투명하게 만듭니다.
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 100)),
              // Image.asset('assets/logo.png',
              //     width: 110, height: 22, fit: BoxFit.fill), // 로고
              Text(
                'TRIPSET.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
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

        body: Column(
          children: [
            Flexible(
              child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 180, 0, 0),
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
            Spacer(),
            Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          "커뮤니티",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            // 커뮤니티로 이동하는 작업을 여기에 작성합니다.
                            print('더보기를 클릭하여 커뮤니티로 이동합니다.');
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Color(0xFFDFDFDF),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
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
                ]))
          ],
        ),

        // bottomNavigationBar: Container(
        //   margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        //   child: BottomAppBar(
        //     elevation: 0.0,
        //     child: Row(),
        //   ),
      ),
    );
  }
}
