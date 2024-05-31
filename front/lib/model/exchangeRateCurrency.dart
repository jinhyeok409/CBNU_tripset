class Currency {
  String nationName;
  String imageFileName;
  String symbol;
  String code;

  Currency({required this.nationName, required this.imageFileName, required this.symbol, required this.code});
}

final southKorea = 'South Korea';
final eu = 'EU';
final usa = 'U.S.A.';
final japan = 'Japan';
final china = 'China';
final gb = 'United Kingdom';
final mexico = 'Mexico';
final hongkong = 'HongKong';

final currencyBank = {
  southKorea: Currency(
      code: 'KRW',
      symbol: '₩',
      nationName: southKorea,
      imageFileName: 'assets/nationFlag/KOR.gif'),
  eu: Currency(
      code: 'EUR',
      symbol: '€',
      nationName: eu,
      imageFileName: 'assets/nationFlag/EUR.gif'),
  usa: Currency(
      code: 'USD',
      symbol: "\$",
      nationName: usa,
      imageFileName: 'assets/nationFlag/USD.gif'),

  japan: Currency(
      code: 'JPY',
      symbol: '¥',
      nationName: japan,
      imageFileName: 'assets/nationFlag/JAP.gif'),

  china: Currency(
      symbol: '¥',
      code: 'CHY',
      nationName: china,
      imageFileName: 'assets/nationFlag/CHINA.gif'),

  gb: Currency(
      code: 'GBP',
      symbol: "£",
      nationName: gb,
      imageFileName: 'assets/nationFlag/GB.gif'),

  // hongkong: Currency(
  //     code: 'HKD',
  //     symbol: 'HK\$',
  //     nationName: hongkong,
  //     imageFileName: 'assets/images/183-hong-kong.png'),
  //
  // mexico: Currency(
  //     symbol: '\$',
  //     code: 'MXN',
  //     nationName: mexico,
  //     imageFileName: 'assets/images/252-mexico.png'),
};