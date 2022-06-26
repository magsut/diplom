import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/DataModels.dart';
import 'package:flutter_app/utils/ServerMethods.dart';

import '../data/UserData.dart';
import '../utils/HelperFunctions.dart';

class AddSpending extends StatefulWidget {
  const AddSpending({Key? key, required this.types}) : super(key: key);

  final List<SpendingTypes> types;

  @override
  State<AddSpending> createState() => _AddSpendingState();
}

class _AddSpendingState extends State<AddSpending> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController millageController = TextEditingController();
  TextEditingController costController = TextEditingController();

  List<String> CarNames = UserData.userCars
      .map((e) => e.name.length > 35 ? e.name.substring(0, 35) + "..." : e.name)
      .toList();

  var selectedType;
  var selectedCar;
  var selectedPetrolType;
  var selectedFielQuality;
  bool isRefueling = false;
  bool oil_change = false;

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
              child: Column(
            children: [
              Expanded(
                  child: ListView(
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
                    padding: EdgeInsets.all(16.0),
                    child: Text("Добавить имеющиеся расходы",
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
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
                        height: 45,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none),
                          hint: const Text('  Автомобиль'),
                          items: CarNames.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("  " + value),
                            );
                          }).toList(),
                          value: selectedCar,
                          onChanged: (value) {
                            setState(() {
                              selectedCar = value.toString();
                            });
                          },
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
                          controller: titleController,
                          keyboardType: TextInputType.text,
                          placeholder: "Название",
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
                          controller: descriptionController,
                          keyboardType: TextInputType.text,
                          placeholder: "Описание",
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
                          controller: millageController,
                          keyboardType: TextInputType.number,
                          placeholder: "Пробег",
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
                        height: 45,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none),
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text('Тип'),
                          ),
                          items: widget.types
                              .map((e) => e.type)
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                          value: selectedType,
                          onChanged: (value) {
                            setState(() {
                              isRefueling = value.toString() == "Заправка";
                              oil_change = value.toString() == "Замена масла";
                              selectedType = value.toString();
                            });
                          },
                        )),
                  ),
                  Visibility(
                    child: Padding(
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
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text('Тип топлива'),
                            ),
                            items: <String>[
                              "ДТ",
                              "АИ-92",
                              "АИ-95",
                              "АИ-98",
                              "АИ-100",
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                            value: selectedPetrolType,
                            onChanged: (value) {
                              setState(() {
                                selectedPetrolType = value.toString();
                              });
                            },
                          )),
                    ),
                    visible: isRefueling,
                  ),
                  Visibility(
                    child: Padding(
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
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text('Качество топлива'),
                            ),
                            items: <String>[
                              "Высокое",
                              "Среднее",
                              "Низкое",
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                            value: selectedFielQuality,
                            onChanged: (value) {
                              setState(() {
                                selectedFielQuality = value.toString();
                              });
                            },
                          )),
                    ),
                    visible: isRefueling,
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
                          controller: costController,
                          keyboardType: TextInputType.number,
                          placeholder: "Стоимость",
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 32, left: 16, right: 16),
                    child: RaisedButton(
                      onPressed: () async {
                        if (selectedCar != null &&
                            selectedType != null &&
                            titleController.text.isNotEmpty &&
                            costController.text.isNotEmpty) {
                          for (var car in UserData.userCars) {
                            if (car.name == selectedCar) {
                              ServerMethods.addSpending(
                                  car.id,
                                  titleController.text,
                                  descriptionController.text,
                                  false,
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  int.parse(millageController.text),
                                  selectedType,
                                  int.parse(costController.text));

                              if(selectedType == "Заправка"){
                                ServerMethods.addRefueling(car.id,
                                                          selectedFielQuality == "Высокое" ? 2 : selectedFielQuality == "Среднее"? 1 : 0,
                                                          millageController.text,
                                                          DateTime.now().millisecondsSinceEpoch.toString(),
                                                          selectedPetrolType);
                              } else if (selectedType == "Замена масла"){
                                ServerMethods.addOilChange(car.id,
                                                          millageController.text,
                                                          DateTime.now().millisecondsSinceEpoch.toString());
                              }

                              car.spending.add(Spending(
                                  titleController.text,
                                  descriptionController.text,
                                  selectedType,
                                  false,
                                  int.parse(costController.text),
                                  DateTime.now(),
                                  int.parse(millageController.text)));
                              break;
                            }
                          }
                          print(UserData.userCars);
                          HelperFunctions.saveUserDataSharedPreference();
                          Navigator.of(context).pop();
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Ошибка'),
                                      content: const Text('Введите все данные'),
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
                      child: const SizedBox(
                        child: Center(
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
              ))
            ],
          )),
        ],
      ),
    );
  }
}
