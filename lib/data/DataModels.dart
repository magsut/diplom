import 'dart:convert';


class Car{
  static int countId = 0;
  int id = countId++;
  String name;
  String imagePath;
  int cost;
  List<Spending> spending = [];
  int millage;
  bool isServiceNotUpload = false;
  carService CarService = carService('', '', '', '', '', '');
  String operating_mode;

  Car(this.name, this.imagePath, this.cost, this.operating_mode, [this.millage = 0]);

  factory Car.fromJson(Map<String, dynamic> json){
    return Car(
        json['name'],
        json['imagePath'],
        json['cost'],
        json['operating_mode'],
        json['millage']);
  }

  Map<String, dynamic> toJson(){
    return {
      'id' : id,
      'name' : name,
      'imagePath' : imagePath,
      'cost' : cost,
      'millage' : millage,
      'isServiceNotUpload' : isServiceNotUpload,
      'operating_mode' : operating_mode,
      'CarService' : CarService.toJson(),
      'spending' : jsonEncode(spending)
    };
  }

  @override
  String toString() {
    return 'Car{name: $name, imagePath: $imagePath, cost: $cost, spending: $spending, millage: $millage, isServiceNotUpload: $isServiceNotUpload, CarService: $CarService}';
  }
}

class OperatingModes{
  int id;
  String mode;

  OperatingModes(this.id, this.mode);

  factory OperatingModes.fromJson(Map<String, dynamic> json){
    return OperatingModes(json['idoperating_modes'], json['mode']);
  }
}

class SpendingTypes{
  int id;
  String type;

  SpendingTypes(this.id, this.type);

  factory SpendingTypes.fromJson(Map<String, dynamic> json){
    return SpendingTypes(json['idspendingType'], json['type']);
  }
}

class Spending{
  String name;
  String description;
  String type;
  bool isPlanned;
  int cost;
  DateTime date;
  int millage;

  Spending(this.name, this.description, this.type, this.isPlanned, this.cost, this.date, this.millage);

  factory Spending.fromJson(Map<String, dynamic> json){
    return Spending(
        json['name'],
        json['description'],
        json['type'],
        json['isPlanned'],
        json['cost'],
        DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'].toString())),
        json['millage']);
  }

  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'description' : description,
      'type' : type,
      'isPlanned' : isPlanned,
      'cost' : cost,
      'date' : date.millisecondsSinceEpoch,
      'millage' : millage
    };
  }

  @override
  String toString() {
    return 'Spending{name: $name, description: $description, type: $type, isPlanned: $isPlanned, cost: $cost, date: $date, millage: $millage}';
  }
}

class carService{
  String manufacturer;
  String model;
  String start_year;
  String end_year;
  String generation;
  String petrol_type;
  List<Service> services = [];

  carService(this.manufacturer, this.model, this.start_year, this.end_year, this.petrol_type, this.generation);

  Map<String, dynamic> toJson(){
    return {
      "manufacturer" : manufacturer,
      "model" : model,
      "start_year" : start_year,
      "end_year" : end_year,
      "generation" : generation,
      "petrol_type" : petrol_type,
      "services" : jsonEncode(services)
    };
  }

  factory carService.fromJson(Map<String, dynamic> json) {
    return carService(
        json['manufacturer'],
        json['model'],
        json['start_year'],
        json['end_year'],
        json['petrol_type'],
        json['generation']);
  }
}

class Service{
  String title;
  int period;
  bool isEnable = true;

  Service(this.title, this.period);

  @override
  String toString() {
    return 'Service{title: $title, period: $period}';
  }

  factory Service.fromJson(Map<String, dynamic> json){
    return Service(
    json['title'] as String,
    int.parse(json['period'].toString()));
  }

  Map<String, String> toJson(){
    return {
      'title' : title,
      'period': period.toString()
    };
  }
}

