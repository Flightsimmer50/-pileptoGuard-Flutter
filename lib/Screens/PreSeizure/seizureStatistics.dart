import 'package:epilepto_guard/Components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class SeizureStatistics extends StatefulWidget {
  @override
  State<SeizureStatistics> createState() => _SeizureStatisticsState();
}

class _SeizureStatisticsState extends State<SeizureStatistics> {
  int _selectedIndex = 4;

  final Map<String, double> dataMap = {
    'January': 30.0,
    'December': 50.0,
    'November': 20.0,
  };

  final List<Color> colorList = [
    Color(0xFFEE83A3),
    Color(0xFF6B6CE7),
    Color(0xFFC987E1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Seizure Statistics', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFC987E1),
        ),
        drawer: Drawers(
          selectedIndex: _selectedIndex,
          onItemTapped: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/splash_screen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Number of seizures in the last three months',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF3B3DE5),
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 1000),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 1.7,
                  initialAngleInDegree: 0,
                  chartType: ChartType.disc,
                  colorList: colorList,
                  centerText: "",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                    showLegends: true,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                    chartValueStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}