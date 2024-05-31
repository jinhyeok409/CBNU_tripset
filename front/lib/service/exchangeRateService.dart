import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  final String apiUrl = 'https://api.exchangerate-api.com/v4/latest/USD'; // API 엔드포인트를 여기에 입력하세요

  Future<Map<String, dynamic>> fetchExchangeRatesService() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('환율 정보를 불러오는데 실패했습니다');
    }
  }
}
