import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/MainPage.dart';
import 'package:flutter_app/pages/loading.dart';
import 'package:flutter_app/pages/reg.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import 'package:firebase_core/firebase_core.dart';


import 'Auth.dart';

class login extends StatelessWidget {
  const login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: const Image(
                        image: AssetImage('assets/carlogin_car.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: 240,
                      decoration: const BoxDecoration(
                          color: Color(0xffFFFFFF),
                          //color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .04),
                                blurRadius: 5,
                                offset: Offset(0, -10))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 22, bottom: 22),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'Добро пожаловать',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 18, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xff007AFF), width: 3),
                                      color: const Color(0xffFFFFFF),
                                      //color: Colors.red,
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Authorise()));
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * .85 / 2 - 10,
                                        child: const Center(
                                          child: Text('Войти',
                                              style: TextStyle(fontSize: 14)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xff007AFF), width: 3),
                                      color: const Color(0xff007AFF),
                                      //color: Colors.red,
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Registr()));
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * .85 / 2 - 10,
                                        child: const Center(
                                          child: Text('Зарегистрироваться',
                                              style: TextStyle(
                                                  fontSize: 14, color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 2,
                                    width: 133,
                                    color: Colors.black.withOpacity(.05),
                                  ),
                                  Text(
                                    'Или',
                                    style:
                                    TextStyle(color: Colors.black.withOpacity(0.1)),
                                  ),
                                  Container(
                                    height: 2,
                                    width: 133,
                                    color: Colors.black.withOpacity(.05),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 3),
                                  color: const Color(0xffFFFFFF),
                                  //color: Colors.red,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    HelperFunctions.saveUserLoggedInSharedPreference(true);
                                    HelperFunctions.saveUserAuthorisedInSharedPreference(false);
                                    HelperFunctions.saveNoticeSettingsSharedPreference(true);
                                    UserData.isLogged = true;
                                    UserData.isAuthorise = false;
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const mainPage(),));
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * .85 + 10,
                                    child: const Center(
                                      child: Text('Продолжить без аккаунта',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if(snapshot.hasError){
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                    title: const Text('Ошибка'),
                    content: const Text('Нет соединения с сервером'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          HelperFunctions.saveUserLoggedInSharedPreference(true);
                          HelperFunctions.saveUserAuthorisedInSharedPreference(false);
                          HelperFunctions.saveNoticeSettingsSharedPreference(true);
                          UserData.isLogged = true;
                          UserData.isAuthorise = false;
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const mainPage(),));

                        },
                        child: const Text('Проделжить без аккаунта'),
                      ),
                    ]));
          }
          return Loading();
        },
        /*child: ,*/
      ),
    );
  }
}
