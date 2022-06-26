import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/data/UserData.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

List<Spending> getSpendings() {
  List<Spending> result = [];

  for (var car in UserData.userCars) {
    for (var spending in car.spending) {
      result.add(Spending(spending.cost, spending.date));
    }
  }

  result.sort((a, b) => a.date.compareTo(b.date));

  print(result.length);

  return result;
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {

  int lastmonth = getSpendings().last.date.month.toInt();

  int razn = 11 - lastmonth;

  int month = (value.toInt() <= razn? 11 - (razn - value.toInt()) : value.toInt() - razn-1);

  const style = TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.w300,
    fontSize: 8,
  );
  Widget text;
  switch (month) {
    case 0:
      text = const Text('Jan', style: style);
      break;
    case 1:
      text = const Text('Feb', style: style);
      break;
    case 2:
      text = const Text('Mar', style: style);
      break;
      case 3:
      text = const Text('Apr', style: style);
      break;
    case 4:
      text = const Text('May', style: style);
      break;
    case 5:
      text = const Text('June', style: style);
      break;
      case 6:
      text = const Text('July', style: style);
      break;
    case 7:
      text = const Text('Aug', style: style);
      break;
    case 8:
      text = const Text('Sep', style: style);
      break;
      case 9:
      text = const Text('Oct', style: style);
      break;
    case 10:
      text = const Text('Nov', style: style);
      break;
    case 11:
      text = const Text('Dec', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return Padding(child: text, padding: const EdgeInsets.only(top: 8.0));
}

class _StatisticState extends State<Statistic> {
  late List<Spending> AllSpendings;
  late List<FlSpot> AllSpots = getSpots();

  @override
  Widget build(BuildContext context) {

    AllSpendings = getSpendings();
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
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width - 50,
                ),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_back_ios))),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Статистика расходов",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Общие расходы:",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 405,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: LineChart(LineChartData(
                          minX: 0,
                          maxX: 11,
                          minY: 0,
                          maxY: getMaxY(AllSpots) + getMaxY(AllSpots) * .1,
                          clipData: FlClipData.all(),
                          backgroundColor: const Color(0xffE5E5EA),
                          titlesData: FlTitlesData(
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitleWidgets,
                                )
                              )
                          ),
                          lineBarsData: [
                            LineChartBarData(
                                isCurved:  true,
                                //isStepLineChart: true,
                                spots: getSpots(), color: const Color(0xff007AFF))
                          ],
                          borderData: FlBorderData(show: true),
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: const Color(0xff37434d),
                                strokeWidth: 1,
                              );
                            },
                            drawVerticalLine: true,
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: const Color(0xff37434d),
                                strokeWidth: 1,
                              );
                            },
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  double getMaxY(List<FlSpot> spots) {
    double max = spots.first.y;
    for (var spot in spots) {
      if (max < spot.y) {
        max = spot.y;
      }
    }
    return max;
  }

  List<FlSpot> getSpots() {
    DateTime lastDate = AllSpendings.last.date;
    DateTime firstDate = lastDate.add(const Duration(days: -365));

    double o = 0;
    double t = 0;
    double th = 0;
    double fo = 0;
    double fi = 0;
    double si = 0;
    double se = 0;
    double e = 0;
    double n = 0;
    double te = 0;
    double el = 0;
    double tw = 0;

    for(int i = AllSpendings.length - 1; i >= 0; i--){
      if(AllSpendings[i].date.isAfter(firstDate)){
        int month = lastDate.month - AllSpendings[i].date.month;
        if(month < 0){
          month = AllSpendings[i].date.month - lastDate.month;
        } else {
          month = 11 - (lastDate.month - AllSpendings[i].date.month);
        }
        switch (month){
            case 0:
            {
              o += AllSpendings[i].cost;
              break;
            }
            case 1:
            {
              t += AllSpendings[i].cost;
              break;
            }
            case 2:
            {
              th += AllSpendings[i].cost;
              break;
            }
            case 3:
            {
              fo += AllSpendings[i].cost;
              break;
            }
            case 4:
            {
              fi += AllSpendings[i].cost;
              break;
            }
            case 5:
            {
              si += AllSpendings[i].cost;
              break;
            }
            case 6:
            {
              se += AllSpendings[i].cost;
              break;
            }
            case 7:
            {
              e += AllSpendings[i].cost;
              break;
            }
            case 8:
            {
              n += AllSpendings[i].cost;
              break;
            }
            case 9:
            {
              te += AllSpendings[i].cost;
              break;
            }
            case 10:
            {
              el += AllSpendings[i].cost;
              break;
            }
            case 11:
            {
              tw += AllSpendings[i].cost;
              break;
            }
        }
      } else {
        break;
      }
    }

    return [
      FlSpot(0,o),
      FlSpot(1,t),
      FlSpot(2,th),
      FlSpot(3,fo),
      FlSpot(4,fi),
      FlSpot(5,si),
      FlSpot(6,se),
      FlSpot(7,e),
      FlSpot(8,n),
      FlSpot(9,te),
      FlSpot(10,el),
      FlSpot(11,tw),
    ];
  }
}

class Spending {
  int cost;
  DateTime date;

  Spending(this.cost, this.date);
}
