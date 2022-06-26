import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/pages/CarService.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import 'package:flutter_app/utils/ServerMethods.dart';

import '../data/DataModels.dart';

class CarPage extends StatefulWidget {
  final Car car;
  final Function callback;
  final List<OperatingModes> modes;

  const CarPage({Key? key, required this.car, required this.callback, required this.modes}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  late TextEditingController nameController;

  late TextEditingController costController;

  late TextEditingController millageController;

  late TextEditingController editingDateController;

  late String selectedMode;

  @override
  Widget build(BuildContext context) {
    String name = widget.car.name;
    String cost = widget.car.cost.toString();
    String millage = widget.car.millage.toString();
    //String editingDate = widget.car.editingDate.toString();

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(
                    widget.car.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    onPressed: () {
                      UserData userData = UserData();
                      String json = jsonEncode(userData.toJson());
                      print(json);
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => CarService(car: widget.car, callback: setState,)
                          )
                        );
                      },
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: const Color(0xff007AFF),
                    child: const SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          'Обслуживание',
                          style: TextStyle(
                            color: Color(0xffF2F2F7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color(0xffF2F2F7),
                  child: Image.network('http://192.168.0.121:3000/getCarPhoto/' + widget.car.imagePath, width: 287, height: 117,)
              ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Text(
                      "Название:",
                      style: TextStyle(
                        color: Color(0xff6C6C70),
                        fontSize: 17
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
                          placeholder: name,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        )),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Text(
                      "Стоимость:",
                      style: TextStyle(
                        color: Color(0xff6C6C70),
                        fontSize: 17
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
                          placeholder: cost,
                          controller: costController,

                          keyboardType: TextInputType.number,
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        )),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: Text(
                      "Пробег:",
                      style: TextStyle(
                          color: Color(0xff6C6C70),
                          fontSize: 17
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
                          placeholder: millage,
                          controller: millageController,
                          keyboardType: TextInputType.number,
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        )),
                  ),
                  const Divider(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xff007AFF), width: 3),
                        color: const Color(0xffFFFFFF),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          ServerMethods.updateUserCar(nameController.text, int.parse(costController.text),
                              int.parse(millageController.text),
                              widget.modes.firstWhere((element) => element.mode == selectedMode).id,
                              widget.car.id);
                          for(int i = 0; i < UserData.userCars.length; i++){
                            if(UserData.userCars[i].id == widget.car.id){
                              try{
                                UserData.userCars[i].name = nameController.text;
                                UserData.userCars[i].cost = int.parse(costController.text);
                                UserData.userCars[i].millage = int.parse(millageController.text);
                                UserData.userCars[i].operating_mode = selectedMode;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Данные сохранены')));
                                HelperFunctions.saveUserDataSharedPreference();

                                Navigator.pop(context);
                              } catch(e){
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Ошибка'),
                                        content: const Text('Данные введены не корректно'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ]));
                              }
                              widget.callback(() {});
                              break;
                            }
                          }
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .85 - 10,
                          child: const Center(
                            child: Text(
                                'Сохранить',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop();
                  },
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: const Color(0xff007AFF),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .85,
                    height: 50,
                    child: const Center(
                      child: Text(
                        'Назад',
                        style: TextStyle(
                          color: Color(0xffF2F2F7),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.car.name);
    costController = TextEditingController(text: widget.car.cost.toString());
    millageController = TextEditingController(text: widget.car.millage.toString());
    selectedMode = widget.car.operating_mode;
    //editingDateController = TextEditingController(text: widget.car.editingDate.toString());
  }
}


