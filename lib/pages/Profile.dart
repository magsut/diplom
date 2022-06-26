import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/Setings.dart';
import 'package:flutter_app/pages/login.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import '../data/UserData.dart';
import 'MainPage.dart';

class Profile extends StatefulWidget {
  Profile(
      {Key? key,
      required this.isAuthorise,
      required this.login,
      required this.name,
      required this.path,
      required this.parent})
      : super(key: key);

  bool isAuthorise;
  String name;
  String login;
  int parent;
  String path;

  @override
  State<Profile> createState() =>
      _ProfileState(isAuthorise, name, login, parent, path);
}

class _ProfileState extends State<Profile> {
  bool isAuthorise;
  String name;
  String email;
  int parent;
  String path;

  _ProfileState(this.isAuthorise, this.name, this.email, this.parent, this.path);

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
                    width: 170,
                    child: Center(
                      child: Text(
                        "Профиль",
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
                                  child: Center(child: Image.network('http://192.168.0.121:3000/getUserPhoto/' + UserData.userphoto, fit: BoxFit.cover)),
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
                                  email,
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
                Visibility(
                    visible: isAuthorise,
                    child: Column(
                      children: [
                        /*Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffF2F2F7),
                                //color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CupertinoButton(
                                onPressed: () {},
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.925,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Изменить пароль'),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffF2F2F7),
                                //color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CupertinoButton(
                                onPressed: () {},
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.925,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Изменить login'),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),*/
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffF2F2F7),
                                //color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  UserData.isLogged = false;
                                  UserData.isAuthorise = false;
                                  UserData.userCars = [];
                                  UserData.userphoto = '';
                                  UserData.token = '';
                                  HelperFunctions.saveUserDataSharedPreference();
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => const login(),
                                  ));
                                },
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.925,
                                  child: const Center(
                                    child: Text(
                                      'Выйти из аккаунта',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                Visibility(
                  visible: !isAuthorise,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F7),
                          //color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => login()));
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.925,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Авторизироваться'),
                                Icon(Icons.arrow_forward_ios)
                              ],
                            ),
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
                                case 2:
                                  {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (context) => mainPage()));
                                  }
                              }
                            },
                            icon: const Icon(
                              Icons.home_outlined,
                              color: Color(0xff6C6C70),
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.account_circle_outlined,
                              color: Color(0xff007AFF),
                            )),
                        IconButton(
                            onPressed: () async {
                              var noticeSettings = await HelperFunctions
                                  .getNoticeSettingsSharedPreference();
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => Setings(
                                        name: name,
                                        login: email,
                                        parent: 1,
                                        selectedMode: noticeSettings != null? noticeSettings as bool: false,
                                    path: path,
                                      )));
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Color(0xff6C6C70),
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
