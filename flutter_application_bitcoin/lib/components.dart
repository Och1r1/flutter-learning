import 'package:flutter/material.dart';

class CryptoCard extends StatelessWidget {
  int price;
  String selectedCurrency;
  String cryptoCurrency;

  CryptoCard({required this.price, required this.selectedCurrency, required this.cryptoCurrency});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 28),
                child: price == -1
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        '1 $cryptoCurrency = $price $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
              ),
            ),
          );
  }
}