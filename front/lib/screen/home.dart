import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/exchangeRateService.dart';
import '../controller/exchangeRateController.dart';
import '../bottom_navigation_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final exchangeRateController = Get.put(ExchangeRateController());

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
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Obx(() {
          if (exchangeRateController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (exchangeRateController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(exchangeRateController.errorMessage.value));
          } else {
            final rates = exchangeRateController.exchangeRates['rates'];
            double rateForNation = rates['USD'].toDouble(); //한국기준 API 필요
            // Currency myCurrency = currencyBank[southKorea];  //수정필요
            // Currency otherCurrency = currencyBank[usa];
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding( //나라 선택 필요
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/nationFlag/KOR.gif', width: 50, height: 50),  //국기매칭필요
                              SizedBox(height: 2.0),

                              Text(
                                'KOR',  //나라이름 string 매칭필요
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 4.0),

                              Text(
                                '21.03 6:00 AM', // 시간api 불러오기 필요
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 8.0),

                              Text( // 환율
                                '$rateForNation', //mycurrency 필요
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 6.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/nationFlag/USD.gif', width: 50, height: 50),  //국기매칭필요
                              SizedBox(height: 2.0),

                              Text(
                                'USD',    //나라이름 string 매칭필요
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 4.0),

                              Text(
                                '21.03 18:00 AM',   // 시간api 불러오기 필요
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 8.0),

                              Text( // 환율   otherCurrency 필요
                                '$rateForNation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(height: 6.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
