import 'dart:ui';
import 'package:epilepto_guard/Screens/Forum/ForumPage.dart';
import 'package:epilepto_guard/Components/drawer.dart';
import 'package:epilepto_guard/Screens/Bluetooth/MainPageBluetooth.dart';
import 'package:epilepto_guard/Screens/Crise/formulaireQuotidien.dart';
import 'package:epilepto_guard/colors.dart';
import 'package:epilepto_guard/consts.dart';
import 'package:epilepto_guard/widgets/heartBeat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:epilepto_guard/Screens/PreSeizure/detectedSigns.dart';
import 'package:epilepto_guard/Screens/PreSeizure/healthData.dart';
import 'package:epilepto_guard/Screens/PreSeizure/seizureStatistics.dart';
import 'package:epilepto_guard/Screens/UserProfil/profileScreen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'Calendar/CalendarScreen.dart';
import 'package:weather_icons/weather_icons.dart';
import 'dart:convert'; // Importez pour utiliser json.decode
import 'package:http/http.dart'
    as http; // Importez pour effectuer des requêtes HTTP

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

//marwenapi
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String cityName = "Tunis";

  @override
  void initState() {
    super.initState();
    // _wf.currentWeatherByLocation();
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  //************************************************************ */

  Icon getWeatherIcon(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear':
        return Icon(WeatherIcons.day_sunny);
      case 'clouds':
        return Icon(WeatherIcons.day_cloudy);
      case 'rain':
        return Icon(WeatherIcons.rain);
      case 'snow':
        return Icon(WeatherIcons.snow);
      case 'thunderstorm':
        return Icon(WeatherIcons.thunderstorm);
      default:
        return Icon(WeatherIcons.alien);
    }
  }

  Future<String> fetchWeatherData(String city) async {
    final apiKey = '55d01bf8725c76115d1b1c6d31fecae5';
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=Tunis&appid=$apiKey'));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      final weatherCondition = weatherData['weather'][0]['main'];
      return weatherCondition;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarScreen(),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image de fond
                          _weather != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/background/weather/${_weather!.weatherIcon}.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/background/background.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          // Contenu du Stack
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWeatherUI(), // Affichez votre méthode _buildWeatherUI() ici
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //*****************2*********************** */
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPageBluetooth(),
                        ),
                      );
                      // Action à effectuer lorsque l'image est cliquée
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/3DPics/settings2.png',
                              ),
                              fit: BoxFit
                                  .cover,

                            ),
                          ),

                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Icon(
                                Icons.phonelink_ring,
                                size: 40,
                                color: Color.fromARGB(255, 127, 79, 135),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Pair to Device',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 127, 79, 135),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //*************3********************************* */
          Expanded(
            child: _buildClickableCardWithBackgroundImage(
              context,
              'assets/images/background/formulaire-quotidien.jpg',
              'How are you doing today ?\nAre you experiencing any symptoms?',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormulaireQuotidien(
                      id: 'some_unique_id',
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeartBeat(),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/3DPics/heartbeat.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumPage(),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/3DPics/forum.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: _buildClickaaableCardWithBackgroundImage(
                //     context,
                //     'assets/images/background/mmm.jpg',
                //     '',
                //     () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => ForumPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableCardWithWeather(BuildContext context, Color color,
      String title, String weatherCondition, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getWeatherIcon(weatherCondition),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableCard(
      BuildContext context, Color color, String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClickableCardWithBackgroundImage(BuildContext context,
      String backgroundImage, String title, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickaaableCardWithBackgroundImage(BuildContext context,
      String imagePath, String cardText, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip
            .antiAlias, // Assurez-vous que l'image ne dépasse pas les bords arrondis
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Bords arrondis pour la carte
        ),
        elevation: 5, // Ombre sous la carte pour un effet de profondeur
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover, // Couvre tout l'espace disponible
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(
                    0.5), // Assombrir légèrement l'image pour améliorer la lisibilité du texte
                BlendMode.dstATop,
              ),
            ),
          ),
          alignment: Alignment.center, // Centrer le texte sur la carte
          child: Text(
            cardText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
          margin: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.25,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 226, 217, 241).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("EEEE, MM-dd").format(now),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormat("hh:mm a").format(now),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      _weather?.areaName ?? "No Area Name",
                      style: const TextStyle(fontSize: 16),
                    ), // Add some spacing between columns
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 217, 241)
                                .withOpacity(0.2),
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
                              Text(
                                "${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
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
