import 'dart:ui';

import 'package:epilepto_guard/Components/drawer.dart';
import 'package:epilepto_guard/models/drug.dart';
import 'package:epilepto_guard/Screens/Drugs/ListDrug.dart';
import 'package:epilepto_guard/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:epilepto_guard/Screens/Drugs/add.dart';
import '../../colors.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:epilepto_guard/services/drugService.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
   int _selectedIndex = 1;
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  String cityName = "Tunis";

  final DrugService drugService = DrugService();
  List<Drug> drugs = [];

  final Map<DateTime, List<Drug>> _events = {};

  @override
  void initState() {
    super.initState();
    fetchDrugs();
    // _wf.currentWeatherByLocation();
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  Future<void> fetchDrugs() async {
    try {
      List<Drug> fetchedDrugs = await drugService.getAllDrugs();
      setState(() {
        drugs = fetchedDrugs;
        _events.clear(); // Clear existing events
        for (var drug in drugs) {
          if (drug.startTakingDate != null) {
            DateTime startDate = DateTime(
              drug.startTakingDate!.year,
              drug.startTakingDate!.month,
              drug.startTakingDate!.day,
            );
            // Check if the date already exists in _events
            if (_events.containsKey(startDate)) {
              // Add the drug to the existing list
              _events[startDate]!.add(drug);
            } else {
              // Create a new list with the drug
              _events[startDate] = [drug];
            }
          }
        }
      });
    } catch (e) {
      print('Error loading drugs: $e');
      // Handle errors loading drugs
    }
  }

  Future<void> _refresh() async {
    // Mettez à jour la liste des drugs
    await fetchDrugs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: _weather != null
                  ? DecorationImage(
                      image: AssetImage(
                          'assets/images/background/weather/${_weather!.weatherIcon}.png'),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image:
                          AssetImage('assets/images/background/background.png'),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Column(
              children: [
                _buildWeatherUI(),
                _buildCalendarUI(),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                _showSelectionPopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Add',
                    style: TextStyle(fontSize: 18.0, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSelectionPopup(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Center(child: Text('Add Drug')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMedicineScreen()),
                );
              },
            ),
            ListTile(
              title: Center(child: Text('List of Drugs')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListDrug()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarUI() {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.65,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) => MonthView(
                          key: ValueKey(_events
                              .length), // Force rebuild when _events changes
                          controller:
                              CalendarControllerProvider.of(context).controller,
                          cellBuilder: (date, events, isToday, isInMonth) {
                            List<Widget> children = [];

                            // Add date number
                            children.add(
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.turquoise
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color:
                                        isInMonth ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );

                            // Add events for the date
                            if (_events.containsKey(date)) {
                              _events[date]!.forEach((event) {
                                children.add(
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    alignment: Alignment.center,
                                    child: Text(
                                      event
                                          .name, // Assuming 'name' is a property of your Drug model
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            );
                          },
                          onCellTap: (events, date) {
                            // Handle cell tap event here
                            print('Cell tapped: $date');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      DateTime now = _weather!.date!;

      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.2,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat("EEEE, MMMM dd").format(now),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            DateFormat("hh:mm a").format(now),
                            style: const TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16), // Add some spacing between columns
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weather?.areaName ?? "No Area Name",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.purple.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image.network(
                                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    Text(
                                      _weather?.weatherDescription ??
                                          "No Description",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
                                style: const TextStyle(fontSize: 28),
                              ),
                            ],
                          ),
                          Text(
                            "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
