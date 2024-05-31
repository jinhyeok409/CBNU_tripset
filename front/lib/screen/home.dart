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
            return ListView.builder(
              itemCount: rates.length,
              itemBuilder: (context, index) {
                String currency = rates.keys.elementAt(index);
                double rate = rates[currency].toDouble();
                return ListTile(
                  title: Text('$currency: $rate'),
                );
              },
            );
          }
        }),
      ),
    );
  }
}