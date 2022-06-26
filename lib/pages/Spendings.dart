import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/HelperFunctions.dart';
import 'package:intl/intl.dart';
import '../data/DataModels.dart';
import '../data/UserData.dart';

class Spendings extends StatefulWidget {
  const Spendings({Key? key}) : super(key: key);

  @override
  State<Spendings> createState() => _SpendingsState();
}

class _SpendingsState extends State<Spendings> {
  List<String> carNames = UserData.userCars.map((e) => e.name).toList();

  int selectedCar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 98,
              width: double.infinity,
              decoration: const BoxDecoration(
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
              //color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 170,
                    child: Center(
                      child: Text(
                        "Расходы",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 52,
                      child: carNames.isNotEmpty? ListView.builder(
                          shrinkWrap: true,
                          addRepaintBoundaries: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: carNames.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: RaisedButton(
                                onPressed: () {
                                  selectedCar = i;
                                  setState(() {});
                                },
                                elevation: 0,
                                color: i == selectedCar
                                    ? const Color(0xff007AFF)
                                    : const Color(0xffF2F2F7),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                child: Text(
                                  carNames[i],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: i == selectedCar
                                          ? const Color(0xffF2F2F7)
                                          : const Color(0xff007AFF)),
                                ),
                              ),
                            );
                          }): Container())
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 740,
                child: carNames.isNotEmpty? ListView.builder(
                    semanticChildCount:
                        UserData.userCars[selectedCar].spending.length,
                    itemCount: UserData.userCars[selectedCar].spending.length,
                    itemBuilder: (BuildContext context, int i) {
                      return spendingCard(
                        spending: UserData.userCars[selectedCar].spending[i],
                        callBack: setState,
                        car: selectedCar,
                      );
                    }) : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
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
          ],
        ),
      ),
    );
  }
}

class spendingCard extends StatelessWidget {
  Spending spending;
  Function callBack;
  int car;

  spendingCard(
      {Key? key, required this.spending, required this.callBack, required this.car})
      : super(key: key);

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: spending.isPlanned? const Color(0xff007AFF) : const Color(0xffF2F2F7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Color(0xffF2F2F7), blurRadius: 20)]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SizedBox(
                  width: 300,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(spending.name,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SizedBox(
                  width: 300,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(spending.description,
                        style: TextStyle(
                            color: !spending.isPlanned? Color(0xff007AFF) : Color(0xffF2F2F7), fontSize: 20)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: SizedBox(
                  width: 300,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(spending.cost.toString() + " руб",
                        style: TextStyle(
                            color: !spending.isPlanned? Color(0xff007AFF) : Color(0xffF2F2F7), fontSize: 16)),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8, right: 8),
                    child: SizedBox(
                      width: 260,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text(formatter.format(spending.date) + " | ",
                                style: TextStyle(
                                    color: !spending.isPlanned? Color(0xff007AFF) : Color(0xffF2F2F7), fontSize: 16)),
                            Text(spending.millage.toString() + " км",
                                style: TextStyle(
                                    color: !spending.isPlanned? Color(0xff007AFF) : Color(0xffF2F2F7), fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: spending.isPlanned,
                      child: IconButton(
                        icon: Icon(Icons.done_outline_rounded),
                        onPressed: () {
                          UserData.userCars[car].spending.firstWhere((element) => jsonEncode(element) == jsonEncode(spending)).isPlanned = false;
                          HelperFunctions.saveUserDataSharedPreference();
                          callBack(() {});
                        },
                      )
                  )
                ],
              )
            ],
          ),
        ));
  }
}
