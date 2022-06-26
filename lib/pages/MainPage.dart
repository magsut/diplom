// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/AddCar.dart';
import 'package:flutter_app/pages/AddPlannedSpending.dart';
import 'package:flutter_app/pages/AddSpending.dart';
import 'package:flutter_app/pages/CarPage.dart';
import 'package:flutter_app/pages/Profile.dart';
import 'package:flutter_app/pages/Spendings.dart';
import 'package:flutter_app/pages/Statistic.dart';
import 'package:flutter_app/utils/ServerMethods.dart';

import '../data/DataModels.dart';
import '../utils/HelperFunctions.dart';
import 'Setings.dart';

// ignore: camel_case_types
class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);

  @override
  _mainPageState createState() => _mainPageState();
}

// ignore: camel_case_types
class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                //color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, .04),
                      blurRadius: 5,
                      offset: Offset(0, 10))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    width: 150,
                    child: Center(
                      child: Text(
                        "Главная",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 52,
                  child: ListView(
                    shrinkWrap: true,
                    addRepaintBoundaries: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Spendings()));
                          },
                          elevation: 0,
                          color: Color(0xffF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Text(
                            "Узнать расходы на авто",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff007AFF)),
                          ),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          var data = await ServerMethods.getSpendingTypes();
                          if(data != "Error") {
                            var Data = jsonDecode(data);
                            List<SpendingTypes> types = [];
                            for(var type in Data){
                              types.add(SpendingTypes.fromJson(type));
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddPlannedSpending(types: types,)));
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Ошибка'),
                                    content: Text(
                                        'Ошибка получения данных'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ]));
                          }

                        },
                        elevation: 0,
                        color: Color(0xffF2F2F7),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Text(
                          "Запланировать расходы",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff007AFF)),
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: RaisedButton(
                          onPressed: () {
                            if(UserData.userCars.isNotEmpty){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Statistic()));
                            }
                          },
                          elevation: 0,
                          color: Color(0xffF2F2F7),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Text(
                            "Посмотреть статистику",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff007AFF)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () async {
                      var data = await ServerMethods.getSpendingTypes();
                      if(data != "Error"){
                        var Data = jsonDecode(data);
                        List<SpendingTypes> types = [];
                        for(var type in Data){
                          types.add(SpendingTypes.fromJson(type));
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddSpending(types: types)));
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: const Text('Ошибка'),
                                content: Text(
                                    'Ошибка получения данных'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ]));
                      }

                    },
                    elevation: 0,
                    color: Color(0xffF2F2F7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .85,
                      child: Center(
                        child: Text(
                          "Добавить имеющиеся расходы +",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff007AFF)),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 740,
              child: ListView.builder(
                semanticChildCount: UserData.userCars.length,
                itemCount: UserData.userCars.length,
                  itemBuilder: (BuildContext context, int i) {
                    return CarCard(callback: setState, car: UserData.userCars[i]);
                  }
              ),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              var data = await ServerMethods.getOperatingModes();
              if(data != "Error"){
                var Data = jsonDecode(data);
                List<OperatingModes> modes = [];
                for(var Mode in Data){
                  modes.add(OperatingModes.fromJson(Mode));
                }
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AddCar(callback: setState, modes: modes)));
              } else{
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content: Text(
                            'Ошибка получения данных'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ]));
              }
              
            },
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            color: Color(0xff007AFF),
            child: Container(
              width: MediaQuery.of(context).size.width * .85,
              child: Center(
                child: Text(
                  'Добавить автомобиль   +',
                  style: TextStyle(
                    color: Color(0xffF2F2F7),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width * .95,
              decoration: BoxDecoration(
                  //color: Color(0xffFFFFFF),
                  color: Color(0xffF2F2F7),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Color(0xffF2F2F7), blurRadius: 20)
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: 48, right: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.home_outlined,
                          color: Color(0xff007AFF),
                        )),
                    IconButton(
                        onPressed: () async {
                          var isAuthorise = await HelperFunctions
                              .getUserAuthorisedInSharedPreference();
                          var n = await HelperFunctions
                              .getUserNameSharedPreference();
                          var l = await HelperFunctions
                              .getUserEmailSharedPreference();
                          String name = '';
                          String login = '';
                          String path = 'default';
                          if (isAuthorise != null) {
                            if(isAuthorise as bool){
                              name = n ?? "Пользователь";
                              login = l ?? "Пользователь";
                              path = UserData.userphoto;
                            }
                          }

                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => Profile(
                                  isAuthorise: isAuthorise != null? isAuthorise as bool: false,
                                  name: name,
                                  login: login,
                                  path: path,
                                  parent: 0)));
                        },
                        icon: Icon(
                          Icons.account_circle_outlined,
                          color: Color(0xff6C6C70),
                        )),
                    IconButton(
                        onPressed: () async {
                          var isAuthorise = await HelperFunctions
                              .getUserAuthorisedInSharedPreference();
                          var n = await HelperFunctions
                              .getUserNameSharedPreference();
                          var l = await HelperFunctions
                              .getUserEmailSharedPreference();
                          String name = '';
                          String login = '';
                          String path = 'default';
                          if (isAuthorise != null){
                            if (isAuthorise as bool) {
                              name = n ?? "Пользователь";
                              login = l ?? "Пользователь";
                              path = UserData.userphoto;
                            }
                          }

                          var noticeSettings = await HelperFunctions
                            .getNoticeSettingsSharedPreference();
                        Navigator.of(context)
                            .push(CupertinoPageRoute(
                            builder: (context) => Setings(
                              name: name,
                              login: login,
                              parent: 0,
                              selectedMode: noticeSettings != null? noticeSettings as bool: false,
                              path: path,
                            )));},
                        icon: Icon(
                          Icons.settings,
                          color: Color(0xff6C6C70),
                        )),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class CarCard extends StatefulWidget {
  final Function callback;
  final Car car;

  const CarCard({Key? key, required this.callback, required this.car})
      : super(key: key);

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: GestureDetector(
          onTap: () async {
            var data = await ServerMethods.getOperatingModes();
            if(data != "Error"){
              var Data = jsonDecode(data);
              List<OperatingModes> modes = [];
              for(var Mode in Data){
                modes.add(OperatingModes.fromJson(Mode));
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CarPage(car: widget.car, callback: setState, modes: modes)));

            } else {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: const Text('Ошибка'),
                      content: Text(
                          'Ошибка получения данных'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK'),
                        ),
                      ]));
            }},
          child: Container(
            height: 190,
            decoration: BoxDecoration(
                color: Color(0xffF2F2F7),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Color(0xffF2F2F7), blurRadius: 20)]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Color(0xffF2F2F7),
                    child:Image.network('http://192.168.0.121:3000/getCarPhoto/' + widget.car.imagePath, width: 287, height: 117,)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 260,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(widget.car.name,
                              style:
                                  TextStyle(color: Color(0xff6C6C70), fontSize: 24)),
                        ),
                      ),
                      IconButton(
                        iconSize: 30,
                        splashRadius: 10,
                        icon: Icon(Icons.keyboard_control_outlined),
                        onPressed: (){
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    content: Text('Хотите удалить авто из списка?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          UserData.userCars.remove(UserData.userCars.firstWhere((element) => element.name == widget.car.name));
                                          HelperFunctions.saveUserDataSharedPreference();
                                          ServerMethods.deleteUserCar(widget.car.id);
                                          widget.callback(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Да'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Нет', style: TextStyle(color: Colors.red),),
                                      )]

                                ));
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
