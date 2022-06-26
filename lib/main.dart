// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/CarService.dart';
import 'package:flutter_app/pages/MainPage.dart';
import 'package:flutter_app/pages/loading.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';

import 'data/DataModels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: HelperFunctions.getUserDataSharedPreference(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                var json = jsonDecode(snapshot.data.toString());
                if(json != null){
                  UserData.userCars = [];
                  var Cars = jsonDecode(json['userCars']);
                  for(var car in Cars){
                    Car addCar = Car.fromJson(car);
                    addCar.id = car['id'];
                    var spendings = jsonDecode(car['spending']);
                    for(var spending in spendings){
                      Spending addSpending  = Spending.fromJson(spending);
                      addCar.spending.add(addSpending);
                    }
                    if(car['isServiceNotUpload']){
                      carService CS = carService.fromJson(car['CarService']);
                      var services = jsonDecode(car['CarService']);
                      for(var service in services['services']){
                        Service s = Service.fromJson(service);
                        CS.services.add(s);
                      }
                      addCar.CarService = CS;
                    }
                    UserData.userCars.add(addCar);
                  }
                  UserData.isLogged = json['isLogged'];
                  UserData.isAuthorise = json['isAuthorise'];
                  UserData.token = json['token'];

                  if(UserData.isLogged){
                    return mainPage();
                  } else {
                    return login();
                  }
                }
                else {
                  return login();
                }
              }
              else {
                return login();
              }
            }
            return Loading();
          },
        )
      ),
    );
  }
}
