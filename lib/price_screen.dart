import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}


class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  DropdownButton<String> androidDropDown(){
    List<DropdownMenuItem<String>> dropDownItems=[];
    for(String currency in currenciesList){
      var item = DropdownMenuItem(child: Text(currency),value: currency,);
      dropDownItems.add(item);
    }
   return DropdownButton<String>(
          value: selectedCurrency,
          items: dropDownItems ,
          onChanged: (value){
           setState(() {
             selectedCurrency = value!;
             getData();
           });
          },
   );
  }
  List<Text> getPickerItems (){
    List<Text> items=[];
    for(String currency in currenciesList){
      items.add(Text(currency));
    }
    return items;
  }
  CupertinoPicker iosPicker(){
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex){
        print(selectedIndex);
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: getPickerItems(),
    ) ;
  }
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        print(data);
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto]!,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child:makeCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: defaultTargetPlatform == TargetPlatform.iOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

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
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}