import 'package:country_flags/country_flags.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lesson_4/data/models/currency_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List> getDataFromApi() async {
    var response = await Dio().get("https://nbu.uz/en/exchange-rates/json/");
    List currencies = response.data
        .map((current_currency) => Currency.fromJson(current_currency))
        .toList();
    print(response);
    return currencies;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getDataFromApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              List data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 50,
                  width: double.infinity,
                  color: Colors.white24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CountryFlags.flag(
                        data[index].code.substring(0, 2),
                        width: 100,
                        height: 50,
                      ),
                      Text(data[index].title),
                      Text("${data[index].cb_price} UZS"),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.hasError) {}
            return Center(child: Text("Error"));
          },
        ),
      ),
    );
  }
}
