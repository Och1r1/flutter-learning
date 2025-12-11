import 'dart:convert';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:http/http.dart';
import 'components.dart';

const apikey = 'CG-jqCD24b2B8ncfYsd2Yejyigv';

class PriceScreen extends StatefulWidget {
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int price_bitcoin = -1;
  int price_ethereum = -1;
  int price_litecoin = -1;

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem> ls = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      ls.add(newItem);
    }
    return ls;
  }

  Future<dynamic> getDataBitcoin() async {
    Response response = await get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=$selectedCurrency&ids=bitcoin&x_cg_demo_api_key=$apikey',
      ),
    );
    if(response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }

    return null;
  }

  Future<dynamic> getDataEthereum() async {
    Response response = await get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=$selectedCurrency&ids=ethereum&x_cg_demo_api_key=$apikey',
      ),
    );
    if(response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }

    return null;
  }

  Future<dynamic> getDataLitecoin() async {
    Response response = await get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=$selectedCurrency&ids=litecoin&x_cg_demo_api_key=$apikey',
      ),
    );
    if(response.statusCode == 200){
      String data = response.body;
      return jsonDecode(data);
    }

    return null;
  }

  // setState() cannot take an async function.
  void updateUI() async {
    final bitcoinData = await getDataBitcoin();
    final ethereumData = await getDataEthereum();
    final litecoinData = await getDataLitecoin();

    setState(() {
      if (bitcoinData != null) {
        price_bitcoin = bitcoinData['bitcoin'][selectedCurrency.toLowerCase()];
      }

      if (ethereumData != null) {
        price_ethereum = ethereumData['ethereum'][selectedCurrency.toLowerCase()];
      }

      if (litecoinData != null) {
        price_litecoin = litecoinData['litecoin'][selectedCurrency.toLowerCase()];
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🤑 Coin Ticker')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(price: price_bitcoin, selectedCurrency: selectedCurrency, cryptoCurrency: 'BTC'),
          CryptoCard(price: price_ethereum, selectedCurrency: selectedCurrency, cryptoCurrency: 'ETH'),
          CryptoCard(price: price_litecoin, selectedCurrency: selectedCurrency, cryptoCurrency: 'LTC'),
          Spacer(), // takes all the empty spaces and pushes your container to the bottom
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton(
              value: selectedCurrency,
              items: getDropdownItems(),
              onChanged: (value) => {
                setState(() {
                  selectedCurrency = value!;
                }),
                updateUI(),
              },
            ),
          ),
        ],
      ),
    );
  }
}
