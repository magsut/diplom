import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import 'package:flutter_app/utils/ServerMethods.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../data/DataModels.dart';
import '../data/UserData.dart';

class AddCar extends StatefulWidget {
  final Function callback;
  final List<OperatingModes> modes;

  const AddCar({Key? key, required this.callback, required this.modes})
      : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  File? image;

  var selectedMode;

  TextEditingController titleController = TextEditingController();
  TextEditingController costController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xffF2F2F7),
          ),
          SafeArea(
              child: Container(
            height: MediaQuery.of(context).size.height * .95,
            child: ListView(
              children: <Widget>[
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width - 50,
                      ),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.arrow_back_ios))),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Добавить автомобиль",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                118, 118, 128, 0.12), //color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 36,
                          child: CupertinoTextField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            placeholder: "Название",
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                118, 118, 128, 0.12), //color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 36,
                          child: CupertinoTextField(
                            controller: costController,
                            keyboardType: TextInputType.number,
                            placeholder: "Стоимость",
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                118, 118, 128, 0.12), //color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 45,
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                enabledBorder: InputBorder.none),
                            hint: Text('  Режим эксплуатации'),
                            items: widget.modes
                                .map((e) => e.mode)
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: selectedMode,
                            onChanged: (value) {
                              setState(() {
                                selectedMode = value.toString();
                              });
                            },
                          )),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 30, top: 30, right: 30),
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16, top: 50, left: 16, right: 16),
                  child: RaisedButton(
                    onPressed: () async {
                      var name = titleController.text;
                      if (name.isNotEmpty || selectedMode != null || costController.text.isNotEmpty) {
                        try{
                          int cost = int.parse(costController.text);

                          int mode = widget.modes.firstWhere((element) => element.mode == selectedMode).id;

                          var data;

                          if (image != null) {
                            data = await ServerMethods.addUserCar(name, cost, 0, UserData.token, image!, mode);
                          } else {
                            data = await ServerMethods.addUserCarWithDefIm(name, cost, 0, UserData.token, mode);
                          }

                          if(data != "Error"){
                            var Data = jsonDecode(data);

                            Car newCar = Car(name, Data['path'], cost, selectedMode);

                            newCar.id = Data['id'];

                            UserData.userCars.add(newCar);

                            HelperFunctions.saveUserDataSharedPreference();

                            widget.callback(() {});

                            Navigator.of(context).pop();
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Ошибка'),
                                    content: const Text(
                                        'Ошибка добавления данных'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ]));
                          }
                        } catch(e){
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Ошибка'),
                                  content: Text(
                                      'Ошибка: ' + e.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ]));
                        }

                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Ошибка'),
                                    content: const Text(
                                        'Все поля должны быть обязательно заполнены'),
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
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: const Color(0xff007AFF),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .85,
                      child: const Center(
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                            color: Color(0xffF2F2F7),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
