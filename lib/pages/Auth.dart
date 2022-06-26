import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/MainPage.dart';
import 'package:flutter_app/utils/ServerMethods.dart';

import '../data/DataModels.dart';
import '../utils/HelperFunctions.dart';

class Authorise extends StatefulWidget {

  const Authorise({Key? key}) : super(key: key);

  @override
  State<Authorise> createState() => _AuthoriseState();
}

class _AuthoriseState extends State<Authorise> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  QuerySnapshot? snapshotUserInfo;


  Future<bool> singMeIn() async {

    HelperFunctions.saveUserEmailSharedPreference(emailController.text);

    setState(() {
      isLoading  = true;
    });

    try{
      String data = await ServerMethods.login(passController.text, emailController.text);

      if(data == "Server error"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Authorise()));
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Text('Ошибка'),
                content: const Text("Ошибка сервера. Попробуйте заного"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ]));

        return false;
      } else if(data == "No user"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Authorise()));
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Text('Ошибка'),
                content: const Text("Пользователь не найден"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ]));

        return false;
      } else {
        var Data = jsonDecode(data);

        UserData.userphoto = Data["photo"];
        UserData.token = Data["token"];
        UserData.isLogged = true;
        UserData.isAuthorise = true;

        var cars = await ServerMethods.getUserCars(UserData.token);

        if(cars != 'Error'){
          var Cars = jsonDecode(cars);

          for(var car in Cars){
            Car addCar = Car.fromJson(car);
            for(var spending in car['spendings']){
              Spending addSpending  = Spending.fromJson(spending);
              addCar.spending.add(addSpending);
            }
            addCar.id = car['id'];
            UserData.userCars.add(addCar);
          }

        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Authorise()));
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: const Text('Ошибка'),
                  content: const Text("Ошибка получения данных"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ]));
          return false;
        }

        HelperFunctions.saveUserDataSharedPreference();
        HelperFunctions.saveUserAuthorisedInSharedPreference(true);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        return true;
      }
    } catch(e){
      print(e.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Authorise()));
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: const Text('Ошибка'),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ]));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 35),
              child: Center(
                child: Text(
                  'SMART CAR OWNER',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff007AFF)
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(
                        118, 118, 128, 0.12), //color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 36,
                  child: CupertinoTextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    placeholder: "Email",
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(
                        118, 118, 128, 0.12), //color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 36,
                  child: CupertinoTextField(
                    controller: passController,
                    keyboardType: TextInputType.text,
                    placeholder: "Пароль",
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xff007AFF), width: 3),
                  color: const Color(0xff007AFF),
                  //color: Colors.red,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(10)),
                ),
                child: CupertinoButton(
                  onPressed: () async {
                    bool isLogged = await singMeIn();
                    if(isLogged){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const mainPage()));
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: const Center(
                      child: Text('Войти',
                          style: TextStyle(
                              fontSize: 14, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
