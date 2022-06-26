import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../data/DataModels.dart';
import '../utils/HelperFunctions.dart';
import '../utils/ServerMethods.dart';

class AddPlannedSpending extends StatefulWidget {
  const AddPlannedSpending({Key? key, required this.types}) : super(key: key);

  final List<SpendingTypes> types;

  @override
  State<AddPlannedSpending> createState() => _AddPlannedSpendingState();
}

class _AddPlannedSpendingState extends State<AddPlannedSpending> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController millageController = TextEditingController();

  List<String> CarNames = UserData.userCars
      .map((e) => e.name.length > 35 ? e.name.substring(0, 35) + "..." : e.name)
      .toList();

  var selectedType;
  var selectedCar;
  var selectedPetrolType;
  var selectedFielQuality;
  bool isRefueling = false;
  bool oil_change = false;
  DateTime? _selectedDate;

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
                    child: Text("Запланировать расходы расходы",
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
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text('Автомобиль'),
                          ),
                          items: CarNames.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(value),
                              ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(
                            118, 118, 128, 0.12), //color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: DatePickerWidget(
                        looping: false, // default is not looping
                        firstDate: DateTime.now(),
                        dateFormat: "dd/MMMM/yyyy",
                        locale: DatePicker.localeFromString('ru'),

                        onChange: (DateTime newDate, _) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                          print(_selectedDate);
                        },
                        pickerTheme: const DateTimePickerTheme(
                            itemTextStyle:
                                TextStyle(color: Colors.black, fontSize: 19),
                            dividerColor: Colors.transparent,
                            backgroundColor: Color(0xffF2F2F7),
                            pickerHeight: 130,
                            itemHeight: 40),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: RaisedButton(
                  onPressed: () {
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
                              true,
                              _selectedDate!.millisecondsSinceEpoch.toString(),
                              int.parse(millageController.text),
                              selectedType,
                              int.parse(costController.text));

                          if(selectedType == "Заправка"){
                            ServerMethods.addRefueling(car.id,
                                selectedFielQuality == "Высокое" ? 2 : selectedFielQuality == "Среднее"? 1 : 0,
                                millageController.text,
                                _selectedDate!.millisecondsSinceEpoch.toString(),
                                selectedPetrolType);
                          } else if (selectedType == "Заена масла"){
                            ServerMethods.addOilChange(car.id,
                                millageController.text,
                              _selectedDate!.millisecondsSinceEpoch.toString(),);
                          }

                          car.spending.add(Spending(
                              titleController.text,
                              descriptionController.text,
                              selectedType,
                              true,
                              int.parse(costController.text),
                              _selectedDate!,
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
          )),
        ],
      ),
    );
  }
}
