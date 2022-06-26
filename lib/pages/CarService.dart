import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';
import 'package:flutter_app/utils/ServerMethods.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../data/DataModels.dart';

class CarService extends StatefulWidget {
  const CarService({Key? key, required this.car, required this.callback}) : super(key: key);

  @override
  State<CarService> createState() => _CarServiceState();

  final Car car;
  final Function callback;
}

class _CarServiceState extends State<CarService> {
  late TextEditingController manufacturer;
  late TextEditingController model;
  late TextEditingController generation;

  late String sost;

  bool isLoading = false;

  loadData() async {
    setState(() {
      isLoading = true;
    });

    try{
      String data = await ServerMethods.getServices(manufacturer.text, model.text, generation.text);

      var Data = jsonDecode(data);

      for(var service in Data){
        widget.car.CarService.services.add(Service.fromJson(service));
      }

      String s = await ServerMethods.getSost(manufacturer.text);

      sost = s == "1" ? "Возможен излишний износ" : s == '2' ? "Отличное состояние" : "Нормальное состояние";

      UserData.userCars.firstWhere((element) => element.id == widget.car.id).isServiceNotUpload = true;

      widget.car.isServiceNotUpload = true;
    } catch(e){
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  conditionAssessment(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff007AFF)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 32),
                          child: CupertinoTextField(
                            placeholder: "Производитель",
                            keyboardType: TextInputType.text,
                            controller: manufacturer,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 32),
                          child: CupertinoTextField(
                            placeholder: "Модель",
                            keyboardType: TextInputType.text,
                            controller: model,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width - 32),
                          child: CupertinoTextField(
                            placeholder: "Поколение",
                            keyboardType: TextInputType.text,
                            controller: generation,
                          ),
                        ),
                      ),
                      widget.car.isServiceNotUpload
                          ? Services(services: widget.car.CarService.services, condition: sost,)
                          : isLoading
                              ? const loading()
                              : Container(
                                  margin: const EdgeInsets.only(
                                      left: 70, top: 70, right: 70),
                                  child: GestureDetector(
                                    onTap: () {
                                      loadData();
                                    },
                                    child: Column(
                                      children: const [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Center(
                                            child: Text('Загрузить данные'),
                                          ),
                                        ),
                                        Center(
                                          child: Image(
                                            image:
                                                AssetImage('assets/upload.png'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        widget.callback(() {});
                        Navigator.of(context).pop();
                      },
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                      color: const Color(0xff007AFF),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .65,
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
                    IconButton(
                        onPressed: () {
                          loadData();
                        },
                        icon: const Icon(Icons.update))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    manufacturer = TextEditingController(
        text: widget.car.isServiceNotUpload
            ? widget.car.CarService.manufacturer
            : '');
    model = TextEditingController(
        text: widget.car.isServiceNotUpload ? widget.car.CarService.model : '');
    generation = TextEditingController(
        text: widget.car.isServiceNotUpload
            ? widget.car.CarService.generation
            : '');
  }
}

class Services extends StatefulWidget {
  Services({Key? key, required this.services, required this.condition}) : super(key: key);

  List<Service> services;
  final String condition;

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  getServicesList(){
    return widget.services.map((e) => ServiceCard(service: e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .85,
        decoration: const BoxDecoration(
          color: Color(0xffF2F2F7),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
              child: Text(
                'Состояние автомобиля: ' + widget.condition
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text(
                  'Регламент обслуживания: '
              ),
            ),
            Column(
              children: getServicesList(),
            )

          ],
        ),
      ),
    );
  }
}

class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Padding(
            padding: EdgeInsets.only(top: 200),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                color: Color(0xFFA7A7A7),
              ),
            )));
  }
}

class ServiceCard extends StatefulWidget {
  const ServiceCard({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();

  final Service service;
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          margin: const EdgeInsets.all(2),
          width: MediaQuery.of(context).size.width * .95,
          decoration: const BoxDecoration(
              color: Color(0xff007AFF),
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
                Text(
                  'Регламент: ' + widget.service.period.toString() + ' тыс.км. пробега',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

