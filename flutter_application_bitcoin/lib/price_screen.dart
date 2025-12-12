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
  double price_bitcoin = -1;
  double price_ethereum = -1;
  double price_litecoin = -1;
  bool isLoading = false;

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

  Future<dynamic> getData(String crypto) async {
    Response response = await get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=$selectedCurrency&ids=$crypto&x_cg_demo_api_key=$apikey',
      ),
    );

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    }
    return null;
  }

  // setState() cannot take an async function.
  void updateUI() async {
    try {
      setState(() {
        isLoading = true;
      });
      final bitcoinData = await getData('bitcoin');
      final ethereumData = await getData('ethereum');
      final litecoinData = await getData('litecoin');

      setState(() {
        isLoading = false;

        if (bitcoinData != null) {
          price_bitcoin = bitcoinData['bitcoin'][selectedCurrency.toLowerCase()]
              .toDouble();
        }
        if (ethereumData != null) {
          price_ethereum =
              ethereumData['ethereum'][selectedCurrency.toLowerCase()]
                  .toDouble();
        }
        if (litecoinData != null) {
          price_litecoin =
              litecoinData['litecoin'][selectedCurrency.toLowerCase()]
                  .toDouble();
        }
      });
    } catch (e) {
      print('Error updating prices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🤑 Coin Ticker')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CryptoCard(
                      price: price_bitcoin,
                      selectedCurrency: selectedCurrency,
                      cryptoCurrency: 'BTC',
                    ),
                    CryptoCard(
                      price: price_ethereum,
                      selectedCurrency: selectedCurrency,
                      cryptoCurrency: 'ETH',
                    ),
                    CryptoCard(
                      price: price_litecoin,
                      selectedCurrency: selectedCurrency,
                      cryptoCurrency: 'LTC',
                    ),
                  ],
                ),
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
