import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/MainPage.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'Profile.dart';


class Setings extends StatefulWidget {
  Setings({Key? key,required this.login,
    required this.name,
    required this.parent,
  required this.selectedMode,
  required this.path}) : super(key: key);

  String name;
  String login;
  int parent;
  bool selectedMode;
  String path;

  @override
  State<Setings> createState() => _SetingsState(name, login, parent, selectedMode, path);
}

class _SetingsState extends State<Setings> {

  String name;
  String login;
  int parent;
  bool selectedMode = true;
  String path;

  _SetingsState(this.name, this.login, this.parent, this.selectedMode, this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text(
                        "Настройки",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffF2F2F7),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: 68,
                      width: MediaQuery.of(context).size.width * 0.925,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Image.network('http://192.168.0.121:3000/getUserPhoto/' + UserData.userphoto, fit: BoxFit.cover),
                                ),
                                Container(
                                  width: 64,
                                  height: 68,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(
                                          color: const Color(0xffF2F2F7),
                                          width: 8)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      color: Color(0xff6C6C70),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  login,
                                  style: const TextStyle(
                                      color: Color(0xff6C6C70),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffF2F2F7),
                        //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: CupertinoButton(
                        onPressed: () {},
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.925,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Уведомления'),
                              SizedBox(
                                width: 70,
                                child: NeumorphicSwitch(
                                  value: selectedMode,
                                  style: const NeumorphicSwitchStyle(
                                      thumbShape: NeumorphicShape.flat
                                    //or convex, concave
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      HelperFunctions.saveNoticeSettingsSharedPreference(value);
                                      selectedMode = value;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: BoxDecoration(
                      color: const Color(0xffF2F2F7),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Color(0xffF2F2F7), blurRadius: 20)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 48, right: 48),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () async {
                              switch (parent) {
                                case 0:
                                  {
                                    Navigator.of(context).pop();
                                    break;
                                  }
                                case 1:
                                  {
                                    Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                        builder: (context) => mainPage()));
                                  }
                              }
                            },
                            icon: const Icon(
                              Icons.home_outlined,
                              color: Color(0xff6C6C70),
                            )),
                        IconButton(
                            onPressed: () async {
                              switch (parent) {
                                case 0:
                                  {
                                    var isAuthorise = await HelperFunctions
                                        .getUserAuthorisedInSharedPreference();
                                    Navigator.of(context).push(CupertinoPageRoute(
                                        builder: (context) => Profile(
                                            isAuthorise: isAuthorise != null? isAuthorise as bool: false,
                                            name: name,
                                            login: login,
                                            path: path,
                                            parent: 2)));
                                  }
                                  break;
                                case 1:
                                  {
                                    Navigator.of(context).pop();
                                  }
                              }},
                            icon: const Icon(
                              Icons.account_circle_outlined,
                              color: Color(0xff6C6C70),
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              color: Color(0xff007AFF),
                            )),
                      ],
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
