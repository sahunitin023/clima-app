// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:clima_app/utilities/constants.dart';
import 'package:clima_app/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen(this.locationWeather);
  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temp;
  late String condition;
  late String tempIcon;
  late String city;
  late String background;
  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather, 'location_background.jpg');
  }

  void updateUI(dynamic weatherData, String image) {
    setState(() {
      if (weatherData == null) {
        temp = 0;
        city = '';
        condition = 'Unable to fetch Weather Data!!';
        tempIcon = 'Error';
        return;
      }
      double tempareture = weatherData['main']['temp'];
      temp = tempareture.toInt();
      tempIcon = weather.getWeatherIcon(weatherData['weather'][0]['id']);
      city = weatherData['name'];
      condition = weather.getMessage(temp);
      background = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$background'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData, 'location_background.jpg');
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CityScreen(),
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData, 'city_background.jpg');
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.place,
                    size: 35.0,
                    color: Color.fromARGB(255, 244, 46, 32),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    city,
                    style: const TextStyle(
                      fontFamily: 'Spartan MB',
                      fontSize: 30.0,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Text(
                      '$temp??',
                      style: kTempTextStyle,
                    ),
                    Text(
                      tempIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  condition,
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
