import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../service/exchangeRateService.dart';

class ExchangeRateController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var exchangeRates = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExchangeRatesController();
  }

  void fetchExchangeRatesController() async {
    try {
      ExchangeRateService service = ExchangeRateService();
      var data = await service.fetchExchangeRatesService();
      exchangeRates.value = data;
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }
}