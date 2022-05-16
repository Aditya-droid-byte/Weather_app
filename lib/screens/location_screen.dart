import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

class LocationScreen extends StatefulWidget {
  final weatherData;
  LocationScreen({this.weatherData});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  String place;
  int temperature;
  int conditions;
  String weatherIcon;
  String weatherMessage;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        place = "";
        weatherIcon = "error";
        weatherMessage = "Unable to get weather data";
        return;
      }
      conditions = weatherData['weather'][0]['id'];
      place = weatherData['name'];
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      weatherIcon = weather.getWeatherIcon(conditions);
      weatherMessage = weather.getMessage(temperature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.near_me,
                            size: 50.0,
                            color: Colors.white,
                          ),
                          Text(
                            'Locate Me',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.namedCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: Column(
                      children: [
                        Icon(Icons.location_city,
                            size: 50.0, color: Colors.white),
                        Text(
                          'Get weather by city name',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $place!",
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
