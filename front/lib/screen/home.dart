import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/exchangeRateService.dart';
import '../controller/exchangeRateController.dart';
import '../bottom_navigation_bar.dart';
import '../model/currency.dart';

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
            return Center(child : CurrencyExchange());
          }
        }),
      ),
    );
  }
}

class CurrencyExchange extends StatefulWidget {
  @override
  _CurrencyExchangeState createState() => _CurrencyExchangeState();
}

class _CurrencyExchangeState extends State<CurrencyExchange> {
  String selectedCountry1 = southKorea;
  String selectedCountry2 = usa;

  @override
  Widget build(BuildContext context) {
    final exchangeRateController = Get.find<ExchangeRateController>();

    final rates = exchangeRateController.exchangeRates['rates'];
    final currency1 = currencyBank[selectedCountry1]!;
    final currency2 = currencyBank[selectedCountry2]!;
    double rateForNation1 = rates[currency1.code]?.toDouble() ?? 0.0;
    double rateForNation2 = rates[currency2.code]?.toDouble() ?? 0.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  DropdownButton<String>( //  드롭다운버튼
                    value: selectedCountry1,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry1 = newValue!;
                      });
                    },
                    items: currencyBank.keys.map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),

                  CurrencyDetails(
                    currency: currency1,
                    rate: rateForNation1,
                    dateTime: '21.03 6:00 AM', // Update with real-time data
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),

            Expanded(
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: selectedCountry2,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCountry2 = newValue!;
                      });
                    },
                    items: currencyBank.keys.map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  CurrencyDetails(
                    currency: currency2,
                    rate: rateForNation2,
                    dateTime: '21.03 18:00 AM', // Update with real-time data
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDetails extends StatelessWidget { //여기서부터 코드 다시보기
  final Currency currency;
  final double rate;
  final String dateTime;

  const CurrencyDetails({
    required this.currency,
    required this.rate,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Image.asset(currency.imageFileName, width: 50, height: 50),
            SizedBox(height: 2.0),
            Text(
              currency.nationName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              dateTime,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              rate.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              currency.code,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              currency.symbol,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
