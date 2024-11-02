import 'package:epilepto_guard/Components/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetectedSigns extends StatefulWidget {
  @override
  State<DetectedSigns> createState() => _DetectedSignsState();
}

class _DetectedSignsState extends State<DetectedSigns> {
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detected Signs Visualization', style: TextStyle(color: Colors.white)),
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
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/splash_screen.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: LineChartWidget(),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              height: 300, // Specify a fixed height
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(1, 0),
                        FlSpot(2, 2),
                        FlSpot(3, 1),
                        FlSpot(4, 1),
                        FlSpot(5, 1),
                        FlSpot(6, 0),
                        FlSpot(7, 1),
                        FlSpot(8, 1.5),
                      ],
                      isCurved: false,
                      color: Color(0xFFEE83A3),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Detected Signs Visualization',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),),
          ],
        ),
      ),
    );
  }
}
