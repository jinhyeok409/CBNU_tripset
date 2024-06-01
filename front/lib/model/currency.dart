class Currency {
  String nationName;
  String imageFileName;
  String symbol;
  String code;

  Currency({required this.nationName, required this.imageFileName, required this.symbol, required this.code});
}

const southKorea = 'Korea';
const eu = 'EU';
const usa = 'U.S.A.';
const japan = 'Japan';
const china = 'China';
const gb = 'U.K.';
// const mexico = 'Mexico';
// const hongkong = 'HongKong';

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