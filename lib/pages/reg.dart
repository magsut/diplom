import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/MainPage.dart';
import 'package:flutter_app/pages/loading.dart';
import 'package:flutter_app/utils/ServerMethods.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/HelperFunctions.dart';

class Registr extends StatefulWidget {
  const Registr({Key? key}) : super(key: key);

  @override
  State<Registr> createState() => _AuthoriseState();
}

class _AuthoriseState extends State<Registr> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passTController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Ошибка загрузки фото: $e');
    }
  }

  Future<bool> singMeUp() async {
    setState(() {
      isLoading = true;
    });

    try{

      String data = "";

      if(image == null){
        data = await ServerMethods.addUserWithDefIm(passController.text, emailController.text);
      } else {
        data = await ServerMethods.addUser(passController.text, emailController.text, image!);
      }

      if(data == "No data"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Registr()));
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Text('Ошибка'),
                content: const Text('E-mail или пароль занят или введён неверно'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'),
                  ),
                ]));
        return false;
      } else if(data == "Server error"){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Registr()));
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: const Text('Ошибка'),
                content: const Text('Ошибка сервера. Попробуйте заного'),
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

        UserData.isAuthorise = true;
        UserData.isLogged = true;
        UserData.token = Data['token'];
        UserData.userphoto = Data['photo'];

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserAuthorisedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(usernameController.text);
        HelperFunctions.saveUserDataSharedPreference();

        return true;
      }
    } catch(e){
      print(e.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Registr()));
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
    return isLoading? const Loading(): Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: Text(
                  'SMART CAR OWNER',
                  style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff007AFF)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(
                        118, 118, 128, 0.12), //color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 36,
                  child: CupertinoTextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    placeholder: "Имя",
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(
                        118, 118, 128, 0.12), //color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 36,
                  child: CupertinoTextField(
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    placeholder: "Пароль",
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(
                        118, 118, 128, 0.12), //color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 36,
                  child: CupertinoTextField(
                    controller: passTController,
                    keyboardType: TextInputType.visiblePassword,
                    placeholder: "Повторите пароль",
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, top: 30, right: 30),
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: image != null
                    ? Container(child: Image.file(image!))
                    : const Image(
                        image: AssetImage('assets/uploadPhotos.png'),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff007AFF), width: 3),
                  color: const Color(0xff007AFF),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: CupertinoButton(
                  onPressed: () async {
                    if (passController.text == passTController.text) {
                      bool isReg = await singMeUp();
                      if(isReg){
                        HelperFunctions.saveUserDataSharedPreference();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const mainPage()));
                      }
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  title: Text('Ошибка'),
                                  content: Text('Пароли не совпадают'),
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .9,
                    child: const Center(
                      child: Text('Зарегистрироваться',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
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
