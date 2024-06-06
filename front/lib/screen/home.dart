import 'package:flutter/material.dart';
import 'package:front/screen/homePopularDestination.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../model/currencyDetails.dart';
import '../service/exchangeRateService.dart';
import '../controller/exchangeRateController.dart';
import '../bottom_navigation_bar.dart';
import '../model/currency.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

import 'myPage.dart';

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileWidget()),
                  );
                },
              ),

            ],
          ),
        ),
        body: Obx(() {
          if (exchangeRateController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (exchangeRateController.errorMessage.value.isNotEmpty) {
            return Center(
                child: Text(exchangeRateController.errorMessage.value));
          } else {
            return Center(
              child: CurrencyExchange(),
            );
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
  String dateTime1 = '';
  String dateTime2 = '';

  @override
  void initState() {
    super.initState();
    fetchTimeForCountry1();
    fetchTimeForCountry2();
  }

  void fetchTimeForCountry1() {
    fetchTimeForCountry(selectedCountry1).then((time) {
      setState(() {
        dateTime1 = time;
      });
    });
  }

  void fetchTimeForCountry2() {
    fetchTimeForCountry(selectedCountry2).then((time) {
      setState(() {
        dateTime2 = time;
      });
    });
  }

  Future<String> fetchTimeForCountry(String country) async {
    tz.initializeTimeZones();
    final response = await http.get(Uri.parse(
        'http://worldtimeapi.org/api/timezone/${countryToTimezone[country]}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rawDateTime = DateTime.parse(data['datetime']);
      final timezoneName = countryToTimezone[country];
      final location = tz.getLocation(timezoneName!);
      final dateTimeInZone = tz.TZDateTime.from(rawDateTime, location);
      final formattedTime =
      DateFormat('yy.MM.dd hh:mm a').format(dateTimeInZone);
      return formattedTime;
    } else {
      throw Exception('Failed to load time');
    }
  }

  @override
  Widget build(BuildContext context) {
    final exchangeRateController = Get.find<ExchangeRateController>();

    final rates = exchangeRateController.exchangeRates['rates'];
    final currency1 = currencyBank[selectedCountry1]!;
    final currency2 = currencyBank[selectedCountry2]!;
    double rateForNation1 = rates[currency1.code]?.toDouble() ?? 0.0;
    double rateForNation2 = rates[currency2.code]?.toDouble() ?? 0.0;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.separated(
        itemCount: 3,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Exchange Rate',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedCountry1,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCountry1 = newValue!;
                                fetchTimeForCountry1();
                              });
                            },
                            items: currencyBank.keys
                                .map<DropdownMenuItem<String>>((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                          ),
                          Center(
                            child: CurrencyDetails(
                              currency: currency1,
                              rate: rateForNation1,
                              dateTime: dateTime1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedCountry2,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCountry2 = newValue!;
                                fetchTimeForCountry2();
                              });
                            },
                            items: currencyBank.keys
                                .map<DropdownMenuItem<String>>((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                          ),
                          Center(
                            child: CurrencyDetails(
                              currency: currency2,
                              rate: rateForNation2,
                              dateTime: dateTime2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ],
            );
          } else if (index == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Destinations',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   'View All',
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    popularDestinations(context, 'assets/destination/paris.gif',
                        'Paris', 'France'),
                    popularDestinations(context, 'assets/destination/rome.gif',
                        'Rome', 'Italy'),
                    popularDestinations(context,
                        'assets/destination/turkey.gif', 'Istanbul', 'Turkey'),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          }
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10.0);
        },
      ),
    );
  }
}

const countryToTimezone = {
  southKorea: 'Asia/Seoul',
  usa: 'America/New_York',
  eu: 'Europe/Berlin',
  japan: 'Asia/Tokyo',
  china: 'Asia/Shanghai',
  gb: 'Europe/London',
};