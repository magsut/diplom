import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/utils/ServerMethods.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('Получение всех марок', () async {
    final result = await ServerMethods.getMarks();

    print(result);
    
    expect(result, '["AC","Acura","Aion","Alfa Romeo","Alpina","Alpine","AMC"]');
  });

  test('Получение всех моделей марки', () async {
    final result = await ServerMethods.getModelsFromMark('Alpina');

    print(result);

    expect(result, '["B10","B11","B12","B3","B4","B5","B6","B7","B8","C1","C2","D10","D3","D4","D5"]');
  });

  test('Получение всех поколений модели', () async {
    final result = await ServerMethods.getGenerationsFromModel('Giulietta');

    print(result);

    String goodRes = '[{"generation":"III Рестайлинг","startYear":2016,"endYear":2020},{"generation":"III","startYear":2010,"endYear":2016},{"generation":"II","startYear":1977,"endYear":1985},{"generation":"I","startYear":1954,"endYear":1963}]';

    expect(result, goodRes);
  });

  test('Получение регламента обслуживания автомобиля', () async {
    final result = await ServerMethods.getServices('Alfa Romeo', 'Giulietta', 'III Рестайлинг');

    print(result);

    String goodRes = '[{"title":"проверка приводных ремней","period":15},{"title":"проверка вакумных трубок ","period":15},{"title":"Замена топливного фильтра","period":60},{"title":"Замена свечей зажигания","period":45},{"title":"Замена масла в двигателе","period":15},{"title":"Замена масляного фильтра","period":15},{"title":"Проверка воздушного фильтра двигателя","period":15},{"title":"Замена воздушного фильтра двигателя","period":45},{"title":"Замена воздушного фильтра салона","period":15},{"title":"Проверка тормозной жидкости и жидкости в прив","period":15},{"title":"Замена тормозной жидкости и жидкости в привод","period":30},{"title":"Проверка стояночного тормоза","period":30},{"title":"Проверка жидкости в КПП","period":30}]';

    expect(result, goodRes);
  });

  test('Вход в аккаунт', () async {
    String result = await ServerMethods.login('blablabla', 'blablabla@blabla.bla');

    print(result);

    if(result != 'No user'){
      result = 'good';
    }

    expect(result, 'good');
  });

  test('Получение автомобилей пользователя', () async {
    String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0aW1lIjoiU3VuIE1heSAxNSAyMDIyIDE5OjA2OjU3IEdNVCswMzAwIChSVFogMiAo0LfQuNC80LApKSIsInVzZXJQYXMiOiI0OTJmM2YzOGQ2YjVkM2NhODU5NTE0ZTI1MGUyNWJhNjU5MzViY2RkOWY0ZjQwYzEyNGI3NzNmZTUzNmZlZTdkIiwidXNlck5hbWUiOiJibGFibGFibGFAYmxhLmJsYSIsImlhdCI6MTY1MjYzMDgxN30.FzPvomiLgEG3ouhd9fViVsORgRVQNRMKB00igpTEvvQ';

    String goodRes = '[{"name":"bmw","image":"5-15-2022 20-5-59-default-car.png","cost":10000000,"millage":12000,"spendings":[{"name":"Замена масла","description":"Залил ориг","idPlanned":false,"date":"13-01-2021","millage":1000000,"type":"Замена масла"}]},{"name":"bmw","image":"default-car.png","cost":10000000,"millage":12000,"spendings":[{"name":"Заправка","description":"На Shel","idPlanned":false,"date":"11-11-2011","millage":10000,"type":"Заправка"},{"name":"Мойка","description":"С обезжиркой","idPlanned":false,"date":"12-12-2012","millage":123456,"type":"Мойка"}]}]';
    final result = await ServerMethods.getUserCars(token);

    print(result);

    expect(result, goodRes);
  });

  test('Получение картинки пользователя', () async {
    final result = await ServerMethods.getUserPhoto('defUser.png');

    print(result);

    Image image = await Image.asset('assets/default-profile.png');

    expect(result.color, image.color);
  });

  test('Получение картинки автомобиля', () async {
    final result = await ServerMethods.getCarPhoto('default-car.png');

    print(result);

    Image image = await Image.asset('assets/default-car.png');

    expect(result.color, image.color);
  });

  test('Добавление пользователя', () async {

    String result = await ServerMethods.addUser('testuser', 'testusertest@qwerty.qwerty', File('C:/Users/maksi/Documents/maksi/Documents/Study/Diplom/flutter_app/assets/default-profile.jpg'));

    if(result.length > 50){
      result = 'qwerty';
    }

    expect(result, 'qwerty');
  });

  /*test('Добавление автомобиля', () async {

    String result = await ServerMethods.addUserCar('audi', 2000000, 12000, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0aW1lIjoiTW9uIE1heSAxNiAyMDIyIDIzOjQyOjI2IEdNVCswMzAwIChSVFogMiAo0LfQuNC80LApKSIsInVzZXJQYXMiOiI2NWU4NGJlMzM1MzJmYjc4NGM0ODEyOTY3NWY5ZWZmM2E2ODJiMjcxNjhjMGVhNzQ0YjJjZjU4ZWUwMjMzN2M1IiwidXNlck5hbWUiOiJxd2VydHlxd2VydHlAcXdlcnR5LnF3ZXJ0eSIsImlhdCI6MTY1MjczMzc0Nn0.BsqNV8y3atGAU1KOmgBpJRxd9m0MQgT8bbgFjDg0keQ' , File('C:/Users/maksi/Documents/maksi/Documents/Study/Diplom/flutter_app/assets/default-car.png', 3));

    var id = jsonDecode(result)['id'].toString();

    expect(id, '4');
  });*/

  test('Добавление затраты', () async {

    String result = await ServerMethods.addSpending(4, 'Раскоксовка двигателя', 'Делал в проверенном сервисе', false, DateTime.now().year.toString() + '-' + DateTime.now().month.toString() + '-' + DateTime.now().day.toString()  , 130000, 'Ремонт', 4000);

    var id = jsonDecode(result)['id'].toString();

    expect(id, '7');
  });

  test('Связь автомобиля пользователя с автомобилем из базы', () async {
    String result = await ServerMethods.addCar_IdToUserCar(2, 'Alpina', 'B5', 'F10/F11 Рестайлинг');

    expect(result, 'Ok');
    
  });
}