import 'dart:convert';
import 'package:http/http.dart';
import 'package:stock_ui/stock.dart';

class HttpService {
  final String stockURL = ""https://min-api.cryptocompare.com/data/v2/histoday?fsym=ETH&tsym=BTC&limit=200&toTs=1528411045";

  Future<List<Stock>> getStocks() async {
    Response res = await get(Uri.parse(stockURL));

    if (res.statusCode == 200) {
      final obj = jsonDecode(res.body);
      print(obj['stock'][0]['symbol']);
      List<Stock> stocks =  new List<Stock>();

      for (int i = 0; i < obj['stock'].length; i++) {
        Stock stock = new Stock(company: obj['stock'][i]['name'], symbol: obj['stock'][i]['symbol'], price: obj['stock'][i]['price'], chg: obj['stock'][i]['chg']);
        stocks.add(stock);
      }

      return stocks;
    } else {
      throw "Unable to retrieve stock data.";
    }
  }
}